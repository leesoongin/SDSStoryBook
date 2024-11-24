//
//  SDSTypographyToken+Body.swift
//  SoongBook
//
//  Created by 이숭인 on 11/23/24.
//

import UIKit

public extension SDSTypographyToken.Body {
    var font: UIFont {
        switch self {
        case .xlarge: return SDSFont.body20.font
        case .large: return SDSFont.body18.font
        case .medium: return SDSFont.body16.font
        case .small: return SDSFont.body14.font
        case .xsmall: return SDSFont.body12.font
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .xlarge: return SDSFont.body20.lineHeight
        case .large: return SDSFont.body18.lineHeight
        case .medium: return SDSFont.body16.lineHeight
        case .small: return SDSFont.body14.lineHeight
        case .xsmall: return SDSFont.body12.lineHeight
        }
    }
}
