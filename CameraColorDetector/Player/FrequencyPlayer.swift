//
//  FrequencyPlayer.swift
//  CameraColorDetector
//
//  Created by דוד נוי on 30/05/2024.
//

import Foundation
import AudioKit

enum Oscillator {
    case oscillator1
    case oscillator2
    case oscillator3
    case oscillator4
    case oscillator5
}

class FrequencyPlayer {
    
    private let engine = AudioEngine()
    private let engineMixer: Mixer
    private let oscillator1 = PlaygroundOscillator(frequency: 0)
    private let oscillator2 = PlaygroundOscillator(frequency: 0)
    private let oscillator3 = PlaygroundOscillator(frequency: 0)
    private let oscillator4 = PlaygroundOscillator(frequency: 0)
    private let oscillator5 = PlaygroundOscillator(frequency: 0)
    
    // MARK: - init and deinit
    
    init() {
        self.engineMixer = Mixer([oscillator1, oscillator2, oscillator3, oscillator4, oscillator5])
        activateAll()
    }
    
    deinit {
        stopAll()
    }
    
    // MARK: - private func
    
    private func activateAll() {
        engine.output = engineMixer
        
        do {
            try engine.start()
            print("engine started")
        } catch {
            print(error, "Field")
        }
        
        oscillator1.start()
        oscillator2.start()
        oscillator3.start()
        oscillator4.start()
        oscillator5.start()
    }
    
    private func stopAll() {
        oscillator1.stop()
        oscillator2.stop()
        oscillator3.stop()
        oscillator4.stop()
        oscillator5.stop()
        engine.stop()
    }
    
    
    // MARK: - public func
    
    func changeFrequency(for oscillator: Oscillator, frequency: Float) {
        switch oscillator {
        case .oscillator1:
            oscillator1.frequency = frequency
        case .oscillator2:
            oscillator2.frequency = frequency
        case .oscillator3:
            oscillator3.frequency = frequency
        case .oscillator4:
            oscillator4.frequency = frequency
        case .oscillator5:
            oscillator5.frequency = frequency
        }
    }
    
}
