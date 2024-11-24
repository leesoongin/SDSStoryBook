//
//  CommonButton+Size.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit

extension CommonButton {
    /**
     공통 버튼을 `사이즈` 단위로  정의한 Enum 입니다.
     
     Type   |   Description
     --- | ---
     `large` |   `large` 사이즈
     `midium`| `midium` 사이즈
     `small` |  `small` 사이즈
     */
    public enum Size {
        case large
        case midium
        case small
    }
}

extension CommonButton.Size {
    var height: CGFloat {
        switch self {
        case .large: return 52
        case .midium: return 40
        case .small: return 32
        }
    }
    
    var imageSize: CGFloat {
        switch self {
        case .large: return 24
        case .midium: return 18
        case .small: return 14
        }
    }
    
    var layoutMargin: UIEdgeInsets {
        switch self {
        case .large: return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .midium: return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        case .small: return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .large: return 8
        case .midium: return 6
        case .small: return 4
        }
    }
}
