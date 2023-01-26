//
//  Sound.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/24/23.
//

import AVFoundation

struct SoundManager {
    enum SoundOption: UInt32 {
        case startGame      = 1335
        case successfulMove = 1057
        case revertMove     = 1004
        case emptyCell      = 1306
        case ballReduced    = 1022
        case failedMove     = 1305
        case gameOver       = 1325
    }
    
    static func play(_ sound: SoundOption) {
        AudioServicesPlaySystemSound(sound.rawValue)
    }
}
