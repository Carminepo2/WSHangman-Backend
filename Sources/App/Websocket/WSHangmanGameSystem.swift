//
//  File.swift
//  
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Vapor
import FluentKit
import FluentPostgresDriver
import Foundation

class WSHangmanGameSystem {
    let database: Database
    var playerClients: WebsocketClients
    var wordController: WordController
    
    init(eventLoop: EventLoop, database: Database) {
        self.wordController = WordController(database: database)
        self.playerClients = WebsocketClients(eventLoop: eventLoop)
        self.database = database
    }
    
    func connect(_ req: Request, _ ws: WebSocket) async {
        // TODO: Better error handling
        
        // MARK: - First connection
        await handleFirstConnectionAuthentication(req, ws)
        
        ws.onBinary { [unowned self] ws, buffer async in
            //MARK: - User guess handling
            if let guessMsg = buffer.decodeWebsocketMessage(PlayerGuessMessage.self) {
                if let playerClient = playerClients.find(guessMsg.playerId) {
                    await handleReceivedUserGuess(playerClient as! PlayerClient, guess: guessMsg.guess)
                }
                return
            }
            
        }
    }
    
    
    private func handleFirstConnectionAuthentication(_ req: Request, _ ws: WebSocket) async {
        
        let playerId = try? req.query.get(UUID.self, at: "playerId")
        let username = try? req.query.get(String.self, at: "username")
        
        if let playerId = playerId, let username = username {
            var player = try? await Player.find(playerId, on: database)
            
            if player == nil {
                player = Player(id: playerId, username: username)
                try? await player!.save(on: database)
            }
            
            if let player = player {
                let playerClient = PlayerClient(socket: ws, player: player)
                
                self.playerClients.add(playerClient)
                await self.sendCurrentGameState()
            }
        }
    }
    
    private func handleReceivedUserGuess(_ playerClient: PlayerClient, guess: String) async {
        await self.sendCurrentGameState(lastGuess: guess)
    }
    
    
    private func sendCurrentGameState(lastGuess: String? = nil) async {
        
        for playerClient in playerClients.active {
            let triesRemaining =  (playerClient as! PlayerClient).player.triesRemaining
            
            let wordToGuess = wordController.getActiveWord(lastGuess)
            do {
                let encodedGameState = try JSONEncoder().encode(ClientGameState(wordToGuess: wordToGuess, triesRemaining: UInt8(triesRemaining), lastGuess: lastGuess))
                
                try await playerClient.socket.send([UInt8](encodedGameState))
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
