//
//  CAAnimation.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/15/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

extension CAAnimation {
  
  typealias AnimationRange = (from: Any?, to: Any?)
  typealias Value = (timing: TimeInterval, value: Any)
  
  struct AnimationConfiguration {
    
    var duration: TimeInterval = 0.0
    var beginTime: TimeInterval = 0.0
    var repeatCount: Float = 1
    var autoreverses = false
    var isRemovedOnCompletion = true
    var type: CAMediaTimingFunctionName = .default
  }
  
  private func setupAnimation(configuration: AnimationConfiguration) -> CAAnimation {
    
    duration = configuration.duration
    beginTime = configuration.beginTime
    isRemovedOnCompletion = configuration.isRemovedOnCompletion
    autoreverses = configuration.autoreverses
    repeatCount = configuration.repeatCount
    timingFunction = CAMediaTimingFunction(name: configuration.type)
    
    return self
  }
  
  static func group(_ animations: [CAAnimation],
                    configuration: AnimationConfiguration) -> CAAnimation {
    
    let animationGroup = CAAnimationGroup()
    animationGroup.animations = animations
    return animationGroup.setupAnimation(configuration: configuration)
  }
  
  static func animation(for keyPath: String,
                        range: AnimationRange) -> CAAnimation {
    
    let animation = CABasicAnimation(keyPath: keyPath)
    animation.fromValue = range.from
    animation.toValue = range.to
    return animation
  }
  
  static func timingAnimation(for keyPath: String,
                              values: [Value]) -> CAAnimation {
    
    let animation = CAKeyframeAnimation(keyPath: keyPath)
    animation.values = values.map({ $0.value })
    animation.keyTimes = values.map({ NSNumber(value: $0.timing) })
    return animation
  }
}
