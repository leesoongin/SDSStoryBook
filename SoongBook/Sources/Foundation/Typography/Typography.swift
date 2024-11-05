//
//  Typography.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit

public struct Typography {
    let typographyStyle: SDSFontToken.TypographyStyle
    let alignment: NSTextAlignment
    let colorStyle: SDSColorToken.Text
    let applyLineHeight: Bool

    public init(style: SDSFontToken.TypographyStyle,
                colorStyle: SDSColorToken.Text,
                alignment: NSTextAlignment = .left,
                applyLineHeight: Bool = true) {
        self.typographyStyle = style
        self.colorStyle = colorStyle
        self.alignment = alignment
        self.applyLineHeight = applyLineHeight
    }

    public func createLineHeightAttributes(with lineBreakMode: NSLineBreakMode? = nil) -> [NSAttributedString.Key: Any] {
        let lineHeight = typographyStyle.lineHeight
        let adjustment = lineHeight >= typographyStyle.font.lineHeight ? 2.0 : 1.0
        let baselineOffset = (lineHeight - typographyStyle.font.lineHeight) / 2.0 / adjustment

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
            .font: typographyStyle.font,
            .foregroundColor: colorStyle.color
        ]
    }
}
