//
//  Enums.swift
//  RickAndMorty
//
//  Created by Aaron L Bratcher on 9/17/26.
//

enum LoadingState: Equatable {
	case idle
	case loading
	case complete
	case error
}

extension Collection {
	public var isNotEmpty: Bool {
		!isEmpty
	}
}
