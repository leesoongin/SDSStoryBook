//
//  Typography+UILabel.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

private enum AssociatedKeys {
    static var typographyKey: UInt8 = 0
}

public extension UILabel {
    convenience init(typography: Typography) {
        self.init()
        
        applyTypography(with: typography)
    }
}

extension UILabel: LineHeightSettable {
    public var typography: Typography? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.typographyKey) as? Typography
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.typographyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var attributed: NSAttributedString? {
        get { attributedText }
        set { attributedText = newValue }
    }
    
    func applyTypography(with typography: Typography) {
        font = typography.font
        textAlignment = typography.alignment
        textColor = typography.colorStyle.color
        
        self.typography = typography
        applyLineHeight(with: typography, fontLineHeight: typography.lineHeight)
    }
}
