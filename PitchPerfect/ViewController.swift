//
//  ViewController.swift
//  PitchPerfect
//
//  Created by mahmoud mohamed on 10/27/18.
//  Copyright © 2018 mahmoud mohamed. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    var audioRecorder:AVAudioRecorder!
    var audioSession:AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureUI(recording: false)
    }
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recording: true)
        let x=NSSearchPathForDirectoriesInDomains(.userDirectory, .userDomainMask, true)[0] as String
        let fileName="new.wav"
        let path=[x,fileName]
        let filePath=URL(string:path.joined(separator: "/"))
        let s=AVAudioSession.sharedInstance()
        try! s.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try! audioRecorder=AVAudioRecorder(url: filePath!, settings: [:])
        try! s.setActive(true, options: .notifyOthersOnDeactivation)
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled=true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        let s=AVAudioSession.sharedInstance()
        try! s.setActive(false, options: .notifyOthersOnDeactivation)
        audioRecorder.stop()
        configureUI(recording: false)
        
    }
    
    func configureUI(recording: Bool){
        if recording{
            recordBtn.isEnabled=false
            stopBtn.isEnabled=true
        }
        
        if !recording{
            recordBtn.isEnabled=true
            stopBtn.isEnabled=false
        }
    }

}

