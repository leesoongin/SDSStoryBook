//
//  CommonButton+Variant.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import Foundation

extension CommonButton {
    /**
     공통 버튼을 `기능의 목적` 단위로 분리하여 정의한 Enum 입니다.
     
     Type   |   Description
     --- | ---
     `primary` |   주로 `확인` 버튼의 용도로 사용됩니다.
     `secondary`|  주로 `취소` 버튼의 용도로 사용됩니다.
     `primary` |  주로 `삭제` 버튼의 용도로 사용됩니다.
     */
    public enum Variant {
        case primary
        case secondary
        case danger
    }
}
