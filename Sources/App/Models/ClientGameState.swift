//
//  ClientGameState.swift
//  
//
//  Created by Carmine Porricelli on 28/03/22.
//

import Foundation


struct ClientGameState: Codable {
    let wordToGuess: Array<String?>
    let triesRemaining: UInt8
    let lastGuess: String?
}
