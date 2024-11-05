//
//  Optional+Extension.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import Foundation

extension Optional {
    public var isNil: Bool {
        switch self {
        case .some:
            return false
        case .none:
            return true
        }
    }

    public var isNotNil: Bool {
        !isNil
    }
}
