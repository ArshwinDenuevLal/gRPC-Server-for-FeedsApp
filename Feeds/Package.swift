// swift-tools-version:6.0
//
//  package.swift
//  FeedsApp
//
//  Created by admin on 29/04/25.
//

import PackageDescription

/// Main package declaration
let package = Package(
  name: "feeds",
  platforms: [.macOS(.v15)],   /// This package targets macOS 15 and above
  products: [
    .executable(name: "feeds", targets: ["feeds"])
  ],
  /// Declares external dependencies used by this package
  /// - grpc-swift: Core gRPC Swift implementation
  /// - grpc-swift-protobuf: Protobuf plugin for generating Swift files
  /// - grpc-swift-nio-transport: NIO transport layer for gRPC
  /// - swift-argument-parser: CLI argument parser for Swift commands
  dependencies: [
    .package(url: "https://github.com/grpc/grpc-swift.git", from: "2.0.0"),
    .package(url: "https://github.com/grpc/grpc-swift-protobuf.git", from: "1.0.0"),
    .package(url: "https://github.com/grpc/grpc-swift-nio-transport.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
  ],
  /// Defines the targets to build, including dependencies and plugin usage
  targets: [
    .executableTarget(name: "feeds", dependencies: [
        .product(name: "GRPCCore", package: "grpc-swift"),
        .product(name: "GRPCNIOTransportHTTP2", package: "grpc-swift-nio-transport"),
        .product(name: "GRPCProtobuf", package: "grpc-swift-protobuf"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
   plugins: [
        .plugin(name: "GRPCProtobufGenerator", package: "grpc-swift-protobuf")
        /// Plugin used to auto-generate Swift source code from .proto files
      ])
  ]
)
