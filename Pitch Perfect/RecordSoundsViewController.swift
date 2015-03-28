//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by ANDREW SMITH on 04/03/2015.
//  Copyright (c) 2015 Robot Loves You. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var tapToResumeLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var isPaused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func startRecordingAudio() {
        
        self.showRecordingViews()
        self.recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func resumeRecordingAudio() {
        tapToResumeLabel.hidden = true
        showRecordingViews()
        recordButton.enabled = false
        audioRecorder.record()
        isPaused = false
    }

    @IBAction func recordAudio(sender: UIButton) {
        if isPaused {
            resumeRecordingAudio()
            return
        }
        
        startRecordingAudio()
    }
    
    func setRecordingViewsAreHidden(hidden: Bool) {
        self.recordingLabel.hidden = hidden
        self.tapToRecordLabel.hidden = !hidden
        self.stopButton.hidden = hidden
        self.pauseButton.hidden = hidden
    }
    
    func showRecordingViews() {
        setRecordingViewsAreHidden(false)
    }
    
    func hideRecordingViews() {
        setRecordingViewsAreHidden(true)
    }
    
    @IBAction func pauseRecordingAudio(sender: UIButton) {
        hideRecordingViews()
        tapToResumeLabel.hidden = false
        tapToRecordLabel.hidden = true
        recordButton.enabled = true
        audioRecorder.pause()
        isPaused = true
    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        self.hideRecordingViews()
        self.recordButton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

