//
//  CAShapeLayer+Extension.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/15/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

extension CAShapeLayer {
  
  struct ShapeConfiguration {
    
    var position: CGPoint
    var radius: CGFloat
    var lineWidth: CGFloat = 1.0
  }
  
  static func roundLayer(configuration: ShapeConfiguration) -> CAShapeLayer {
    
    let arcShape = CAShapeLayer()
    arcShape.fillColor = NSColor.clear.cgColor
    arcShape.strokeColor = NSColor.black.cgColor
    arcShape.lineWidth = configuration.lineWidth
    arcShape.drawsAsynchronously = true
    return arcShape
  }
}
