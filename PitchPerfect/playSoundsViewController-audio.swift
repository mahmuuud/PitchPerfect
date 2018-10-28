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
             audioFile=try AVAudioFile(forReading: audioUrl as URL)
            print(audioFile)
        }
        catch{
            let alert = UIAlertController(title: "ERROR", message: "File not Found", preferredStyle: .alert)
            self.present(alert,animated: true)
            
        }
    }
    
    func playBack(pitch:Float?=nil,rate:Float?=nil,echo:Bool=false,reverb:Bool=false){
        audioEngine=AVAudioEngine()
        audioPlayerNode=AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
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
        if echo  && reverb  {
            connectAudioNodes(audioPlayerNode, pitchNode, echoNode, reverbNode, audioEngine.outputNode)
        }
        if echo{
            connectAudioNodes(audioPlayerNode,pitchNode,echoNode,audioEngine.outputNode)
        }
        
        if reverb{
            connectAudioNodes(audioPlayerNode,pitchNode,reverbNode,audioEngine.outputNode)
        }
        else{
            connectAudioNodes(audioPlayerNode,pitchNode,audioEngine.outputNode)
        }
        
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            self.stopTimer=Timer(timeInterval: delayInSeconds, target: self, selector: #selector(playSoundsViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer, forMode: RunLoop.Mode.default)
    }
        do{
            try audioEngine.start()
        }
        catch{
            let alert = UIAlertController(title: "ERROR", message: "File not Found", preferredStyle: .alert)
            self.present(alert,animated: true)
        }
        
        audioPlayerNode.play()
        
    }
    
    @objc func stopAudio(){
        if let audioPlayerNode=audioPlayerNode{
            audioPlayerNode.stop()
        }
        
        if let stopTimer=stopTimer{
            stopTimer.invalidate()
        }
        configureUI(playing: false)
        if let audioEngine=audioEngine{
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    

}

