//
//  File.swift
//  
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Foundation

struct PlayerGuessMessage: Codable {
    var playerId: UUID
    let guess: String
}
