import Testing
@testable import Localizations

struct StringLocalizationTests {
	@Test func resolvesKeyWithExplicitEnglishValue() {
		#expect("cancel".localized == "Cancel")
	}

	@Test func formatsWithSubstitutedValues() {
		#expect("transactions.list.ccPaymentToward".localized(using: "Visa") == "cc Payment toward Visa")
	}
}
