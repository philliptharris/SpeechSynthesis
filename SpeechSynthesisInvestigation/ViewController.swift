//
//  ViewController.swift
//  SpeechSynthesisInvestigation
//
//  Created by Person on 12/12/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        logAllAvailableVoices()
        
//        AVSpeechSynthesisVoice.speechVoices().forEach { voice in
//            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(component: "\(voice.language)_\(voice.name).caf")
//            let utterance = AVSpeechUtterance(string: "Bite down on your back teeth.")
//            utterance.voice = voice
//            writeUtterance(utterance, to: url)
//        }
    }
    
    private func writeUtterance(_ utterance: AVSpeechUtterance, to url: URL) {
        var audioFile: AVAudioFile?
        synthesizer.write(utterance) { buffer in
            try! Self.handleAudioBuffer(buffer: buffer, url: url, file: &audioFile)
        }
    }
    
    private static func handleAudioBuffer(buffer: AVAudioBuffer, url: URL, file: inout AVAudioFile?) throws {
        print("writing buffer to \(url.lastPathComponent)")
        guard let pcmBuffer = buffer as? AVAudioPCMBuffer else { fatalError() }
        guard pcmBuffer.frameLength > 0 else { fatalError() }
        if file == nil {
            print("AVAudioPCMBuffer settings = \(pcmBuffer.format.settings)")
            file = try AVAudioFile(forWriting: url, settings: pcmBuffer.format.settings, commonFormat: .pcmFormatFloat32, interleaved: false)
        }
        try file?.write(from: pcmBuffer)
    }
    
    private func logAllAvailableVoices() {
        var lines: [String] = []
        lines.append("language-id,locale,name,gender,quality,novelty,identifier")
        AVSpeechSynthesisVoice.speechVoices().forEach { voice in
            lines.append("\(voice.language),\(Locale.current.localizedString(forIdentifier: voice.language)!),\(voice.name),\(voice.gender),\(voice.quality),\(voice.voiceTraits.contains(.isNoveltyVoice) ? "Novelty" : "Normal"),\(voice.identifier)")
        }
        let output = lines.joined(separator: "\n")
        print(output)
    }
}

extension AVSpeechSynthesisVoiceQuality: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:    return "Default"
        case .enhanced:   return "Enhanced"
        case .premium:    return "Premium"
        @unknown default: return "Unknown"
        }
    }
}

extension AVSpeechSynthesisVoiceGender: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unspecified: return "Unspecified"
        case .male:        return "Male"
        case .female:      return "Female"
        @unknown default:  return "Unknown"
        }
    }
}
