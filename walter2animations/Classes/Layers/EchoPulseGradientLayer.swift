//
//  EchoPulseGradientLayer.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/15/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

final class EchoPulseGradientLayer: CAGradientLayer {
  
  typealias GradientOffset = (startPosition: CGPoint, endPosition: CGPoint)
  
  enum Constants {
    
    static let gradientOffsets: [GradientOffset] = [
      (CGPoint(x: 503.73, y: 418.24), CGPoint(x: 306.91, y: 391.19)),
      (CGPoint(x: 514.44, y: 435.33), CGPoint(x: 296.26, y: 374.2)),
      (CGPoint(x: 522.07, y: 455.51), CGPoint(x: 288.68, y: 354.13)),
      (CGPoint(x: 526, y: 478.21), CGPoint(x: 284.8, y: 331.53)),
      (CGPoint(x: 525.71, y: 502.79), CGPoint(x: 285.13, y: 307.06)),
      (CGPoint(x: 520.8, y: 528.49), CGPoint(x: 290.1, y: 281.47)),
      (CGPoint(x: 510.98, y: 554.5), CGPoint(x: 299.97, y: 255.57)),
      (CGPoint(x: 496.09, y: 579.92), CGPoint(x: 314.91, y: 230.25)),
      (CGPoint(x: 476.14, y: 603.82), CGPoint(x: 334.91, y: 206.45)),
      (CGPoint(x: 451.29, y: 625.27), CGPoint(x: 359.82, y: 185.11)),
      (CGPoint(x: 421.87, y: 643.37), CGPoint(x: 389.29, y: 167.12)),
      (CGPoint(x: 388.36, y: 657.33), CGPoint(x: 422.84, y: 153.27)),
      (CGPoint(x: 351.39, y: 666.37), CGPoint(x: 459.87, y: 144.33)),
      (CGPoint(x: 311.7, y: 669.76), CGPoint(x: 499.61, y: 141.05)),
      (CGPoint(x: 270.21, y: 666.92), CGPoint(x: 541.16, y: 144)),
      (CGPoint(x: 227.88, y: 657.44), CGPoint(x: 583.54, y: 153.58)),
      (CGPoint(x: 185.76, y: 641.1), CGPoint(x: 625.71, y: 170.03)),
      (CGPoint(x: 144.94, y: 617.81), CGPoint(x: 666.57, y: 193.43)),
      (CGPoint(x: 106.57, y: 587.63), CGPoint(x: 705, y: 223.72)),
      (CGPoint(x: 71.78, y: 550.81), CGPoint(x: 739.84, y: 260.6)),
      (CGPoint(x: 41.74, y: 507.79), CGPoint(x: 769.93, y: 303.77)),
      (CGPoint(x: 17.51, y: 459.21), CGPoint(x: 794.21, y: 352.46)),
      (CGPoint(x: 0, y: 405.89), CGPoint(x: 811.77, y: 405.89))
    ] // 23 offsets
    
    static let gradientLocations: [NSNumber] = [0.0,
                                                0.05,
                                                0.12,
                                                0.22,
                                                0.25,
                                                0.3,
                                                0.39,
                                                0.5,
                                                0.75,
                                                1] // 10 locations
    
    static let gradientColors = [NSColor(rgb: 0xfaa92e).cgColor,
                                  NSColor(rgb: 0xf9a02d).cgColor,
                                  NSColor(rgb: 0xf6862a).cgColor,
                                  NSColor(rgb: 0xf25d25).cgColor,
                                  NSColor(rgb: 0xf04d23).cgColor,
                                  NSColor(rgb: 0xe84f35).cgColor,
                                  NSColor(rgb: 0xd25564).cgColor,
                                  NSColor(rgb: 0xb45da4).cgColor,
                                  NSColor(rgb: 0x52b3e5).cgColor,
                                  NSColor(rgb: 0x4c5eaa).cgColor] // 10 colors
  }
  
  static func layer(frame: CGRect,
                    configuration: CAGradientLayer.GradientConfiguration) -> CAGradientLayer {
    
    return CAGradientLayer.axial(frame: frame,
                                  locations: Constants.gradientLocations,
                                  colors: Constants.gradientColors).offsetGradient(configuration: configuration)
  }
}
