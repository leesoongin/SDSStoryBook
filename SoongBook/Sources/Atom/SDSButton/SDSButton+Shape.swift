//
//  SDSButton+Shape.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import Foundation

extension SDSButton {
    /**
     버튼의 `형태` 를  정의한 Enum 입니다.
     
     Type   |   Description
     --- | ---
     `default` |   round가 없는 형태를 의미합니다.
     `round`| round 가 존재하는 형태를 의미합니다. 기본값은 6 입니다.
     `circle`| 버튼 높이의 1/2 round를 가지는 형태를 의미합니다.
     */
    public enum Shape {
        case `default`
        case round
        case circle
    }
    
    public protocol ShapeHandleable {
        var buttonShape: Shape { get }
        
        func updateShape()
    }
}

extension SDSButton.Shape {
    public func getRadius(with size: CommonButton.Size) -> CGFloat {
        switch self {
        case .default: return .zero
        case .round: return 6
        case .circle: return size.height / 2
        }
    }
}
