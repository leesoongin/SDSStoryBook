//
//  TextFieldDefaultTheme.swift
//  CoreUIKit
//
//  Created by 이숭인 on 10/26/24.
//

import UIKit

struct TextFieldDefaultTheme: TextFieldTheme {
    var titleTextColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var textCountTextColor: UIColor = SDSColorToken.Text.textWarned.color
    var helperTextColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var errorTextColor: UIColor = SDSColorToken.Text.textWarned.color
    var textFieldTintColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var errorImageTintColor: UIColor = SDSColorToken.Text.textWarned.color
    var clearButtonTintColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var textCountViewBackgroundColor: UIColor = .gray200
    
    func imageTintColor(isEnabled: Bool) -> UIColor {
        isEnabled ? SDSColorToken.Tint.grayPrimary.color : SDSColorToken.Tint.grayDisabledPrimary.color
    }
    
    func textFieldFontColor(state: BaseTextField.State) -> UIColor {
        state == .disabled ? SDSColorToken.Text.textDisabled.color : SDSColorToken.Text.grayPrimary.color
    }
    
    func textFieldBackgroundColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> UIColor {
        switch (variant, state) {
        case (_, .disabled): return SDSColorToken.Background.grayDisabledPrimary.color
        case (.filled, _): return SDSColorToken.Background.grayTinted.color
        case (.outline, _): return SDSColorToken.Background.bright.color
        }
    }
    
    func textFieldFocusColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> UIColor {
        switch (variant, state) {
        case (.filled, .press), (.filled, .typing): return SDSColorToken.Background.grayPrimary.color
        default: return SDSColorToken.Background.bright.color
        }
    }
    
    func textFieldBorderColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> CGColor {
        switch (variant, state) {
        case (_, .disabled): return SDSColorToken.Border.grayDisabledPrimary.color.cgColor
        case (_, .error): return SDSColorToken.Border.warningRedPrimary.color.cgColor
        case (.outline, .press), (.outline, .typing): return SDSColorToken.Border.grayPressedPrimary.color.cgColor
        case (.outline, _): return SDSColorToken.Border.grayPrimary.color.cgColor
        case (.filled, _): return UIColor.clear.cgColor
        }
    }
}


struct TextFieldGreenTheme: TextFieldTheme {
    var titleTextColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var textFieldTintColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var helperTextColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var errorTextColor: UIColor = SDSColorToken.Text.textWarned.color
    var errorImageTintColor: UIColor = SDSColorToken.Text.textWarned.color
    
    var clearButtonTintColor: UIColor = SDSColorToken.Background.greenTinted.color
    var textCountViewBackgroundColor: UIColor = .gray200 // will remove
    var textCountTextColor: UIColor = .red300 // will remove
    
    func imageTintColor(isEnabled: Bool) -> UIColor {
        isEnabled ? .gray800 : .gray400
    }
    
    func textFieldFontColor(state: BaseTextField.State) -> UIColor {
        state == .disabled ? .gray400 : .gray800
    }
    
    func textFieldBackgroundColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> UIColor {
        switch (variant, state) {
        case (.filled, _): return SDSColorToken.Background.greenPrimary.color
        case (.outline, .disabled): return SDSColorToken.Background.greenDisabledPrimary.color
        case (.outline, _): return SDSColorToken.Background.greenPrimary.color
        }
    }
    
    func textFieldFocusColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> UIColor {
        switch (variant, state) {
        case (.filled, .press), (.filled, .typing): return SDSColorToken.Background.greenPressedPrimary.color
        default: return .clear
        }
    }
    
    func textFieldBorderColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> CGColor {
        switch (variant, state) {
        case (_, .disabled): return SDSColorToken.Background.greenDisabledPrimary.color.cgColor
        case (_, .error): return SDSColorToken.Background.greenTinted.color.cgColor
        case (.outline, .press), (.outline, .typing): return SDSColorToken.Background.greenPressedPrimary.color.cgColor
        case (.outline, _): return SDSColorToken.Background.greenPrimary.color.cgColor
        default: return UIColor.clear.cgColor
        }
    }
}


struct TextFieldvioletTheme: TextFieldTheme {
    var titleTextColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var textFieldTintColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var helperTextColor: UIColor = SDSColorToken.Text.grayPrimary.color
    var errorTextColor: UIColor = SDSColorToken.Text.textWarned.color
    var errorImageTintColor: UIColor = SDSColorToken.Text.textWarned.color
    
    var clearButtonTintColor: UIColor = SDSColorToken.Background.violetTinted.color
    var textCountViewBackgroundColor: UIColor = .gray200 // will remove
    var textCountTextColor: UIColor = .red300 // will remove
    
    func imageTintColor(isEnabled: Bool) -> UIColor {
        isEnabled ? .gray800 : .gray400
    }
    
    func textFieldFontColor(state: BaseTextField.State) -> UIColor {
        state == .disabled ? .gray400 : .gray800
    }
    
    func textFieldBackgroundColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> UIColor {
        switch (variant, state) {
        case (.filled, _): return SDSColorToken.Background.violetPrimary.color
        case (.outline, .disabled): return SDSColorToken.Background.violetDisabledPrimary.color
        case (.outline, _): return SDSColorToken.Background.violetPrimary.color
        }
    }
    
    func textFieldFocusColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> UIColor {
        switch (variant, state) {
        case (.filled, .press), (.filled, .typing): return SDSColorToken.Background.violetPressedPrimary.color
        default: return .clear
        }
    }
    
    func textFieldBorderColor(variant: BaseTextField.Variant, state: BaseTextField.State) -> CGColor {
        switch (variant, state) {
        case (_, .disabled): return SDSColorToken.Background.violetDisabledPrimary.color.cgColor
        case (_, .error): return SDSColorToken.Background.violetTinted.color.cgColor
        case (.outline, .press), (.outline, .typing): return SDSColorToken.Background.violetPressedPrimary.color.cgColor
        case (.outline, _): return SDSColorToken.Background.violetPrimary.color.cgColor
        default: return UIColor.clear.cgColor
        }
    }
}
