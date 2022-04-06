//
//  Player.swift
//
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Fluent
import FluentPostgresDriver
import Vapor

final class Player: Model, Content {
    static let schema = "players"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String
    
    @Field(key: "triesRemaining")
    var triesRemaining: Int
    
    @Field(key: "guessed")
    var guessed: Int

    init() { }

    init(id: UUID? = nil, username: String, triesRemaining: Int = 5, guessed: Int = 0) {
        self.id = id
        self.username = username
        self.triesRemaining = triesRemaining
        self.guessed = guessed
    }
}
