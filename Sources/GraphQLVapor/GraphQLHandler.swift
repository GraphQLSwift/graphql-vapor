import GraphQL
import Vapor

struct GraphQLHandler<
    Context: Sendable,
    WebSocketInit: Equatable & Codable & Sendable
>: Sendable {
    let schema: GraphQLSchema
    let rootValue: any Sendable
    let config: GraphQLConfig<WebSocketInit>
    let computeContext: @Sendable (Request) async throws -> Context

    init(
        schema: GraphQLSchema,
        rootValue: any Sendable,
        config: GraphQLConfig<WebSocketInit>,
        computeContext: @Sendable @escaping (Request) async throws -> Context
    ) {
        self.schema = schema
        self.rootValue = rootValue
        self.config = config
        self.computeContext = computeContext
    }
}
