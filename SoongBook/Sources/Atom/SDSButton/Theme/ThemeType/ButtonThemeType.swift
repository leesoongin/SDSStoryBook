//
//  ButtonThemeType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 9/29/24.
//

import Foundation

public enum ButtonThemeType {
    case pink
    case purple
    
    var theme: ButtonTheme {
        switch self {
        case .pink:
            return GreenTheme()
        case .purple:
            return VioletTheme()
        }
    }
}
