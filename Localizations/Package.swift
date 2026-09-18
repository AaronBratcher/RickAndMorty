// swift-tools-version: 6.4
import PackageDescription

let package = Package(
	name: "Localizations",
	defaultLocalization: "en",
	platforms: [
		.iOS(.v26), .macOS(.v26), .tvOS(.v26), .watchOS(.v26)
	],
	products: [
		.library(
			name: "Localizations",
			targets: ["Localizations"]),
	],
	targets: [
		// No default MainActor isolation: DBCore (nonisolated model types) and other non-UI
		// code call `.localized` from outside the main actor, same reason DBCore itself isn't
		// MainActor-isolated by default.
		.target(
			name: "Localizations",
			path: "Localizations/"),
		.testTarget(
			name: "LocalizationsTests",
			dependencies: ["Localizations"],
			path: "LocalizationsTests/"),
	]
)
