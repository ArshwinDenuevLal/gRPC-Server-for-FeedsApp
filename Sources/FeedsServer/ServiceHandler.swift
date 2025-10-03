//
//  ServiceHandler.swift
//  Feeds
//
//  Created by admin on 30/04/25.
//


///  implementation to invoke the `getFeeds` gRPC method and print the server response.
/// This serves as the main entry point for running the gRPC client.
import Foundation
import ArgumentParser
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

protocol ServiceHandlerType {}
final class ServiceHandler: FeedsService.SimpleServiceProtocol, ServiceHandlerType  {
    
    func getFeeds(request: FeedsRequest, context: ServerContext) async throws -> FeedsResponse {
        print("Initiated: getFeeds")
        var response = FeedsResponse()
        print("response instance created")
        do {
            let url = URL(filePath:"/Users/admin/gRPC-Server---FeedsApp/Feeds/Sources/FeedsServer/Resources/FeedsJSON.json")
            let jsonString = try String(contentsOf: url, encoding: .utf8)
            print(jsonString)
            response.message = jsonString
        } catch {
            print("Error loading JSON file: \(error)")
        }
        return response
       
    }
}

