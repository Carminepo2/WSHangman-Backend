//
//  CreatePlayer.swift
//
//
//  Created by Carmine Porricelli on 26/03/22.
//

import Fluent
import FluentPostgresDriver

struct CreatePlayer: AsyncMigration {
    func prepare(on database: Database) async throws {
        
        try await database.schema("players")
            .id()
            .field("username", .string, .required)
            .field("triesRemaining", .int, .sql(.default(5)))
            .field("guessed", .int, .sql(.default(0)))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("players").delete()
    }
}
