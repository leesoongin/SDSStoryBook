//
//  TextFieldThemeType.swift
//  CoreUIKit
//
//  Created by 이숭인 on 10/26/24.
//

import UIKit

public protocol TextFieldTheme {
    var titleTextColor: UIColor { get }
    var textCountTextColor: UIColor { get }
    var helperTextColor: UIColor { get }
    var errorTextColor: UIColor { get }
    var textFieldTintColor: UIColor { get }
    var errorImageTintColor: UIColor { get }
    var clearButtonTintColor: UIColor { get }
    var textCountViewBackgroundColor: UIColor { get }
    func imageTintColor(isEnabled: Bool) -> UIColor
    func textFieldFontColor(state: BaseTextField.State) -> UIColor
    func textFieldBackgroundColor(
        variant: BaseTextField.Variant,
        state: BaseTextField.State
    ) -> UIColor
    func textFieldFocusColor(
        variant: BaseTextField.Variant,
        state: BaseTextField.State
    ) -> UIColor
    func textFieldBorderColor(
        variant: BaseTextField.Variant,
        state: BaseTextField.State
    ) -> CGColor
}
