//
//  SDSColorToken+Background.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

public extension SDSColorToken.Background {
    var color: UIColor {
        switch self {
        case .greenPrimary: return .green600
        case .greenPressedPrimary: return .green400
        case .greenDisabledPrimary: return .green050
        case .greenSecondary: return .green300
        case .greenPressedSecondary: return .green200
        case .greenDisabledSecondary: return .green050
        case .greenTinted: return .green050
        
        case .violetPrimary: return .violet600
        case .violetPressedPrimary: return .violet400
        case .violetDisabledPrimary: return .violet050
        case .violetSecondary: return .violet300
        case .violetPressedSecondary: return .violet200
        case .violetDisabledSecondary: return .violet050
        case .violetTinted: return .violet050
        }
    }
}
