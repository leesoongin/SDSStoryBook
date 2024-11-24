//
//  SDSTypographyToken+Title.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

public extension SDSTypographyToken.Title {
    var font: UIFont {
        switch self {
        case .xlarge:
            return SDSFont.title32.font
        case .large:
            return SDSFont.title28.font
        case .medium:
            return SDSFont.title26.font
        case .small:
            return SDSFont.title24.font
        case .xsmall:
            return SDSFont.title20.font
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .xlarge:
            return SDSFont.title32.lineHeight
        case .large:
            return SDSFont.title28.lineHeight
        case .medium:
            return SDSFont.title26.lineHeight
        case .small:
            return SDSFont.title24.lineHeight
        case .xsmall:
            return SDSFont.title20.lineHeight
        }
    }
}
