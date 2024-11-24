//
//  ButtonTheme.swift
//  CoreUIKit
//
//  Created by 이숭인 on 9/29/24.
//

import UIKit


/// Common Button의 Theme 타입을 정의하기 위한 Protocol 입니다.
public protocol ButtonTheme {
    /// **Theme 의 Font Color**
    /// - Parameters:
    ///   - role: Common Button 의 Role (Variant) Enum 입니다.
    ///   - style: Common Button 의 Style을 정의하는 Enum 입니다.
    ///   - state: Common Button 의 State를 정의하는 Enum 입니다.
    /// - Returns: `UIColor` 타입의 Font Color 를 리턴합니다.
    func fontColor(
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        state: CommonButton.State
    ) -> UIColor
    
    /// **Theme 의 Background Color**
    /// - Parameters:
    ///   - role: Common Button 의 Role (Variant) Enum 입니다.
    ///   - style: Common Button 의 Style을 정의하는 Enum 입니다.
    ///   - state: Common Button 의 State를 정의하는 Enum 입니다.
    /// - Returns: `UIColor` 타입의 Background Color 를 리턴합니다.
    func backgroundColor(
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        state: CommonButton.State
    ) -> UIColor
    
    /// **Theme 의 Dimmed Color**
    /// - Parameters:
    ///   - role: Common Button 의 Role (Variant) Enum 입니다.
    ///   - style: Common Button 의 Style을 정의하는 Enum 입니다.
    ///   - state: Common Button 의 State를 정의하는 Enum 입니다.
    /// - Returns: `UIColor` 타입의 Dimmed Color 를 리턴합니다.
    func highlightDimmedColor(
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        state: CommonButton.State
    ) -> UIColor
    
    /// **Theme 의 Border Color**
    /// - Parameters:
    ///   - role: Common Button 의 Role (Variant) Enum 입니다.
    ///   - style: Common Button 의 Style을 정의하는 Enum 입니다.
    ///   - state: Common Button 의 State를 정의하는 Enum 입니다.
    /// - Returns: `CGColor` 타입의 border Color 를 리턴합니다.
    func borderColor(
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        state: CommonButton.State
    ) -> CGColor
    
    /// **Theme 의  Tint Color**
    /// - Parameters:
    ///    - variant: Common Button 의  variant 입니다.
    ///    - style: Common Button 의 Style 입니다.
    ///    - state: Common Button 의 State 입니다.
    ///  - Returns: `CGColor` 타입의 TintColor 를 리턴합니다.
    func tintColor(
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        state: CommonButton.State
    ) -> UIColor
}
