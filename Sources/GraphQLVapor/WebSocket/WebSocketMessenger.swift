import GraphQLTransportWS
import GraphQLWS
import WebSocketKit

import struct Foundation.Data

/// Messenger wrapper for WebSockets
struct WebSocketMessenger: GraphQLTransportWS.Messenger, GraphQLWS.Messenger {
    let websocket: WebSocket

    func send(_ message: Data) async throws {
        try await websocket.send(String(decoding: message, as: UTF8.self))
    }

    func error(_ message: String, code: Int) async throws {
        try await websocket.send("\(code): \(message)")
        try await websocket.close(code: .init(codeNumber: code))
    }

    func close() async throws {
        try await websocket.close()
    }
}
