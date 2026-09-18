import Foundation

extension String {
	public var localized: String {
		return NSLocalizedString(self, bundle: Bundle.module, comment: "")
	}

	public func localized(using values: CVarArg...) -> String {
		return String.localizedStringWithFormat(self.localized, values)
	}
}
