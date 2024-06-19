//
//  VoiceRecorderService.swift
//  WhatsAppClone
//
//  Created by Thomas on 19/06/2024.
//

import Foundation
import AVFoundation
import Combine

final class VoiceRecorderService {
    private var audioRecorder: AVAudioRecorder?
    @Published private(set) var isRecording = false
    @Published private(set) var elapsedTime: TimeInterval = 0
    private var startTime: Date?
    private var timer: AnyCancellable?
    
    deinit {
        tearDown()
        print("VoiceRecorderService has been deinited")
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.overrideOutputAudioPort(.speaker)
            try audioSession.setActive(true)
            print("VoiceRecorderService: successfully setUp AVAudioSession")
        } catch {
            print("VoiceRecorderService: Failed to setUp AVAudioSession")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = Date().toString(format: "dd-MM-YY 'at' HH:mm:ss") + ".m4a"
        let audioFileURL = documentPath.appendingPathComponent(audioFileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            startTime = Date()
            startTimer()
            print("VoiceRecorderService: successfully setUp AVAudioSession")
        } catch {
            print("VoiceRecorderService: Failed to setUp AVAudioRecorder")
        }
    }
    
    func stopRecording(completion: ((_ audioURL: URL?, _ audioDuration: TimeInterval) -> Void)? = nil) {
        guard isRecording else { return }
        
        let audioDuration = elapsedTime
        audioRecorder?.stop()
        isRecording = false
        timer?.cancel()
        elapsedTime = 0
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            guard let audioURL = audioRecorder?.url else { return }
            completion?(audioURL, audioDuration)
        } catch {
            print("VoiceRecorderService: Failed to teardown AVAudioSession")
        }
    }
    
    func tearDown() {
        if isRecording { stopRecording() }
        let fileManaer = FileManager.default
        let folder = fileManaer.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderContents = try! fileManaer.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
        deleteRecordings(folderContents)
        print("VoiceRecorderService was successfully teared down")
    }
    
    private func deleteRecordings(_ urls: [URL]) {
        for url in urls {
           deleteRecording(at: url)
        }
    }
    
    func deleteRecording(at fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Audio file was deleted at \(fileURL)")
        } catch {
            print("Failed to delete file")
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let startTime = self?.startTime else { return }
                self?.elapsedTime = Date().timeIntervalSince(startTime)
                print("VoiceRecorderService: elapsedTime: \(self?.elapsedTime)")
            }
    }
}
