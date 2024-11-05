//
//  SDSColorToken.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import Foundation

// MARK: - System Color Token
public enum SDSColorToken {
    
    //MARK: Text
    public enum Text {
        case textPrimary
        case textSecondary
        case textTertiary
        case textDisabled
        case textBright
        case textWarned
    }
    
    // MARK: Font
    public enum Font {
        // green
        case greenBright
        case greenDisabled

        case greenPrimary
        case greenPressedPrimary
        
        case greenSecondary
        case greenPressedSecondary
        
        // Violet
        case violetBright
        case violetDisabled

        case violetPrimary
        case violetPressedPrimary
        
        case violetSecondary
        case violetPressedSecondary
    }
    
    // MARK: - Background
    public enum Background {
        // green
        case greenPrimary
        case greenPressedPrimary
        case greenDisabledPrimary
        case greenSecondary
        case greenPressedSecondary
        case greenDisabledSecondary
        case greenTinted
        
        // violet
        case violetPrimary
        case violetPressedPrimary
        case violetDisabledPrimary
        case violetSecondary
        case violetPressedSecondary
        case violetDisabledSecondary
        case violetTinted
    }
}

//// 이런식으로 System Token 의 형태를 받아서
//
//// 여기가 Component Token - Button, Label 등 ...
//public protocol ButtonTheme {
//    // border color
//    // font color
//    // background color
//}
//
//
//struct GreenTheme: ButtonTheme {
//    typealias Background = SoongSystemColor.Background
//    
//    func backgroundColor(variant: ButtonVariant, style: ButtonStyle, state: ButtonState) -> UIColor {
//        switch (variant, style, state) {
//        case (_, .outline, _): return .clear
//        case (_, .goast, _): return .clear
//        case (_, .tinted, _): return Background.greenTinted
//        case (.primary, .filled, .default): return Background.greenPrimary
//        case (.primary, .filled, .pressed): return Background.greenPressedPrimary
//        case (.primary, .filled, .disabled): return Background.greenDisabledPrimary
//        case (.secondary, .filled, .default): return Background.greenSecondary
//        case (.secondary, .filled, .pressed): return Background.greenPressedSecondary
//        case (.secondary, .filled, .disabled): return Background.greenDisabledSecondary
//        }
//    }
//}
//
////TODO: Variant, State, Style(filled, tinted, outline)
//enum ButtonVariant {
//    case primary
//    case secondary
//}
//
//enum ButtonStyle {
//    case filled
//    case tinted
//    case outline
//    case goast
//}
//
//enum ButtonState {
//    case `default`
//    case pressed
//    case disabled
//}
