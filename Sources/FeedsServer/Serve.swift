//
//  Serve.swift
//  feeds
//
//  Created by admin on 30/04/25.
//



import ArgumentParser
import GRPCCore
import GRPCNIOTransportHTTP2

/// Command-line entry for starting the gRPC Feeds server using ArgumentParser.
/// It listens on a specified port and serves unary RPC calls.
struct Serve: AsyncParsableCommand {
  static let configuration = CommandConfiguration(abstract: "Starts an echo server.")

  /// Port number for the server to listen on. Defaults to 9100.
  /// This can be overridden from the command line.
  @Option(help: "The port to listen on")
  var port: Int = 9100

  /// Executes the server start routine.
  /// - Creates a gRPC server using HTTP/2 transport over NIO.
  /// - Registers the ServiceHandler for handling incoming RPC calls.
  /// - Prints the server address if successfully started.
  /// - Waits for the server task group to complete.
  func run() async throws {
      print("entered run()")
    // Initialize the gRPC server with HTTP/2 NIO transport.
    // The server binds to the specified IPv4 address and port.
    let server = GRPCServer(
      transport: .http2NIOPosix(
        address: .ipv4(host: "127.0.0.1", port: self.port),
        transportSecurity: .plaintext
      ),
      services: [ServiceHandler()]
    )

    // Launch the server asynchronously and monitor its status.
    // Once running, retrieve and print the listening address.
    try await withThrowingDiscardingTaskGroup { group in
      group.addTask { try await server.serve() }
      if let address = try await server.listeningAddress {
        print("FeedsServer listening on \(address)")
      }
    }
//      try await server.onClose.GetFeeds
    // This line is printed after the server is closed or task group completes.
  }
}
