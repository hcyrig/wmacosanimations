//
//  CAAnimation+PulseAnimation.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/16/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

extension CAAnimation {
  
  private enum Constants {
    
    enum AnimationKeys {
      
      static let opacity = "opacity"
      static let scale = "transform.scale"
    }
  }
  
  static func pulse(scale: Float,
                    opacity: Float,
                    duration: TimeInterval,
                    beginTime: TimeInterval) -> CAAnimation {
    return pulse(
      scales: pulseScalesTiming(duration: duration, value: scale),
      opacities: pulseOpacitiesTiming(duration: duration, value: opacity),
      configuration: .init(duration: duration,
                           beginTime: beginTime))
  }
  
  private static func pulse(scales: [Value],
                            opacities: [Value],
                            configuration: AnimationConfiguration) -> CAAnimation {
    
    let opacity = timingAnimation(for: Constants.AnimationKeys.opacity,
                                  values: opacities)
    let scale = timingAnimation(for: Constants.AnimationKeys.scale,
                                values: scales)
    return .group([opacity, scale], configuration: configuration)
  }
  
  private static func pulseOpacitiesTiming(duration: TimeInterval,
                                           value: Float) -> [Value] {
    return [
      (0 / duration, value),
      (0.1 / duration, 1.0),
      (0.2 / duration, value),
      (1 / duration, value)]
  }
  
  private static func pulseScalesTiming(duration: TimeInterval,
                                        value: Float) -> [Value] {
    return [
      (0 / duration, 1.0),
      (0.1 / duration, value),
      (0.2 / duration, 1),
      (1 / duration, 1)]
  }
}
