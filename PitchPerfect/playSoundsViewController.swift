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
    var audioNode:AVAudioPlayerNode!
    var audioFile:AVAudioFile!
    var stopTimer:Timer!
    @IBOutlet weak var snailBtn: UIButton!
    @IBOutlet weak var rabbitBtn: UIButton!
    @IBOutlet weak var highPitchBtn: UIButton!
    @IBOutlet weak var lowPitchBtn: UIButton!
    @IBOutlet weak var echoBtn: UIButton!
    @IBOutlet weak var reverbBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(playing: false)
    }
    
    func configureUI(playing:Bool){
        if playing{
            snailBtn.isEnabled=false
            rabbitBtn.isEnabled=false
            highPitchBtn.isEnabled=false
            lowPitchBtn.isEnabled=false
            echoBtn.isEnabled=false
            reverbBtn.isEnabled=false
            stopBtn.isEnabled=true
        }
        
        if !playing{
            snailBtn.isEnabled=true
            rabbitBtn.isEnabled=true
            highPitchBtn.isEnabled=true
            lowPitchBtn.isEnabled=true
            echoBtn.isEnabled=true
            reverbBtn.isEnabled=true
            stopBtn.isEnabled=false
        }
    }

}
