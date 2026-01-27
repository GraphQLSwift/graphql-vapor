import GraphQL
import Vapor

struct GraphQLHandler<
    Context: Sendable,
    WebSocketInit: Equatable & Codable & Sendable
>: Sendable {
    let schema: GraphQLSchema
    let config: GraphQLConfig<WebSocketInit>
    let computeContext: @Sendable (Request) async throws -> Context

    init(
        schema: GraphQLSchema,
        config: GraphQLConfig<WebSocketInit>,
        computeContext: @Sendable @escaping (Request) async throws -> Context
    ) {
        self.schema = schema
        self.config = config
        self.computeContext = computeContext
    }
}
