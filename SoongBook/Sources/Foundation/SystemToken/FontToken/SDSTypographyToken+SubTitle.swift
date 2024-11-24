//
//  SDSTypographyToken+SubTitle.swift
//  SoongBook
//
//  Created by 이숭인 on 11/23/24.
//

import UIKit

public extension SDSTypographyToken.SubTitle {
    var font: UIFont {
        switch self {
        case .xlarge: return SDSFont.subTitle24.font
        case .large: return SDSFont.subTitle22.font
        case .medium: return SDSFont.subTitle20.font
        case .small: return SDSFont.subTitle18.font
        case .xsmall: return SDSFont.subTitle16.font
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .xlarge: return SDSFont.subTitle24.lineHeight
        case .large: return SDSFont.subTitle22.lineHeight
        case .medium: return SDSFont.subTitle20.lineHeight
        case .small: return SDSFont.subTitle18.lineHeight
        case .xsmall: return SDSFont.subTitle16.lineHeight
        }
    }
}
