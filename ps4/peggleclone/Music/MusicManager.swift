//
//  MusicManager.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import Foundation
import AVFoundation

class MusicManager {
    static let shared = MusicManager()
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var ballBounceMusicPlayer: AVAudioPlayer?

    private init() {
    }

    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "background-music", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                guard let audioPlayer = backgroundMusicPlayer else {
                    return
                }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
//                print(error)
            }
        }
    }

    func ballBounceMusic() {
        if let bundle = Bundle.main.path(forResource: "ball-bounce", ofType: "wav") {
            let ballBounce = NSURL(fileURLWithPath: bundle)
            do {
                ballBounceMusicPlayer = try AVAudioPlayer(contentsOf: ballBounce as URL)
                guard let audioPlayer = ballBounceMusicPlayer else {
                    return
                }
                audioPlayer.play()
            } catch {
//                print(error)
            }
        }
    }
}
