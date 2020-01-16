//
//  EchoPulseView.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/15/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

final class EchoPulseView: NSView {
  
  private enum Constants {
    
    static let layerBackgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
    static let animationDuration: TimeInterval = 3.0
    static let itemAnimationDuration: TimeInterval = 0.1
    static let itemsAnimationDuration: TimeInterval = 2.5
    
    enum InBoundAnimation {
      static let key = "in-bound-pulse-animation"
      static let scaleFactor: Float = 1.02
    }
    
    enum OutBoundAnimation {
      static let key = "out-bound-pulse-animation"
      static let scaleFactor: Float = 0.98
    }
  }
  
  private struct AnimationConfiguration {
    
    enum Direction {
      case outBound
      case inBound
      
      var key: String {
        switch self {
        case .outBound: return Constants.OutBoundAnimation.key
        case .inBound: return Constants.InBoundAnimation.key
        }
      }
    }
    
    let direction: Direction
    let scale: Float
    let duration: TimeInterval
    
    static var outBound: AnimationConfiguration {
      return .init(direction: .outBound,
                   scale: Constants.OutBoundAnimation.scaleFactor,
                   duration: Constants.itemAnimationDuration)
    }
    
    static var inBound: AnimationConfiguration {
      return .init(direction: .inBound,
                   scale: Constants.InBoundAnimation.scaleFactor,
                   duration: Constants.itemAnimationDuration)
    }
    
    func beginTime(timePosition: Int) -> TimeInterval {
      return direction == .inBound
        ? CACurrentMediaTime() + Constants.itemsAnimationDuration - Double(timePosition + 1) * Constants.itemAnimationDuration
        : CACurrentMediaTime() + Double(timePosition + 1) * Constants.itemAnimationDuration
    }
  }
  
  private var animationTimer: Timer?
  
  enum EchoState {
    case inBound
    case outBound
    case still
  }
  
  enum EchoMode {
    case device
    case search
  }

  var pulseLayer: EchoPulseLayer!
  var aligmentBottomEdge: CGFloat = 0
  
  var mode: EchoMode = .device {
    didSet {
      switch mode {
      case .device: shiftToDeviceMode()
      case .search: shiftToSearchMode()
      }
    }
  }
  var state: EchoState = .still {
    didSet {
      switch state {
      case .still: noAnimate()
      case .inBound: animateInBound()
      case .outBound: animateOutBound()
      }
    }
  }
  override var alignmentRectInsets: NSEdgeInsets {
      return NSEdgeInsets(top: 0, left: 0, bottom: aligmentBottomEdge, right: 0)
  }
  
  func initialize() {
    
    initializeParentLayer()
    
    shiftToSearchMode()
  }
  
  private func initializeParentLayer() {
    
    wantsLayer = true
    layer = CALayer()
    layer?.masksToBounds = false
    layer?.backgroundColor = Constants.layerBackgroundColor
  }
  
  // MARK: - Animations -
  
  func animateOutBound() {
    animate(configuration: EchoPulseView.AnimationConfiguration.outBound)
  }

  func animateInBound() {
    animate(configuration: EchoPulseView.AnimationConfiguration.inBound)
  }
  
  private func animate(configuration: AnimationConfiguration) {
    
    stopTimer()
    animationTimer = Timer.scheduledTimer(withTimeInterval: Constants.animationDuration, repeats: true, block: { [weak self] timer in
      
      self?.pulseLayer.layers.enumerated().forEach { (offset, item) in
        
        let animation = CAAnimation.pulse(scale: configuration.scale,
                                          opacity: Float(item.opacity),
                                          duration: configuration.duration,
                                          beginTime: configuration.beginTime(timePosition: offset))
        item.layer.add(animation, forKey: configuration.direction.key)
      }
    })
  }
  
  func noAnimate() {
    
    stopTimer()
    pulseLayer.layers.forEach { $0.layer.removeAllAnimations() }
  }
  
  private func stopTimer() {
    if animationTimer != nil {
      animationTimer?.invalidate()
      animationTimer = nil
    }
  }
  
  // MARK: - Representations -
  
  func shiftToSearchMode() { shiftLayers() }
  func shiftToDeviceMode() { shiftLayers(layerAligment: 700, radiusScaleFactor: 3.0) }
  
  private func shiftLayers(layerAligment: CGFloat = 0.0,
                           radiusScaleFactor: CGFloat = 1.0) {
    
    updateLayerAligment(to: layerAligment)
    removeEchoLayer()
    
    pulseLayer = EchoPulseLayer.pulseLayer(frame: bounds, radiusMultiplicator: radiusScaleFactor)
    pulseLayer.layers.forEach { layer?.addSublayer($0.layer) }
  }
  
  private func updateLayerAligment(to bottomAligment: CGFloat) {
    aligmentBottomEdge = bottomAligment
    layoutSubtreeIfNeeded()
  }
  
  private func removeEchoLayer() {
    if pulseLayer != nil {
      pulseLayer.layers.forEach {
        $0.layer.removeAllAnimations()
        $0.layer.removeFromSuperlayer()
      }
      pulseLayer = nil
    }
  }
}
