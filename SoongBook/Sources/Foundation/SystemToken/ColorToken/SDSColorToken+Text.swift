//
//  SDSColorToken+Text.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

public extension SDSColorToken.Text {
    var color: UIColor {
        switch self {
        case .textPrimary: return .gray900
        case .textSecondary: return .gray700
        case .textTertiary: return .gray600
        case .textDisabled: return .gray500
        case .textBright: return .white000
        case .textWarned: return .warningRed400
        }
    }
}
