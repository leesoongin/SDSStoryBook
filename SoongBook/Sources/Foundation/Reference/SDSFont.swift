//
//  SDSFont.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit

public enum SDSFont {
    /// Font: `Bold`,  Size: `32`
    case title32
    /// Font: `Bold`,  Size: `28`
    case title28
    /// Font: `Bold`,  Size: `26`
    case title26
    /// Font: `Bold`,  Size: `24`
    case title24
    /// Font: `Bold`,  Size: `20`
    case title20
    
    /// Font: `Semibold`,  Size: `24`
    case subTitle24
    /// Font: `Semibold`,  Size: `22`
    case subTitle22
    /// Font: `Semibold`,  Size: `20`
    case subTitle20
    /// Font: `Semibold`,  Size: `18`
    case subTitle18
    /// Font: `Semibold`,  Size: `16`
    case subTitle16
    
    /// Font: `Regular`,  Size: `20`
    case body20
    /// Font: `Regular`,  Size: `18`
    case body18
    /// Font: `Regular`,  Size: `16`
    case body16
    /// Font: `Regular`,  Size: `14`
    case body14
    /// Font: `Regular`,  Size: `12`
    case body12
    
    /// Font: `Semibold`,  Size: `20`
    case buttonSemobold20
    /// Font: `Semibold`,  Size: `18`
    case buttonSemobold18
    /// Font: `Semibold`,  Size: `16`
    case buttonSemobold16
    /// Font: `Semibold`,  Size: `14`
    case buttonSemobold14
    /// Font: `Semibold`,  Size: `12`
    case buttonSemobold12
    
    /// Font: `Medium`,  Size: `20`
    case buttonMedium20
    /// Font: `Medium`,  Size: `18`
    case buttonMedium18
    /// Font: `Medium`,  Size: `16`
    case buttonMedium16
    /// Font: `Medium`,  Size: `14`
    case buttonMedium14
    /// Font: `Medium`,  Size: `12`
    case buttonMedium12
}
 
//MARK: - Font
extension SDSFont {
    public var font: UIFont {
        switch self {
        case .title32:
            return UIFont.systemFont(ofSize: 32, weight: .bold)
        case .title28:
            return UIFont.systemFont(ofSize: 28, weight: .bold)
        case .title26:
            return UIFont.systemFont(ofSize: 26, weight: .bold)
        case .title24:
            return UIFont.systemFont(ofSize: 24, weight: .bold)
        case .title20:
            return UIFont.systemFont(ofSize: 20, weight: .bold)
        case .subTitle24:
            return UIFont.systemFont(ofSize: 24, weight: .semibold)
        case .subTitle22:
            return UIFont.systemFont(ofSize: 22, weight: .semibold)
        case .subTitle20:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .subTitle18:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .subTitle16:
            return UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .body20:
            return UIFont.systemFont(ofSize: 20, weight: .regular)
        case .body18:
            return UIFont.systemFont(ofSize: 18, weight: .regular)
        case .body16:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .body14:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .body12:
            return UIFont.systemFont(ofSize: 12, weight: .regular)
        case .buttonSemobold20:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .buttonSemobold18:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .buttonSemobold16:
            return UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .buttonSemobold14:
            return UIFont.systemFont(ofSize: 14, weight: .semibold)
        case .buttonSemobold12:
            return UIFont.systemFont(ofSize: 12, weight: .semibold)
        case .buttonMedium20:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        case .buttonMedium18:
            return UIFont.systemFont(ofSize: 18, weight: .medium)
        case .buttonMedium16:
            return UIFont.systemFont(ofSize: 16, weight: .medium)
        case .buttonMedium14:
            return UIFont.systemFont(ofSize: 14, weight: .medium)
        case .buttonMedium12:
            return UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
}

//MARK: - LineHeight
extension SDSFont {
    public var lineHeight: CGFloat {
        switch self {
        case .title32: return 42
        case .title28: return 36
        case .title26: return 34
        case .title24: return 30
        case .title20: return 26
        case .subTitle24: return 30
        case .subTitle22: return 28
        case .subTitle20: return 26
        case .subTitle18: return 24
        case .subTitle16: return 20
        case .body20: return 26
        case .body18: return 24
        case .body16: return 20
        case .body14: return 18
        case .body12: return 16
        case .buttonSemobold20: return 26
        case .buttonSemobold18: return 24
        case .buttonSemobold16: return 20
        case .buttonSemobold14: return 18
        case .buttonSemobold12: return 16
        case .buttonMedium20: return 26
        case .buttonMedium18: return 24
        case .buttonMedium16: return 20
        case .buttonMedium14: return 18
        case .buttonMedium12: return 16
        }
    }
}
