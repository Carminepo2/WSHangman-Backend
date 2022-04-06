//
//  WebsocketMessage.swift
//  
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Vapor

struct WebsocketMessage<T: Codable>: Codable {
    let client: UUID
    let data: T
}

extension ByteBuffer {
    func decodeWebsocketMessage<T: Codable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
