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
    
    static let itemDefalutScaleFactor: CGFloat = 1.0
    static let opacityDefaultValue: CGFloat = 1.0
    static let focusScaleFactor: CGFloat = 3.0
    
    enum InBoundAnimation {
      static let key = "in-bound-pulse-animation"
      static let scaleFactor: CGFloat = 1.02
    }
    
    enum OutBoundAnimation {
      static let key = "out-bound-pulse-animation"
      static let scaleFactor: CGFloat = 0.98
    }
    
    enum FocusAnimation { static let key = "focus-animation" }
    enum UnfocusAnimation { static let key = "unfocus-animation" }
  }
  
  private struct AnimationConfiguration {
    
    enum Direction {
      case outBound
      case inBound
      case focus
      case unfocus
      
      var scale: Any {
        
        switch self {
        case .outBound: return Constants.OutBoundAnimation.scaleFactor
        case .inBound: return Constants.InBoundAnimation.scaleFactor
        case .focus: return (Constants.itemDefalutScaleFactor, Constants.focusScaleFactor)
        case .unfocus: return (Constants.focusScaleFactor, Constants.itemDefalutScaleFactor)
        }
      }
      
      var key: String {
        switch self {
        case .outBound: return Constants.OutBoundAnimation.key
        case .inBound: return Constants.InBoundAnimation.key
        case .focus: return Constants.FocusAnimation.key
        case .unfocus: return Constants.UnfocusAnimation.key
        }
      }
      
      func beginTime(count: Int, timePosition: Int) -> TimeInterval {
        switch self {
        case .outBound: return CACurrentMediaTime() + Double(timePosition + 1) * Constants.itemAnimationDuration
        case .inBound: return CACurrentMediaTime() + TimeInterval(count) / 10.0 - Double(timePosition + 1) * Constants.itemAnimationDuration
        case .focus: return CACurrentMediaTime()
        case .unfocus: return CACurrentMediaTime()
        }
      }
    }
    
    let direction: Direction
    let duration: TimeInterval
    
    static var outBound: AnimationConfiguration {
      return .init(direction: .outBound, duration: Constants.animationDuration)
    }
    
    static var inBound: AnimationConfiguration {
      return .init(direction: .inBound, duration: Constants.animationDuration)
    }
    
    static var focus: AnimationConfiguration {
      return .init(direction: .focus, duration: Constants.animationDuration)
    }
    
    static var unfocus: AnimationConfiguration {
      return .init(direction: .unfocus, duration: Constants.animationDuration)
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
  private var isFocused: Bool = false
  
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
    
    initializePulse()
    
    shiftToSearchMode(animated: false)
  }
  
  private func initializeParentLayer() {
    
    wantsLayer = true
    layer = CALayer()
    layer?.masksToBounds = false
    layer?.backgroundColor = Constants.layerBackgroundColor
  }
  
  private func initializePulse(radiusScaleFactor: CGFloat = 1.0) {
    
    guard pulseLayer == nil else { return }
    
    self.pulseLayer = EchoPulseLayer.pulseLayer(frame: self.bounds, radiusMultiplicator: radiusScaleFactor)
    self.pulseLayer.layers.forEach { self.layer?.addSublayer($0.layer) }
  }
  
  private func removePulse() {
    
    guard pulseLayer != nil else { return }
  
    pulseLayer.layers.forEach {
      $0.layer.removeAllAnimations()
      $0.layer.removeFromSuperlayer()
    }
    pulseLayer = nil
  }
  
  // MARK: - Animations -
  
  func animateOutBound() {
    animate(configuration: EchoPulseView.AnimationConfiguration.outBound)
  }
  
  func animateInBound() {
    animate(configuration: EchoPulseView.AnimationConfiguration.inBound)
  }
  
  func animateFocus(animated: Bool = true) {
    isFocused = true
    animateFocus(configuration: EchoPulseView.AnimationConfiguration.focus, animated: animated)
  }
  
  func animateUnfocus(animated: Bool = true) {
    isFocused = false
    animateFocus(configuration: EchoPulseView.AnimationConfiguration.unfocus, animated: animated)
  }
  
  private func animate(configuration: AnimationConfiguration) {
    
    stopTimer()
    
    let countOfLayers = pulseLayer.layers.count
    animationTimer = Timer.scheduledTimer(withTimeInterval: Constants.animationDuration, repeats: true, block: { [weak self] timer in
      
      self?.pulseLayer.layers.enumerated().forEach { (offset, item) in
        
        let defaultScaleFactor = self?.isFocused == false
          ? Constants.itemDefalutScaleFactor
          : Constants.focusScaleFactor
        
        let scaleFactor = self?.isFocused == false
          ? configuration.direction.scale as! CGFloat
          : configuration.direction.scale as! CGFloat * Constants.focusScaleFactor
        
        let animation = CAAnimation.pulse(scale: (defaultScaleFactor, scaleFactor),
                                          opacity: (item.opacity, Constants.opacityDefaultValue),
                                          duration: configuration.duration,
                                          beginTime: configuration.direction.beginTime(count: countOfLayers,
                                                                                       timePosition: offset))
        item.layer.add(animation, forKey: configuration.direction.key)
      }
    })
  }
  
  func noAnimate() { stopTimer() }
  
  private func stopTimer() {
    
    guard animationTimer != nil else { return }

    animationTimer?.invalidate()
    animationTimer = nil
  }
  
  deinit { stopTimer(); removePulse() }
  
  // MARK - Representation -
  
  func shiftToSearchMode(animated: Bool = true) {
    
    removePulseAnimation()
    animateUnfocus(animated: animated)
  }
  func shiftToDeviceMode(animated: Bool = true) {
    
    removePulseAnimation()
    animateFocus(animated: animated)
  }
  
  private func removePulseAnimation() {
    
    pulseLayer.removeAnimations(key: Constants.InBoundAnimation.key)
    pulseLayer.removeAnimations(key: Constants.OutBoundAnimation.key)
  }
  
  private func animateFocus(configuration: AnimationConfiguration, animated: Bool = true) {
    
    pulseLayer.layers.enumerated().forEach { (offset, item) in
      
      let countOfLayers = pulseLayer.layers.count
      let translateY = !isFocused
        ? (-bounds.size.height, 0)
        : (0, -bounds.size.height)
      
      let animation = CAAnimation.focus(scale: (configuration.direction.scale as! CAAnimation.AnimationRange),
                                        translate: translateY,
                                        duration: animated ? configuration.duration : 0.0,
                                        beginTime: configuration.direction.beginTime(count: countOfLayers,
                                                                                     timePosition: offset))
      item.layer.add(animation, forKey: configuration.direction.key)
    }
  }
}
