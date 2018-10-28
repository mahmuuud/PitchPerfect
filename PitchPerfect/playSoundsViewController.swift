//
//  playSoundsViewController.swift
//  PitchPerfect
//
//  Created by mahmoud mohamed on 10/27/18.
//  Copyright © 2018 mahmoud mohamed. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundsViewController: UIViewController {
    var audioUrl:URL!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode:AVAudioPlayerNode!
    var audioFile:AVAudioFile!
    var stopTimer:Timer!
    @IBOutlet weak var snailBtn: UIButton!
    @IBOutlet weak var rabbitBtn: UIButton!
    @IBOutlet weak var highPitchBtn: UIButton!
    @IBOutlet weak var lowPitchBtn: UIButton!
    @IBOutlet weak var echoBtn: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var reverbBtn: UIButton!
    
    //MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        configureUI(playing: false)
    }
    
    //MARK: play function
    @IBAction func play(sender:UIButton){
        configureUI(playing: true)
        switch sender {
        case snailBtn:
            playBack(rate:0.5)
        case rabbitBtn:
            playBack(rate:1.5)
        case highPitchBtn:
            playBack(pitch:1000)
        case lowPitchBtn:
            playBack(pitch:-1000)
        case echoBtn:
            playBack(echo:true)
        case reverbBtn:
            playBack(reverb:true)
        default:
            let alert = UIAlertController(title: "ERROR", message: "Error applying effect", preferredStyle: .alert)
            self.present(alert,animated: true)
        }
    }
    
    //MARK:stop playing function
    @IBAction func stopPlaying(_ sender: Any) {
        stopAudio()
        configureUI(playing: false)
    }
    //MARK: UI configuration Function
    func configureUI(playing:Bool){
        if playing{
            snailBtn.isEnabled=false
            rabbitBtn.isEnabled=false
            highPitchBtn.isEnabled=false
            lowPitchBtn.isEnabled=false
            echoBtn.isEnabled=false
            reverbBtn.isEnabled=false
            stop.isEnabled=true
        }

        if !playing{
            snailBtn.isEnabled=true
            rabbitBtn.isEnabled=true
            highPitchBtn.isEnabled=true
            lowPitchBtn.isEnabled=true
            echoBtn.isEnabled=true
            reverbBtn.isEnabled=true
            stop.isEnabled=false
        }
    }

}
