//
//  Sound.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/24/23.
//

import AVFoundation

struct SoundManager {
    enum SoundOption: UInt32 {
        case startGame      = 1004
        case successfulMove = 1057
        case revertMove     = 1026
        case emptyCell      = 1015
        case ballReduced    = 1006
        case failedMove     = 1016
        case gameOver       = 1031
    }
    
    static func playSound(_ sound: SoundOption) {
        AudioServicesPlaySystemSound(sound.rawValue)
    }
}
