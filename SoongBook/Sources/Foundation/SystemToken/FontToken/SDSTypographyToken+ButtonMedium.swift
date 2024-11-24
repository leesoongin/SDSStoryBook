//
//  SDSTypographyToken+ButtonMedium.swift
//  SoongBook
//
//  Created by 이숭인 on 11/23/24.
//

import UIKit

public extension SDSTypographyToken.MediumButtonTitle {
    var font: UIFont {
        switch self {
        case .xlarge: return SDSFont.buttonMedium20.font
        case .large: return SDSFont.buttonMedium18.font
        case .medium: return SDSFont.buttonMedium16.font
        case .small: return SDSFont.buttonMedium14.font
        case .xsmall: return SDSFont.buttonMedium12.font
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .xlarge: return SDSFont.buttonMedium20.lineHeight
        case .large: return SDSFont.buttonMedium18.lineHeight
        case .medium: return SDSFont.buttonMedium16.lineHeight
        case .small: return SDSFont.buttonMedium14.lineHeight
        case .xsmall: return SDSFont.buttonMedium12.lineHeight
        }
    }
}
