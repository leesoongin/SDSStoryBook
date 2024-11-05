//
//  SDSFont.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit

public enum SDSFont {
    /// Font: `Bold`,  Size: `28`
    case title1
    /// Font: `Bold`,  Size: `24`.
    case title2
    /// Font: `Bold`,  Size: `20`.
    case title3
    
    /// Font: `Semibold`,  Size: `20`.
    case subTitle1
    /// Font: `Semibold`,  Size: `16`.
    case subTitle2
    /// Font: `Semibold`,  Size: `14`.
    case subTitle3
    
    /// Font: `Regular`,  Size: `16`.
    case body1
    /// Font: `Regular`,  Size: `14`.
    case body2
    /// Font: `Regular`,  Size: `12`.
    case body3
    
    /// Size: `16`.
    case buttonSemibold1
    /// Size: `14`.
    case buttonSemibold2
    /// Size: `12`.
    case buttonSemibold3
    
    /// Size: `16`.
    case buttonMedium1
    /// Size: `14`.
    case buttonMedium2
    /// Size: `12`.
    case buttonMedium3
}
 
//MARK: - Font
extension SDSFont {
    public var font: UIFont {
        switch self {
        case .title1: return UIFont.systemFont(ofSize: 28, weight: .bold)
        case .title2: return UIFont.systemFont(ofSize: 24, weight: .bold)
        case .title3: return UIFont.systemFont(ofSize: 20, weight: .bold)
        case .subTitle1: return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .subTitle2: return UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .subTitle3: return UIFont.systemFont(ofSize: 14, weight: .semibold)
        case .body1: return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .body2: return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .body3: return UIFont.systemFont(ofSize: 12, weight: .regular)
        case .buttonSemibold1: return UIFont.systemFont(ofSize: 16, weight: .semibold)
        case .buttonSemibold2: return UIFont.systemFont(ofSize: 14, weight: .semibold)
        case .buttonSemibold3: return UIFont.systemFont(ofSize: 12, weight: .semibold)
        case .buttonMedium1: return UIFont.systemFont(ofSize: 16, weight: .medium)
        case .buttonMedium2: return UIFont.systemFont(ofSize: 14, weight: .medium)
        case .buttonMedium3: return UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
}

//MARK: - LineHeight
extension SDSFont {
    public var lineHeight: CGFloat {
        switch self {
        case .title1: return 36
        case .title2: return 30
        case .title3: return 25
        case .subTitle1: return 25
        case .subTitle2: return 22
        case .subTitle3: return 20
        case .body1, .buttonSemibold1, .buttonMedium1: return 22
        case .body2, .buttonSemibold2, .buttonMedium2: return 20
        case .body3, .buttonSemibold3, .buttonMedium3: return 16
        }
    }
}
