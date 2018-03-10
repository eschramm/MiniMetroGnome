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

    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var clickSound: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    var timer: Timer?
    var soundPicker: UIPickerView?
    let soundPlayer = AudioPlayer()
    var bpm: Int = 60
    
    @IBAction func buttonToggled(sender: AnyObject) {
        
        guard let buttonTitle = toggleButton.title(for: .normal) else { return }
        
        stopTimer()
        
        if buttonTitle == "Start" {
            toggleButton.setTitle("Stop", for: .normal)
            let interval: TimeInterval = 60 / Double(bpm)
            guard let soundTitle = clickSound.text, let sound = ClickSound(rawValue: soundTitle) else { return }
            let localTimer = Timer(fire: Date(), interval: interval, repeats: true, block: { (_) in
               self.soundPlayer.play(sound: sound)
            })
            timer = localTimer
            RunLoop.main.add(localTimer, forMode: RunLoopMode.commonModes)
        } else if buttonTitle == "Stop" {
            toggleButton.setTitle("Start", for: .normal)
        }
    }
    
    @IBAction func sliderChanged(sender: AnyObject) {
        let number = Int(slider.value)
        bpm = number
        bpmLabel.text = "\(bpm) bpm"
        stopTimer()
    }
    
    func stopTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectSound", let soundPickerTVC = segue.destination as? SoundPickerTVC {
            soundPickerTVC.delegate = self
        }
    }
}

extension ViewController : SoundPickerDelegate {
    func soundPicker(soundPicker: SoundPickerTVC, didSelectSound sound: ClickSound) {
        stopTimer()
        toggleButton.setTitle("Start", for: .normal)
        clickSound.text = sound.rawValue
        navigationController?.popViewController(animated: true)
    }
}
