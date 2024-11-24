//
//  CommonButton+State.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import Foundation

extension CommonButton {
    /**
     공통 버튼을 `상태` 단위로  정의한 Enum 입니다.
     
     Type   |   Description
     --- | ---
     `enabled` |   `enabled` 상태
     `disabled`| `disabled` 상태
     `pressed` |  `pressed` 상태
     */
    public enum State {
        case enabled
        case disabled
        case pressed
    }
}
