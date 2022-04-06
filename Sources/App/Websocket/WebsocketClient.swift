//
//  WebsocketClient.swift
//  
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Vapor

open class WebSocketClient {
    open var id: UUID
    open var socket: WebSocket

    public init(id: UUID, socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
}
