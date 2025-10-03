//
//  Feeds.swift
//  Feeds
//
//  Created by admin on 29/04/25.
//


/// Entry point for the gRPC server command-line interface.
/// Uses Swift ArgumentParser to parse command-line options and invoke subcommands.
import ArgumentParser

@main
struct Feeds: AsyncParsableCommand {
  /// Defines the command-line configuration for the main `feeds` command.
  /// - commandName: CLI command name used to invoke the tool.
  /// - abstract: Short description shown in help output.
  /// - subcommands: List of available subcommands (e.g., Serve).
  /// - defaultSubcommand: The default command to run if none is specified.
  static let configuration = CommandConfiguration(
    commandName: "feeds",
    abstract: "Server instance with SimpleServiceProtocol",
    subcommands: [Serve.self],
    defaultSubcommand: Serve.self // optional: auto-runs `Serve` if no args
  )
}

// Example usage of the CLI tool to invoke the client-side `getFeeds` command with a message.
// Ensure the Protobuf compiler (protoc) is installed and available in the system path.
//PROTOC_PATH=$(which protoc) swift run getFeeds get --message "FeedsService"
