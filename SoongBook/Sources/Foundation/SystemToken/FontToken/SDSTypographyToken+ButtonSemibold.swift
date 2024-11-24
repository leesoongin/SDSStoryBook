//
//  SDSTypographyToken+ButtonSemibold.swift
//  SoongBook
//
//  Created by 이숭인 on 11/23/24.
//

import UIKit

public extension SDSTypographyToken.SemiboldButtonTitle {
    var font: UIFont {
        switch self {
        case .xlarge: return SDSFont.buttonSemobold20.font
        case .large: return SDSFont.buttonSemobold18.font
        case .medium: return SDSFont.buttonSemobold16.font
        case .small: return SDSFont.buttonSemobold14.font
        case .xsmall: return SDSFont.buttonSemobold12.font
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .xlarge: return SDSFont.buttonSemobold20.lineHeight
        case .large: return SDSFont.buttonSemobold18.lineHeight
        case .medium: return SDSFont.buttonSemobold16.lineHeight
        case .small: return SDSFont.buttonSemobold14.lineHeight
        case .xsmall: return SDSFont.buttonSemobold12.lineHeight
        }
    }
}
