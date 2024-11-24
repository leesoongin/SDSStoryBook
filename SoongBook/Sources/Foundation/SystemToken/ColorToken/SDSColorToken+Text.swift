//
//  SDSColorToken+Text.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

public extension SDSColorToken.Text {
    var color: UIColor {
        switch self {
        case .textBright: return .white000
        case .textDisabled: return .gray050
        case .textWarned: return .warningRed500
        case .grayPrimary: return .gray900
        case .graySecondary: return .green600
        case .greenPrimary: return .green400
        case .greenPressedPrimary: return .green600
        case .greenDisabledPrimary: return .green050
        case .greenSecondary: return .green600
        case .greenPressedSecondary: return .green700
        case .greenDisabledSecondary: return .green050
        case .violetPrimary: return .violet400
        case .violetPressedPrimary: return .violet600
        case .violetDisabledPrimary: return .violet050
        case .violetSecondary: return .violet600
        case .violetPressedSecondary: return .violet700
        case .violetDisabledSecondary: return .violet050
        case .emeraldPrimary: return .emerald400
        case .emeraldPressedPrimary: return .emerald600
        case .emeraldDisabledPrimary: return .emerald050
        case .emeraldSecondary: return .emerald600
        case .emeraldPressedSecondary: return .emerald700
        case .emeraldDisabledSecondary: return .emerald050
        case .warningRedPrimary: return .warningRed400
        case .warningRedPressedPrimary: return .warningRed600
        case .warningRedDisabledPrimary: return .warningRed050
        case .warningRedSecondary: return .warningRed600
        case .warningRedPressedSecondary: return .warningRed700
        case .warningRedDisabledSecondary: return .warningRed050
        }
    }
}
