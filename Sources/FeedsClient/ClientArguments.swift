/*
 * Copyright 2024, gRPC Authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/// This file defines the structure for command-line arguments used by the gRPC client.
/// It leverages Swift ArgumentParser to handle input options for server port, repetition count, and message content.
import ArgumentParser
import NIOHTTP2
import GRPCNIOTransportHTTP2
import NIO

/// Command-line arguments structure for the gRPC client.
/// Conforms to ParsableArguments to allow automatic CLI parsing.
struct ClientArguments: ParsableArguments {
  /// The port number on which the server is listening. Defaults to 9100.
  @Option(help: "The server's listening port")
  var port: Int = 9100

  /// Number of times to repeat the gRPC call. Useful for load testing or retries.
  @Option(help: "The number of times to repeat the call")
  var repetitions: Int = 1

  /// The message string that will be sent to the server. Defaults to "getFeeds".
  @Option(help: "Message to send to the server")
  var message: String = "getFeeds"
    
  /// Returns a resolvable target object using IPv4 localhost and specified port.
  /// This is used to construct the gRPC connection address.
  var target: any ResolvableTarget {
      return .ipv4(host: "127.0.0.1", port: 9100)
  }
}


