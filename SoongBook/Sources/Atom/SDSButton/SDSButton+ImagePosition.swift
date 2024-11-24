//
//  SDSButton+ImagePosition.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import Foundation

extension SDSButton {
    /**
     버튼의 `이미지 포지션` 을  정의한 Enum 입니다.
     
     Type   |   Description
     --- | ---
     `start` |   `start or leading` 위치를 의미합니다.
     `end`| `end or trailing` 위치를 의미합니다.
     */
    public enum ImagePosition {
        case start
        case end
    }
    
    public protocol ImagePositionHandleable {
        var imagePosition: ImagePosition { get }
        
        func updateImagePosition(with position: ImagePosition)
    }
}

