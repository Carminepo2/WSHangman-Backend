//
//  PlayerClient.swift
//  
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Vapor
import FluentKit

final class PlayerClient: WebSocketClient {
    
    let player: Player
    
    public init(socket: WebSocket, player: Player) {
        self.player = player
        
        super.init(id: player.id!, socket: socket)
    }
}
