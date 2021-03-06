//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Justin Knight on 1/3/19.
//  Copyright © 2019 JKnightApps. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // MARK: Variables and Outlets
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: ViewDidLoad and ViewWillAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
    }
    
    // MARK: Begin and Stop Recording Functions
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    
    // MARK: Configuring UI
    func configureUI(_ isRecording: Bool){
        recordButton.isEnabled = isRecording
        stopRecordingButton.isEnabled = !isRecording
        recordingLabel.text = isRecording ? "Tap to Record" : " Recording in progress"
    }
    
    // MARK: Recording Finished
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else { print("recording audio failed")}
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

