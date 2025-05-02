# gRPC-Server---FeedsApp
code for gRPC Server to serve FeedsApp


#  Feeds

Feeds is the package where all services for server and client is implemented.

# proto

let's discuss about the feed store proto.
.proto is the protocol buffer definition file, which can be called as a blueprint or instruction manual for client server communication.  
This defines our service contract. Here, you can see the FeedsService with a single RPC method, GetFeeds. 
GetFeeds RPC takes a FeedsRequest and returns a FeedsResponse.


# package
  - grpc-swift: Core gRPC Swift implementation
  - grpc-swift-protobuf: Protobuf plugin for generating Swift files
  - grpc-swift-nio-transport: NIO transport layer for gRPC
  - swift-argument-parser: CLI argument parser for Swift commands
  - grpc-swift-protobuf: Plugin used to auto-generate Swift source code from .proto files



    1.    Compile – swift build triggers code-generation from *.proto.
    2.    Run the server – swift run feeds launches Serve.swift via FeedsMain.
    3.    Call the server – Either from your iOS app or via the FeedsClient CLI.
    4.    Iterate – Change the schema in FeedsService.proto, regenerate, and implement the new logic in FeedsProvider.swift.
