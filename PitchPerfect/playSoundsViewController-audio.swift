//
//  playSoundsViewController-audio.swift
//  PitchPerfect
//
//  Created by mahmoud mohamed on 10/28/18.
//  Copyright © 2018 mahmoud mohamed. All rights reserved.
//

import UIKit
import AVFoundation

extension playSoundsViewController: AVAudioPlayerDelegate {
    
    func setupAudio(){
        do{
            try audioFile=AVAudioFile(forReading: audioUrl!)
        }
        catch{
            let alert = UIAlertController(title: "ERROR", message: "File not Found", preferredStyle: .alert)
            self.present(alert,animated: true)
            
        }
    }
    
    func playback(pitch:Float?=nil,rate:Float?=nil,echo:Bool=false,reverb:Bool=false){
        audioEngine=AVAudioEngine()
        audioNode=AVAudioPlayerNode()
        audioEngine.attach(audioNode)
        
        let pitchNode=AVAudioUnitTimePitch()
        
        if let pitch=pitch{
            pitchNode.pitch=pitch
        }
        
        if let rate=rate{
            pitchNode.rate=rate
        }
        audioEngine.attach(pitchNode)
        
        let echoNode=AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        let reverbNode=AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix=50
        audioEngine.attach(reverbNode)
        
        if echo && reverb{
            connectAudioNodes(echoNode,audioNode,reverbNode,audioEngine.outputNode)
        }
        
        if echo{
            connectAudioNodes(echoNode,audioNode,audioEngine.outputNode)
        }
        
        if reverb{
            connectAudioNodes(reverbNode,audioNode,audioEngine.outputNode)
        }
        
        audioNode.stop()
        audioNode.scheduleFile(audioFile,at:nil)
        
        var delayInSeconds: Double = 0
        if let lastRenderTime = self.audioNode.lastRenderTime, let playerTime = self.audioNode.playerTime(forNodeTime: lastRenderTime) {
            
            if let rate = rate {
                delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
            } else {
                delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
            }
        }
        
        self.stopTimer=Timer(timeInterval: delayInSeconds, target: self, selector: #selector(playSoundsViewController.stopAudio), userInfo: nil, repeats: false)
        RunLoop.main.add(stopTimer!, forMode: RunLoop.Mode.default)
        
        do{
            try audioEngine.start()
            
        }
        catch{
            let alert = UIAlertController(title: "ERROR", message: "Error Playing", preferredStyle: .alert)
            self.present(alert,animated: true)
        }
        audioNode.play()
        configureUI(playing: true)
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    @objc func stopAudio(){
        configureUI(playing: false)
        if let audioNode=audioNode{
            audioNode.stop()
        }
        
        if let _=stopTimer{
            stopTimer.invalidate()
        }
        
        if let audioEngine=audioEngine{
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    

}
