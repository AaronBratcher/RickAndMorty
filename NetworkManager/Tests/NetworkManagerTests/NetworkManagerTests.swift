import Foundation
import Testing
@testable import NetworkManager

private struct Payload: Decodable, Equatable {
	let value: String
}

private struct FakeApiInfo: ProvidesApiInfo {
	var baseUrl: String
	var parameters: [String: String] = [:]
	var decoder: JSONDecoder { JSONDecoder() }
}

/// URLProtocol stub so tests never touch the real network.
private final class StubURLProtocol: URLProtocol, @unchecked Sendable {
	nonisolated(unsafe) static var handler: (@Sendable (URLRequest) -> (Data, HTTPURLResponse))?

	override class func canInit(with request: URLRequest) -> Bool { true }
	override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

	override func startLoading() {
		guard let handler = StubURLProtocol.handler else {
			client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
			return
		}
		let (data, response) = handler(request)
		client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		client?.urlProtocol(self, didLoad: data)
		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {}
}

private func stubbedSession(handler: @escaping @Sendable (URLRequest) -> (Data, HTTPURLResponse)) -> URLSession {
	StubURLProtocol.handler = handler
	let configuration = URLSessionConfiguration.ephemeral
	configuration.protocolClasses = [StubURLProtocol.self]
	return URLSession(configuration: configuration)
}

private func okResponse(for request: URLRequest) -> HTTPURLResponse {
	HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
}

// Serialized: StubURLProtocol.handler is shared static state, so these can't run concurrently.
@Suite(.serialized)
struct NetworkManagerTests {
	@Test func retrieveDataThrowsInvalidUrlForEmptyBaseUrl() async {
		let result: Payload?
		do {
			result = try await NetworkManager.shared.retrieveData(using: FakeApiInfo(baseUrl: ""))
		} catch DownloadError.invalidUrl {
			result = nil
		} catch {
			Issue.record("Expected DownloadError.invalidUrl, got \(error)")
			result = nil
		}
		#expect(result == nil)
	}

	@Test func executorDecodesSuccessfulResponse() async throws {
		let session = stubbedSession { request in
			(Data(#"{"value":"hello"}"#.utf8), okResponse(for: request))
		}
		let executor = Executor(session: session)
		let request = URLRequest(url: URL(string: "https://example.com")!)

		let decoded: Payload = try await executor.run(request, decoder: JSONDecoder())

		#expect(decoded == Payload(value: "hello"))
	}

	@Test func executorThrowsParseErrorForMalformedResponse() async {
		let session = stubbedSession { request in
			(Data("not json".utf8), okResponse(for: request))
		}
		let executor = Executor(session: session)
		let request = URLRequest(url: URL(string: "https://example.com")!)

		do {
			let _: Payload = try await executor.run(request, decoder: JSONDecoder())
			Issue.record("Expected DownloadError.parse to be thrown")
		} catch DownloadError.parse {
			// expected
		} catch {
			Issue.record("Expected DownloadError.parse, got \(error)")
		}
	}
}
