//
//  EchoPulseLayer.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/15/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

final class EchoPulseLayer {
  
  typealias EchoPulseLayerValue =
    (layer: CAGradientLayer,
    opacity: CGFloat)
  
  typealias AuxCalculations =
    (gradientOffset: EchoPulseGradientLayer.GradientOffset,
    gradientOpacity: CGFloat,
    shapeRadius: CGFloat)
  
  private enum Constants {
    static let radiusOffset: CGFloat = 10
    static let minRadius: CGFloat = 85
    static let defaultRadiusMulitiplicator: CGFloat = 1.0
  }
  
  private(set) var layers: [EchoPulseLayerValue] = []
  
  static func pulseLayer(frame: CGRect,
                         radiusMultiplicator: CGFloat = Constants.defaultRadiusMulitiplicator) -> EchoPulseLayer {
    
    let pulseLayer = EchoPulseLayer()
    
    for position in 0..<EchoPulseGradientLayer.Constants.gradientOffsets.count {
      
      let auxCalculations = calculateAuxes(shparePosition: position,
                                             frame: frame,
                                             radiusMultiplicator: radiusMultiplicator)
      let shapeLayer = createShapeLayer(frame: frame, radius: auxCalculations.shapeRadius)
      let gradient = gradientLayer(frame: frame, auxCalculations: auxCalculations)
      gradient.mask = shapeLayer
      
      pulseLayer.layers.append((gradient, auxCalculations.gradientOpacity))
    }
    return pulseLayer
  }
  
  static private func gradientLayer(frame: CGRect, auxCalculations: AuxCalculations) -> CAGradientLayer {
    
    let gradientConfiguration = CAGradientLayer.GradientConfiguration(
      startPoint: auxCalculations.gradientOffset.startPosition,
      endPoint: auxCalculations.gradientOffset.endPosition,
      opacity: Float(auxCalculations.gradientOpacity))
    let gradientLayer = EchoPulseGradientLayer.layer(frame: frame,
                                                     configuration: gradientConfiguration)
    return gradientLayer
  }
  
  static private func calculateAuxes(shparePosition: Int,
                                     frame: CGRect,
                                     radiusMultiplicator: CGFloat) -> AuxCalculations  {
    
    var gradientOffset = EchoPulseGradientLayer.Constants.gradientOffsets[EchoPulseGradientLayer.Constants.gradientOffsets.count - 1 - shparePosition]
    gradientOffset = (CGPoint(x: gradientOffset.startPosition.x / frame.width, y: gradientOffset.startPosition.y / frame.height), CGPoint(x: gradientOffset.endPosition.x / frame.width, y: gradientOffset.endPosition.y / frame.height))
    let gradientOpacity = 1 - CGFloat(shparePosition) / CGFloat(EchoPulseGradientLayer.Constants.gradientOffsets.count)
    let radius = Constants.minRadius + CGFloat(shparePosition) * Constants.radiusOffset * radiusMultiplicator
    
    return (gradientOffset, gradientOpacity, radius)
  }
  
  static private func createShapeLayer(frame: CGRect,
                                       radius: CGFloat) -> CAShapeLayer {
    
    let shapeConfiguration = CAShapeLayer.ShapeConfiguration(
      position: CGPoint(x: frame.midX, y: frame.midY),
      radius: radius)
    let echoShapeLayer = CAShapeLayer.roundLayer(configuration: shapeConfiguration)
    let rectr = CGRect(origin: .zero, size: CGSize(width: radius * 2, height: radius * 2))
    echoShapeLayer.path = CGPath(roundedRect: rectr, cornerWidth: rectr.width / 2, cornerHeight: rectr.height / 2, transform: nil)
    echoShapeLayer.position = CGPoint(x: frame.midX - radius, y: frame.midY - radius)
   
    return echoShapeLayer
  }
}
