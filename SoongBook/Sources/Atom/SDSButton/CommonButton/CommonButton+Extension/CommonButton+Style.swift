//
//  CommonButton+Style.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import Foundation

extension CommonButton {
    /**
     공통 버튼을 `스타일` 단위로  정의한 Enum 입니다.
     
     Type   |   Description
     --- | ---
     `filled` |   주로 `꽉찬 컬러로 구분되는` 버튼의 용도로 사용됩니다.
     `outline`|  주로 `테두리로 구분되는` 버튼의 용도로 사용됩니다.
     `goast` |  주로 `텍스트` 버튼의 용도로 사용됩니다.
     */
    public enum Style {
        case filled
        case outline
        case goast
    }
}
