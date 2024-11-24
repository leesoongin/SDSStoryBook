//
//  Typography.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit

public struct Typography {
    let font: UIFont
    let lineHeight: CGFloat
    let alignment: NSTextAlignment
    let colorStyle: SDSColorToken.Text
    let applyLineHeight: Bool

    public init(token: SDSTypographyToken,
                colorStyle: SDSColorToken.Text,
                alignment: NSTextAlignment = .left,
                applyLineHeight: Bool = true) {
        self.font = Typography.convertTypographyStyleToFont(with: token.style)
        self.lineHeight = Typography.convertTypographyStyleToLineHeight(with: token.style)
        self.colorStyle = colorStyle
        self.alignment = alignment
        self.applyLineHeight = applyLineHeight
    }

    public func createLineHeightAttributes(with lineBreakMode: NSLineBreakMode? = nil) -> [NSAttributedString.Key: Any] {
        let adjustment = lineHeight >= font.lineHeight ? 2.0 : 1.0
        let baselineOffset = (lineHeight - font.lineHeight) / 2.0 / adjustment
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = alignment
        

        if let lineBreakMode {
            style.lineBreakMode = lineBreakMode
        }

        return [
            .paragraphStyle: style,
            .baselineOffset: baselineOffset,
            .font: font,
            .foregroundColor: colorStyle.color
        ]
    }
    
    public static func convertTypographyStyleToLineHeight(with typographyStyle: any SDSTypographyStyleable) -> CGFloat {
        switch typographyStyle {
        case let style as SDSTypographyToken.Title:
            return style.lineHeight
        case let style as SDSTypographyToken.SubTitle:
            return style.lineHeight
        case let style as SDSTypographyToken.Body:
            return style.lineHeight
        case let style as SDSTypographyToken.SemiboldButtonTitle:
            return style.lineHeight
        case let style as SDSTypographyToken.MediumButtonTitle:
            return style.lineHeight
        default:
            return .zero
        }
    }
    
    public static func convertTypographyStyleToFont(with typographyStyle: any SDSTypographyStyleable) -> UIFont {
        switch typographyStyle {
        case let style as SDSTypographyToken.Title:
            return style.font
        case let style as SDSTypographyToken.SubTitle:
            return style.font
        case let style as SDSTypographyToken.Body:
            return style.font
        case let style as SDSTypographyToken.SemiboldButtonTitle:
            return style.font
        case let style as SDSTypographyToken.MediumButtonTitle:
            return style.font
        default:
            return UIFont.systemFont(ofSize: 14)
        }
    }
}
