//
//  SDSColorToken+Tint.swift
//  SoongBook
//
//  Created by 이숭인 on 11/23/24.
//

import UIKit

extension SDSColorToken.Tint {
    var color: UIColor {
        switch self {
        case .bright: return .white000
        case .grayPrimary, .grayPressedPrimary: return .gray900
        case .grayDisabledPrimary: return .gray300
        case .graySecondary, .grayPressedSecondary: return .gray700
        case .grayDisabledSecondary: return .gray300
        case .grayTinted: return .gray050
        case .greenPrimary: return .green400
        case .greenPressedPrimary: return .green600
        case .greenDisabledPrimary: return .green050
        case .greenSecondary: return .green600
        case .greenPressedSecondary: return .green700
        case .greenDisabledSecondary: return .green050
        case .greenTinted: return .green050
        case .violetPrimary: return .violet400
        case .violetPressedPrimary: return .violet600
        case .violetDisabledPrimary: return .violet050
        case .violetSecondary: return .violet600
        case .violetPressedSecondary: return .violet700
        case .violetDisabledSecondary: return .violet050
        case .violetTinted: return .violet050
        case .emeraldPrimary: return .emerald400
        case .emeraldPressedPrimary: return .emerald600
        case .emeraldDisabledPrimary: return .emerald050
        case .emeraldSecondary: return .emerald600
        case .emeraldPressedSecondary: return .emerald700
        case .emeraldDisabledSecondary: return .emerald050
        case .emeraldTinted: return .emerald050
        case .warningRedPrimary: return .warningRed400
        case .warningRedPressedPrimary: return .warningRed600
        case .warningRedDisabledPrimary: return .warningRed050
        case .warningRedSecondary: return .warningRed600
        case .warningRedPressedSecondary: return .warningRed700
        case .warningRedDisabledSecondary: return .warningRed050
        case .warningRedTinted: return .warningRed050
        }
    }
}
