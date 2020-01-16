//
//  CAGradientLayer+Extension.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/15/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

extension CAGradientLayer {
  
  struct GradientConfiguration {
    
    var startPoint: CGPoint
    var endPoint: CGPoint
    var opacity: Float
  }
  
  static func axial(frame: CGRect,
                    locations: [NSNumber]?,
                    colors: [CGColor]) -> CAGradientLayer {
    
    let radialLayer = CAGradientLayer()
    radialLayer.frame = frame
    radialLayer.type = .axial
    radialLayer.locations = locations
    radialLayer.colors = colors
    return radialLayer
  }
  
  func offsetGradient(configuration: GradientConfiguration) -> CAGradientLayer {
    startPoint = configuration.startPoint
    endPoint = configuration.endPoint
    opacity = configuration.opacity
    return self
  }
}
