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
      static let translate = "transform.translation.y"
    }
  }
  
  static func focus(scale: CAAnimation.AnimationRange,
                    translate: CAAnimation.AnimationRange,
                    duration: TimeInterval,
                    beginTime: TimeInterval) -> CAAnimation {
    
    return focus(
      scale: scale,
      translate: translate,
      configuration: .init(duration: duration,
                           beginTime: beginTime,
                           isRemovedOnCompletion: false,
                           fillMode: .forwards))
  }
  
  static func pulse(scale: CAAnimation.AnimationRange,
                    opacity: CAAnimation.AnimationRange,
                    duration: TimeInterval,
                    beginTime: TimeInterval) -> CAAnimation {
    return pulse(
      scales: pulseScalesTiming(scale: scale),
      opacities: pulseOpacitiesTiming(opacity: opacity),
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
  
  private static func focus(scale: CAAnimation.AnimationRange,
                     translate: CAAnimation.AnimationRange,
                     configuration: AnimationConfiguration) -> CAAnimation  {
    
    let scale = animation(for: Constants.AnimationKeys.scale, range: scale)
    let translate = animation(for: Constants.AnimationKeys.translate, range: translate)
    
    return .group([translate, scale], configuration: configuration)
  }
  
  private static func pulseOpacitiesTiming(opacity: CAAnimation.AnimationRange) -> [Value] {
    return [
      (0 / 1.0, opacity.from),
      (0.1 / 1.0, opacity.to),
      (0.2 / 1.0, opacity.from),
      (1 / 1.0, opacity.from)]
  }
  
  private static func pulseScalesTiming(scale: CAAnimation.AnimationRange) -> [Value] {
    return [
      (0 / 1.0, scale.from),
      (0.1 / 1.0, scale.to),
      (0.2 / 1.0, scale.from),
      (1 / 1.0, scale.from)]
  }
}
