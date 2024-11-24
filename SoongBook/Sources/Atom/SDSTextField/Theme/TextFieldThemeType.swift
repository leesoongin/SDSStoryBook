//
//  TextFieldThemeType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 10/26/24.
//

import Foundation

public enum TextFieldThemeType {
    case `default`
    case pink
    case purple

    var instance: TextFieldTheme {
        switch self {
        case .default: return TextFieldDefaultTheme()
        case .pink: return TextFieldGreenTheme()
        case .purple: return TextFieldvioletTheme()
        }
    }
}

