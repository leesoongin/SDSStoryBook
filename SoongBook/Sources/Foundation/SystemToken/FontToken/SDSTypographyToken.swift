//
//  SDSFontToken.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit

public protocol SDSTypographyStyleable { }

public enum SDSTypographyToken {
    // title
    case xlargeTitle
    case largeTitle
    case mediumTitle
    case smallTitle
    case xsmallTitle
    
    // subtitle
    case xlargeSubTitle
    case largeSubTitle
    case mediumSubTitle
    case smallSubTitle
    case xsmallSubTitle
    
    // body
    case xlargeBody
    case largeBody
    case mediumBody
    case smallBody
    case xsmallBody
    
    // semiboldButtonTitle
    case xlargeSemiboldButton
    case largeSemiboldButton
    case mediumSemiboldButton
    case smallSemiboldButton
    case xsmallSemiboldButton
    
    // mediumButtonTitle
    case xlargeMediumButton
    case largeMediumButton
    case mediumMediumButton
    case smallMediumButton
    case xsmallMediumButton
    
    var style: SDSTypographyStyleable {
        switch self {
        // title
        case .xlargeTitle: return Title.xlarge
        case .largeTitle: return Title.large
        case .mediumTitle: return Title.medium
        case .smallTitle: return Title.small
        case .xsmallTitle: return Title.xsmall
        
        // subTitle
        case .xlargeSubTitle: return SubTitle.xlarge
        case .largeSubTitle: return SubTitle.large
        case .mediumSubTitle: return SubTitle.medium
        case .smallSubTitle: return SubTitle.small
        case .xsmallSubTitle: return SubTitle.xsmall
            
        // body
        case .xlargeBody: return Body.xlarge
        case .largeBody: return Body.large
        case .mediumBody: return Body.medium
        case .smallBody: return Body.small
        case .xsmallBody: return Body.xsmall
            
        // semiboldButtonTitle
        case .xlargeSemiboldButton: return SemiboldButtonTitle.xlarge
        case .largeSemiboldButton: return SemiboldButtonTitle.large
        case .mediumSemiboldButton: return SemiboldButtonTitle.medium
        case .smallSemiboldButton: return SemiboldButtonTitle.small
        case .xsmallSemiboldButton: return SemiboldButtonTitle.xsmall
            
        // mediumButtonTitle
        case .xlargeMediumButton: return MediumButtonTitle.xlarge
        case .largeMediumButton: return MediumButtonTitle.large
        case .mediumMediumButton: return MediumButtonTitle.medium
        case .smallMediumButton: return MediumButtonTitle.small
        case .xsmallMediumButton: return MediumButtonTitle.xsmall
        }
    }
}

extension SDSTypographyToken {
    public enum Title: SDSTypographyStyleable {
        case xlarge
        case large
        case medium
        case small
        case xsmall
    }
    
    public enum SubTitle: SDSTypographyStyleable {
        case xlarge
        case large
        case medium
        case small
        case xsmall
    }
    
    public enum Body: SDSTypographyStyleable {
        case xlarge
        case large
        case medium
        case small
        case xsmall
    }
    
    public enum SemiboldButtonTitle: SDSTypographyStyleable {
        case xlarge
        case large
        case medium
        case small
        case xsmall
    }
    
    public enum MediumButtonTitle: SDSTypographyStyleable {
        case xlarge
        case large
        case medium
        case small
        case xsmall
    }
}
