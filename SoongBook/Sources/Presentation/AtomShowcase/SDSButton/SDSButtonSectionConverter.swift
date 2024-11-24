//
//  SDSButtonSectionConverter.swift
//  SoongBook
//
//  Created by 이숭인 on 11/18/24.
//

import Foundation
import UIKit

final class SDSButtonSectionConverter {
    func createSections(
        with buttonModel: SDSButtonComponentModel,
        iconMenu: [SDSButtonViewController.ImageContentType],
        themeMenu: [SDSButtonViewController.ThemeType],
        styleMenu: [SDSButtonViewController.StyleType],
        stateMenu: [SDSButtonViewController.StateType],
        variantMenu: [SDSButtonViewController.VariantType],
        shapeMenu: [SDSButtonViewController.ShapeType]
    ) -> [SectionModelType] {
        return [
            createButtonTextInputSection(with: buttonModel.buttonText),
            createLeftIconPickerSection(
                with: iconMenu,
                selectedItem: buttonModel.leftIcon
            ),
            createRightIconPickerSection(
                with: iconMenu,
                selectedItem: buttonModel.rightIcon
            ),
            createThemePickerSection(
                with: themeMenu,
                selectedItem: buttonModel.theme
            ),
            createStylePickerSection(
                with: styleMenu,
                selectedItem: buttonModel.style
            ),
            createStatePickerSection(
                with: stateMenu,
                selectedItem: buttonModel.state
            ),
            createVariantPickerSection(
                with: variantMenu,
                selectedItem: buttonModel.variant
            ),
            createShapePickerSection(
                with: shapeMenu,
                selectedItem: buttonModel.shape
            )
        ].flatMap { $0 }
    }
}

extension SDSButtonSectionConverter {
    private func createButtonTextInputSection(with text: String) -> [SectionModelType] {
        let component = SDSUserInputComponent(
            identifier: "button_text_input_component",
            title: "Button's Title",
            subTitle: "버튼의 텍스트를 입력해보세요.",
            placeHolder: "텍스트를 입력해주세요.",
            text: text
        )
        
        let section = SectionModel(
            identifier: "button_text_input_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createLeftIconPickerSection(with menu: [SDSButtonViewController.ImageContentType], selectedItem: UIImage?) -> [SectionModelType] {
        let selectedImage = SDSButtonViewController.ImageContentType.toImageType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "left_icon_picker_component",
            title: "Left Icon",
            subTitle: "버튼의 Left Icon을 설정해보세요.",
            selectedItem: selectedImage.rawValue,
            pickerItems: menu.map { $0.rawValue },
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "left_icon_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createRightIconPickerSection(with menu: [SDSButtonViewController.ImageContentType], selectedItem: UIImage?) -> [SectionModelType] {
        let selectedImage = SDSButtonViewController.ImageContentType.toImageType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "right_icon_picker_component",
            title: "Right Icon",
            subTitle: "버튼의 Right Icon을 설정해보세요.",
            selectedItem: selectedImage.rawValue,
            pickerItems: menu.map { $0.rawValue },
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "right_icon_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createThemePickerSection(with menu: [SDSButtonViewController.ThemeType], selectedItem: ButtonThemeType) -> [SectionModelType] {
        let selectedTheme = SDSButtonViewController.ThemeType.toThemeType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "theme_picker_component",
            title: "Theme",
            subTitle: "버튼의 Theme 를 설정해보세요.",
            selectedItem: selectedTheme.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "theme_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createStylePickerSection(with menu: [SDSButtonViewController.StyleType], selectedItem: CommonButton.Style) -> [SectionModelType] {
        let selectedStyle = SDSButtonViewController.StyleType.toStyleType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "style_picker_component",
            title: "Style",
            subTitle: "버튼의 Style 을 설정해보세요.",
            selectedItem: selectedStyle.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "style_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createStatePickerSection(with menu: [SDSButtonViewController.StateType], selectedItem: CommonButton.State) -> [SectionModelType] {
        let selectedState = SDSButtonViewController.StateType.toStateType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "state_picker_component",
            title: "State",
            subTitle: "버튼의 State 를 설정해보세요.",
            selectedItem: selectedState.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "state_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createVariantPickerSection(with menu: [SDSButtonViewController.VariantType], selectedItem: CommonButton.Variant) -> [SectionModelType] {
        let selectedVariant = SDSButtonViewController.VariantType.toVariantType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "variant_picker_component",
            title: "Variant",
            subTitle: "버튼의 variant 을 설정해보세요.",
            selectedItem: selectedVariant.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "variant_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createShapePickerSection(with menu: [SDSButtonViewController.ShapeType], selectedItem: SDSButton.Shape) -> [SectionModelType] {
        let selectedShape = SDSButtonViewController.ShapeType.toShapeType(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "shape_picker_component",
            title: "Shape",
            subTitle: "버튼의 Shape 을 설정해보세요.",
            selectedItem: selectedShape.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "shape_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
}
