//
//  NetworkManager.swift
//
//  Created by Aaron L Bratcher on 9/17/26.
//


import Foundation
import OSLog

public enum DownloadError: Error {
	case invalidUrl
	case download
	case parse
}

public protocol ProvidesApiInfo {
	var baseUrl: String { get }
	var parameters: [String: String] { get }
	var decoder: JSONDecoder { get }
}

public final class NetworkManager: Sendable {
	public static let shared = NetworkManager()
	public static let subsystem = "Download Manager"
	let executor = Executor()
	let logger = Logger(subsystem: NetworkManager.subsystem, category: "Get")

	private init() {}

	public func retrieveData<T: Decodable>(using apiInfo: ProvidesApiInfo) async throws -> T {
		guard let base = URL(string: apiInfo.baseUrl) else {
			throw DownloadError.invalidUrl
		}
		
		// Convert parameters dictionary to URL query items
		var components = URLComponents(url: base, resolvingAgainstBaseURL: true)
		components?.queryItems = apiInfo.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		
		guard let url = components?.url else {
			throw DownloadError.invalidUrl
		}
		
		let request = URLRequest(url: url)
		let absoluteUrlString = request.url?.absoluteString ?? ""
		logger.info("URL: \(absoluteUrlString)")
		return try await executor.run(request, decoder: apiInfo.decoder)
	}
}

struct Executor {
	var session: URLSession = .shared

	func run<DataType: Decodable>(_ request: URLRequest, decoder: JSONDecoder) async throws -> DataType {
		let (data, _) = try await session.data(for: request)
		try? await Task.sleep(nanoseconds: 100_000_000)

		do {
			return try decoder.decode(DataType.self, from: data)
		} catch {
			throw DownloadError.parse
		}
	}
}

