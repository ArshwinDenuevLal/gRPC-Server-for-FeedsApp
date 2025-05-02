//  ClientService.swift
//  FeedsApp
//
//  Created by admin on 30/04/25.
//

import Foundation
import ArgumentParser
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

/// Protocol to define the contract for client-side gRPC feed service interactions.
/// Useful for mocking and testing.
protocol ClientServiceType {}

/// Concrete implementation of the client-side gRPC service for feeds.
/// Conforms to both the generated FeedsService client protocol and our custom ClientServiceType.
final class ClientService: FeedsService.ClientProtocol, ClientServiceType  {
    
    /// Makes a unary gRPC call to the `GetFeeds` method using a generic result handler.
    /// This method provides low-level control over serialization, deserialization, and request options.
    ///
    /// - Parameters:
    ///   - request: The serialized gRPC request to send.
    ///   - serializer: Serializer for the request message type.
    ///   - deserializer: Deserializer for the response message type.
    ///   - options: Call options including timeout and headers.
    ///   - handleResponse: Closure to process the gRPC response.
    ///
    /// - Returns: The result of the response handler.
    func getFeeds<Result>(
           request: GRPCCore.ClientRequest<FeedsRequest>,
           serializer: some GRPCCore.MessageSerializer<FeedsRequest>,
           deserializer: some GRPCCore.MessageDeserializer<FeedsResponse>,
           options: GRPCCore.CallOptions,
           onResponse handleResponse: @escaping @Sendable (GRPCCore.ClientResponse<FeedsResponse>) async throws -> Result
    ) async throws -> Result where Result : Sendable {
        
        try await withGRPCClient(
            transport: .http2NIOPosix(
                target: ClientArguments().target,
                transportSecurity: .plaintext
            )
        ) { client in
            print(client)
            return try await client.unary(
                request: request,
                descriptor: FeedsService.Method.GetFeeds.descriptor,
                serializer: serializer,
                deserializer: deserializer,
                options: options,
                onResponse: handleResponse
            )
        }
    }
    
    /// Higher-level wrapper for making a `GetFeeds` gRPC request.
    /// Handles request creation, serialization/deserialization, and result forwarding to a completion block on the main thread.
    ///
    /// - Parameters:
    ///   - request: The raw request object for the feed.
    ///   - completion: Completion block called with success or failure result.
    func getFeedsResult(request: FeedsRequest, completion: @escaping @MainActor (Result<FeedsResponse, Error>) -> Void) async {
        do {  
            // Handle any errors during client initialization or transport setup
            try await withGRPCClient(
                transport: .http2NIOPosix(
                    target: ClientArguments().target,
                    transportSecurity: .plaintext
                )
            ) { client in
                
                // Prepare request and supporting gRPC serializer/deserializer components
                let requestCore = GRPCCore.ClientRequest(message: request)
                let serializer = GRPCProtobuf.ProtobufSerializer<FeedsRequest>()
                let deserializer = GRPCProtobuf.ProtobufDeserializer<FeedsResponse>()
                var options = GRPCCore.CallOptions.defaults
                // Configure default call options including timeout
                options.timeout = .seconds(5)
                do {
                    // Call the lower-level getFeeds method and extract the response message
                    let result = try await self.getFeeds(
                        request: requestCore,
                        serializer: serializer,
                        deserializer: deserializer,
                        options: options,
                        onResponse: { response in
                            
                            return try response.message // Unwrap the message as the Result
                        }
                        
                    )
                    // Ensure the success response is delivered on the main thread
                    await MainActor.run {
                        completion(.success(result))
                    }
                } catch {
                    // Ensure the error is delivered on the main thread
                    await MainActor.run {
                        completion(.failure(error))
                    }
                }
            }
        }catch {
            // Handle any errors during client initialization or transport setup
            print("Error")
        }
    }
}
