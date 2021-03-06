//
//  ViewController.swift
//  MiniMetroGnome
//
//  Created by Eric Schramm on 3/9/18.
//  Copyright © 2018 Eric Schramm. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

enum ClickSound: String {
    case fingerSnap = "Finger Snap"
    case woodBlock = "Wood Block"
    
    func fileExtension() -> String {
        switch self {
        case .fingerSnap:
            return "mp3"
        case .woodBlock:
            return "wav"
        }
    }
    
    func fileName() -> String {
        switch self {
        case .fingerSnap:
            return "fingerSnap"
        case .woodBlock:
            return "woodBlock"
        }
    }
}

func allClicks() -> [ClickSound] {
    return [ClickSound.fingerSnap, .woodBlock]
}

class AudioPlayer {
    
    let clicks = allClicks()
    let soundIDs: [ClickSound : SystemSoundID]
    
    init() {
        var sounds = [ClickSound : SystemSoundID]()
        for click in clicks {
            let url = Bundle.main.url(forResource: click.fileName(), withExtension: click.fileExtension())! as CFURL
            var systemSoundID = SystemSoundID()
            AudioServicesCreateSystemSoundID(url, &systemSoundID)
            sounds[click] = systemSoundID
        }
        soundIDs = sounds
    }
    
    deinit {
        for (_, sound) in soundIDs {
            AudioServicesDisposeSystemSoundID(sound)
        }
    }
    
    func play(sound: ClickSound) {
        if let systemSoundID = soundIDs[sound] {
            AudioServicesPlaySystemSound(systemSoundID)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var bpmField: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var clickSound: UILabel!
    
    @IBOutlet weak var tapGestureRecognizer: UITapGestureRecognizer!
    
    var audioPlayer: AVAudioPlayer!
    var timer: Timer?
    var soundPicker: UIPickerView?
    let soundPlayer = AudioPlayer()
    var bpm: Int = 60
    
    let numberFormatter = NumberFormatter()
    
    @IBAction func buttonToggled(sender: AnyObject) {
        dismissKeyboard(sender: sender)
        guard let buttonTitle = toggleButton.title(for: .normal) else { return }
        
        if buttonTitle == "Start" {
            startTimer()
        } else if buttonTitle == "Stop" {
            stopTimer()
        }
    }
    
    @objc func timerFired() {
        guard let soundTitle = clickSound.text, let sound = ClickSound(rawValue: soundTitle) else { return }
        soundPlayer.play(sound: sound)
    }
    
    @IBAction func sliderChanged(sender: AnyObject) {
        dismissKeyboard(sender: sender)
        let number = Int(slider.value)
        bpm = number
        bpmField.text = "\(bpm)"
        stopTimer()
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        bpmField.resignFirstResponder()
    }
    
    func startTimer() {
        let interval: TimeInterval = 60 / Double(bpm)
        let localTimer = Timer(fireAt: Date(), interval: interval, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        timer = localTimer
        RunLoop.main.add(localTimer, forMode: RunLoopMode.commonModes)
        toggleButton.setTitle("Stop", for: .normal)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        toggleButton.setTitle("Start", for: .normal)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectSound", let soundPickerTVC = segue.destination as? SoundPickerTVC {
            dismissKeyboard(sender: self)
            soundPickerTVC.delegate = self
        }
    }
}

extension ViewController : SoundPickerDelegate {
    func soundPicker(soundPicker: SoundPickerTVC, didSelectSound sound: ClickSound) {
        stopTimer()
        clickSound.text = sound.rawValue
        navigationController?.popViewController(animated: true)
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let number = numberFormatter.number(from: textField.text!) {
            if number.intValue >= 40, number.intValue <= 200 {
                bpm = number.intValue
                slider.value = number.floatValue
            } else {
                textField.text = numberFormatter.string(from: NSNumber(value: bpm))
            }
            stopTimer()
        }
    }
}
