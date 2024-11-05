//
//  SDSColorToken+Font.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

public extension SDSColorToken.Font {
    var color: UIColor {
        switch self {
        case .greenBright: return .white000
        case .greenDisabled: return .gray300
        case .greenPrimary:return .green600
        case .greenPressedPrimary: return .green400
        case .greenSecondary: return .green300
        case .greenPressedSecondary: return .green200
        
        case .violetBright: return .white000
        case .violetDisabled: return .gray300
        case .violetPrimary: return .violet600
        case .violetPressedPrimary: return .violet400
        case .violetSecondary: return .violet300
        case .violetPressedSecondary: return .violet200
        }
    }
}
