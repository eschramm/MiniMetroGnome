//
//  SoundPickerTVC.swift
//  MiniMetroGnome
//
//  Created by Eric Schramm on 3/9/18.
//  Copyright © 2018 Eric Schramm. All rights reserved.
//

import UIKit

protocol SoundPickerDelegate : AnyObject {
    func soundPicker(soundPicker: SoundPickerTVC, didSelectSound sound: ClickSound)
}

class SoundPickerTVC: UITableViewController {
    
    weak var delegate: SoundPickerDelegate?
    let clicks = allClicks()
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clicks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = clicks[indexPath.row].rawValue
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.soundPicker(soundPicker: self, didSelectSound: clicks[indexPath.row])
        }
    }
}
