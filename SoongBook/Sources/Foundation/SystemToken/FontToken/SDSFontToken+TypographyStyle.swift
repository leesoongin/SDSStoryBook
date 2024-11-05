//
//  SDSFontToken+TypographyStyle.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

//MARK: - Font
public extension SDSFontToken.TypographyStyle {
    var font: UIFont {
        switch self {
        case .largeTitle: return SDSFont.title1.font
        case .mediumTitle: return SDSFont.title2.font
        case .smallTitle: return SDSFont.title3.font
        case .largeSubTitle: return SDSFont.subTitle1.font
        case .mediumSubTitle: return SDSFont.subTitle2.font
        case .smallSubTitle: return SDSFont.subTitle3.font
        case .largeBody: return SDSFont.body1.font
        case .mediumBody: return SDSFont.body2.font
        case .smallBody: return SDSFont.body3.font
        case .largeButtonSemibold: return SDSFont.buttonSemibold1.font
        case .mediumButtonSemibold: return SDSFont.buttonSemibold2.font
        case .smallButtonSemibold: return SDSFont.buttonSemibold3.font
        case .largeButtonMedium: return SDSFont.buttonMedium1.font
        case .mediumButtonMedium: return SDSFont.buttonMedium2.font
        case .smallButtonMedium: return SDSFont.buttonMedium3.font
        }
    }
}

//MARK: - LineHeight
public extension SDSFontToken.TypographyStyle {
    var lineHeight: CGFloat {
        switch self {
        case .largeTitle: return SDSFont.title1.lineHeight
        case .mediumTitle: return SDSFont.title2.lineHeight
        case .smallTitle: return SDSFont.title3.lineHeight
        case .largeSubTitle: return SDSFont.subTitle1.lineHeight
        case .mediumSubTitle: return SDSFont.subTitle2.lineHeight
        case .smallSubTitle: return SDSFont.subTitle3.lineHeight
        case .largeBody: return SDSFont.body1.lineHeight
        case .mediumBody: return SDSFont.body2.lineHeight
        case .smallBody: return SDSFont.body3.lineHeight
        case .largeButtonSemibold: return SDSFont.buttonSemibold1.lineHeight
        case .mediumButtonSemibold: return SDSFont.buttonSemibold2.lineHeight
        case .smallButtonSemibold: return SDSFont.buttonSemibold3.lineHeight
        case .largeButtonMedium: return SDSFont.buttonMedium1.lineHeight
        case .mediumButtonMedium: return SDSFont.buttonMedium2.lineHeight
        case .smallButtonMedium: return SDSFont.buttonMedium3.lineHeight
        }
    }
}
