import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        postgresConfig.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(
            configuration: postgresConfig
        ), as: .psql)
    } else {
        fatalError("Connection to database failed")
    }
    
    app.migrations.add(CreatePlayer())
    
    // register websocket route
    let gameSystem = WSHangmanGameSystem(
        eventLoop: app.eventLoopGroup.next(),
        database: app.db
    )
    
    app.webSocket("start") { req, ws async in
        await gameSystem.connect(req, ws)
    }
}
