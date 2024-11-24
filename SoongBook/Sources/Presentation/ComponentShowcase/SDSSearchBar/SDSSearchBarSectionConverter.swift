//
//  SDSSearchBarSectionConverter.swift
//  SoongBook
//
//  Created by 이숭인 on 11/24/24.
//

import Foundation

extension SDSSearchBarSectionConverter {
    private enum SectionIdentifier {
        static let searchBar = "searchBar_component"
        static let variantPicker = "variant_picker_component"
    }
}

final class SDSSearchBarSectionConverter {
    typealias VariantType =  SDSSearchBarViewController.VariantType
    
    func createSections(variant: VariantType) -> [SectionModelType] {
        [
            createSearchBarComponentSection(with: variant),
            craeteVariantPickerSection(with: variant)
        ].flatMap { $0 }
    }
}

extension SDSSearchBarSectionConverter {
    private func createSearchBarComponentSection(with variant: VariantType) -> [SectionModelType] {
        let variant = variant.toTextFieldVariant
        
        let largeSearchBarComponent = SDSSearchBarComponent(
            identifier: SectionIdentifier.searchBar,
            variant: variant,
            size: .large,
            theme: .default
        )
        
        let section = SectionModel(
            identifier: "searchBar_section",
            itemModels: [largeSearchBarComponent]
        )
        
        return [section]
    }
    
    private func craeteVariantPickerSection(with selectedVariant: VariantType) -> [SectionModelType] {
        
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.variantPicker,
            title: "Variant",
            subTitle: "variant를 설정해보세요.",
            selectedItem: selectedVariant.rawValue,
            pickerItems: VariantType.allCases.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "variant_picker_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
}
