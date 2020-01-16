//
//  EchoPulseViewController.swift
//  walter2
//
//  Created by Kostiantyn Girych on 1/16/20.
//  Copyright © 2020 Kostiantyn Girych. All rights reserved.
//

import Cocoa

class EchoPulseViewController: NSViewController {
  
  @IBOutlet private weak var echoView: EchoPulseView!
  @IBOutlet private weak var stateSegmentControl: NSSegmentedControl!
  @IBOutlet private weak var modeSegmentControl: NSSegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    initializeSwithers()
  }
  
  private func configureUI() { echoView.initialize() }
  private func initializeSwithers() { modeSegmentControl.selectedSegment = 1; stateSegmentControl.selectedSegment = 0 }
}

// MARK: - Actions -
extension EchoPulseViewController {
  
  @IBAction private func changeStateControl(control: NSSegmentedControl) {
    switch control.selectedSegment {
    case 0: echoView.state = .still
    case 1: echoView.state = .inBound
    case 2: echoView.state = .outBound
    default: echoView.state = .still
    }
  }
  
  @IBAction private func changeModeControl(control: NSSegmentedControl) {
    switch control.selectedSegment {
    case 0: echoView.mode = .device
    case 1: echoView.mode = .search
    default: echoView.mode = .device
    }
  }
}
