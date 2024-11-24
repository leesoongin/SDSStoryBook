//
//  PinkTheme.swift
//  CoreUIKit
//
//  Created by 이숭인 on 9/29/24.
//

import UIKit

// 여기가 컴포넌트 토큰. 근데 여러 테마를 곁들인 ,,
struct GreenTheme: ButtonTheme {
    func tintColor(
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        state: CommonButton.State
    ) -> UIColor {
        switch (variant, style, state) {
        case (_, .filled, _): return SDSColorToken.Tint.bright.color
        case (.primary, _, .disabled): return SDSColorToken.Tint.greenDisabledPrimary.color
        case (.secondary, _, .disabled): return SDSColorToken.Tint.greenDisabledSecondary.color
        case (.danger, _, .disabled): return SDSColorToken.Tint.warningRedDisabledPrimary.color
        case (.primary, _, .enabled): return SDSColorToken.Tint.greenPrimary.color
        case (.primary, _, .pressed): return SDSColorToken.Tint.greenPressedPrimary.color
        case (.secondary, _, .enabled): return SDSColorToken.Tint.greenSecondary.color
        case (.secondary, _, .pressed): return SDSColorToken.Tint.greenPressedSecondary.color
        case (.danger, _, .enabled): return SDSColorToken.Tint.warningRedPrimary.color
        case (.danger, _, .pressed): return SDSColorToken.Tint.warningRedPressedPrimary.color
        }
    }
    /**
     - Returns: **Theme 별 Font Color**
     - Note: Theme별 State의 타입, Role-Style 조합으로 구분된 Font 컬러를 Return 합니다.
    */
    func fontColor(variant: CommonButton.Variant, style: CommonButton.Style, state: CommonButton.State) -> UIColor {
        switch (variant, style, state) {
        case (_, .filled, _): return SDSColorToken.Text.textBright.color
        case (.primary, _, .disabled): return SDSColorToken.Text.greenDisabledPrimary.color
        case (.secondary, _, .disabled): return SDSColorToken.Text.greenDisabledSecondary.color
        case (.danger, _, .disabled): return SDSColorToken.Text.warningRedDisabledPrimary.color
        case (.primary, _, .enabled): return SDSColorToken.Tint.greenPrimary.color
        case (.primary, _, .pressed): return SDSColorToken.Tint.greenPressedPrimary.color
        case (.secondary, _, .enabled): return SDSColorToken.Tint.greenSecondary.color
        case (.secondary, _, .pressed): return SDSColorToken.Tint.greenPressedSecondary.color
        case (.danger, _, .enabled): return SDSColorToken.Tint.warningRedPrimary.color
        case (.danger, _, .pressed): return SDSColorToken.Tint.warningRedPressedPrimary.color
        }
    }
    
    /**
    - Returns: **Theme 별 Background Color**
    - Note: `Role` - `State` 의 조합으로 구분되어 Background 컬러를 Return 합니다.
    */
    func backgroundColor(variant: CommonButton.Variant, style: CommonButton.Style, state: CommonButton.State) -> UIColor {
        switch (variant, style, state) {
        case (_, .outline, _): return .clear
        case (_, .goast, _): return .clear
        case (.primary, _, .enabled): return SDSColorToken.Background.greenPrimary.color
        case (.primary, _, .pressed): return SDSColorToken.Background.greenPressedPrimary.color
        case (.primary, _, .disabled): return SDSColorToken.Background.greenDisabledPrimary.color
        case (.secondary, _, .enabled): return SDSColorToken.Background.greenSecondary.color
        case (.secondary, _, .pressed): return SDSColorToken.Background.greenPressedSecondary.color
        case (.secondary, _, .disabled): return SDSColorToken.Background.greenDisabledSecondary.color
        case (.danger, _, .enabled): return SDSColorToken.Background.warningRedPrimary.color
        case (.danger, _, .pressed): return SDSColorToken.Background.warningRedPressedPrimary.color
        case (.danger, _, .disabled): return SDSColorToken.Background.warningRedDisabledPrimary.color
        }
    }
    
    /**
    - Returns: **Theme 별 Hignlight Dimmed Color**
    - Note: `Role` - `State` 의 조합으로 구분되어 Background의 Hignlight Dimmed 컬러를 Return 합니다.
    */
    func highlightDimmedColor(variant: CommonButton.Variant, style: CommonButton.Style, state: CommonButton.State) -> UIColor {
        switch (variant, style, state) {
        case (.primary, _, .enabled): return .clear
        case (.primary, _, .pressed): return .clear
        case (.primary, _, .disabled): return .clear
        case (.secondary, _, .enabled): return .clear
        case (.secondary, _, .pressed): return .clear
        case (.secondary, _, .disabled): return .clear
        case (.danger, _, .enabled): return .clear
        case (.danger, _, .pressed): return .clear
        case (.danger, _, .disabled): return .clear
        }
    }
    
    /**
    - Returns: **Theme 별 Border Color**
    - Note: `Outline` style 의 컬러를 Return 합니다.
    */
    func borderColor(variant: CommonButton.Variant, style: CommonButton.Style, state: CommonButton.State) -> CGColor {
        switch (variant, style, state) {
        case (_, .filled, _): return UIColor.clear.cgColor
        case (.primary, _, .enabled): return SDSColorToken.Background.greenPrimary.color.cgColor
        case (.primary, _, .pressed): return SDSColorToken.Background.greenPressedPrimary.color.cgColor
        case (.primary, _, .disabled): return SDSColorToken.Background.greenDisabledPrimary.color.cgColor
        case (.secondary, _, .enabled): return SDSColorToken.Background.greenSecondary.color.cgColor
        case (.secondary, _, .pressed): return SDSColorToken.Background.greenPressedSecondary.color.cgColor
        case (.secondary, _, .disabled): return SDSColorToken.Background.greenDisabledSecondary.color.cgColor
        case (.danger, _, .enabled): return SDSColorToken.Background.warningRedPrimary.color.cgColor
        case (.danger, _, .pressed): return SDSColorToken.Background.warningRedPressedPrimary.color.cgColor
        case (.danger, _, .disabled): return SDSColorToken.Background.warningRedDisabledPrimary.color.cgColor
        }
    }
}
