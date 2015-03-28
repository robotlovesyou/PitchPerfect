//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by ANDREW SMITH on 09/03/2015.
//  Copyright (c) 2015 Robot Loves You. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var stopPlaybackButton: UIButton!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioEngine.stop()
    }
    
    func playAudioWithProvidedEffect(effect: AVAudioUnit) {
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: completionHandler)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    func playAudioWithVariablePitchAndRate(pitch: Float = 0.0, rate: Float = 1.0){
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        
        playAudioWithProvidedEffect(changePitchEffect)
    }
    
    func playAudioWithRadioTowerEffect() {
        var distortionEffect = AVAudioUnitDistortion()
        distortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechRadioTower)
        distortionEffect.wetDryMix = 25
        
        playAudioWithProvidedEffect(distortionEffect)
    }
    
    func playAudioWithEchoEffect() {
        var delay = AVAudioUnitDelay()
        delay.delayTime = 0.25
        delay.wetDryMix = 50
        
        playAudioWithProvidedEffect(delay)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func completionHandler() {
        // AVFoundation provides no guarantee as to which thread
        // the completion handler is fired on
        // so I'm using GCD to ensure that the stopPlayback buttton 
        // is hidden from the main thread.
        // The choice of dispatch after is to attempt to compensate for the fact
        // that the completion handler fires some time before the end of playback.
        let delayInSeconds = 1.0
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            self.stopPlaybackButton.hidden = true
        }
        
    }
    
    func showStopPlaybackButton() {
        stopPlaybackButton.hidden = false
    }

    @IBAction func playSoundSlowly(sender: UIButton) {
        showStopPlaybackButton()
        playAudioWithVariablePitchAndRate(rate: 0.5)
    }
    
    @IBAction func playSoundQuickly(sender: UIButton) {
        showStopPlaybackButton()
        playAudioWithVariablePitchAndRate(rate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        showStopPlaybackButton()
        playAudioWithVariablePitchAndRate(pitch: 1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        showStopPlaybackButton()
        playAudioWithVariablePitchAndRate(pitch: -1000)
    }
    
    @IBAction func playRadioAudio(sender: UIButton) {
        showStopPlaybackButton()
        playAudioWithRadioTowerEffect()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        showStopPlaybackButton()
        playAudioWithEchoEffect()
    }
    
    @IBAction func stopSound(sender: UIButton) {
        audioEngine.stop()
        stopPlaybackButton.hidden = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
