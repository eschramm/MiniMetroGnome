//
//  ViewController.swift
//  MiniMetroGnome
//
//  Created by Eric Schramm on 3/9/18.
//  Copyright © 2018 Eric Schramm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var toggleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonToggled(sender: AnyObject) {
        guard let buttonTitle = toggleButton.title(for: .normal) else { return }
        if buttonTitle == "Start" {
            toggleButton.setTitle("Stop", for: .normal)
        } else if buttonTitle == "Stop" {
            toggleButton.setTitle("Start", for: .normal)
        }
    }
    
    @IBAction func sliderChanged(sender: AnyObject) {
        let bpm = Int(slider.value)
        bpmLabel.text = "\(bpm) bpm"
    }


}

