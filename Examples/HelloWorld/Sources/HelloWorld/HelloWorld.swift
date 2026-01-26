import GraphQL
import GraphQLVapor
import Vapor

@main
struct HelloWorld {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        let app = try await Application.make(env)

        let schema = try GraphQLSchema(
            query: GraphQLObjectType(
                name: "Query",
                fields: [
                    "hello": GraphQLField(
                        type: GraphQLString,
                        resolve: { _, _, _, _ in
                            "World"
                        }
                    ),
                ]
            ),
            subscription: GraphQLObjectType(
                name: "Subscription",
                fields: [
                    "hello": GraphQLField(
                        type: GraphQLString,
                        description: "Emits `world` every 3 seconds",
                        resolve: { eventResult, _, _, _ in
                            eventResult
                        },
                        subscribe: { _, _, anyContext, _ in
                            let context = anyContext as! GraphQLContext
                            return AsyncThrowingStream<String, Error> { continuation in
                                context.subscriptionTask = Task {
                                    for i in 0 ..< 10000 {
                                        try await Task.sleep(for: .seconds(3))
                                        try Task.checkCancellation()
                                        continuation.yield("World for the \(i) time")
                                    }
                                }
                            }
                        }
                    ),
                ]
            )
        )
        app.graphql(schema: schema, config: .init(subscriptionProtocols: [.websocket])) { _ in
            GraphQLContext()
        }

        do {
            try await app.execute()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    class GraphQLContext: @unchecked Sendable {
        var subscriptionTask: Task<Void, Error>?

        deinit {
            subscriptionTask?.cancel()
        }
    }
}
