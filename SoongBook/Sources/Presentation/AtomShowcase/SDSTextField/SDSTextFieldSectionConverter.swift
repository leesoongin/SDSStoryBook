//
//  SDSTextFieldSectionConverter.swift
//  SoongBook
//
//  Created by 이숭인 on 11/18/24.
//

import UIKit

extension SDSTextFieldSectionConverter {
    enum SectionIdentifier: String {
        case textField = "textfield_component"
        case titleInput = "textfield_content_title_input_component"
        case supportInput = "textfield_content_support_input_component"
        case errorInput = "textfield_content_error_input_component"
        
        case themePicker = "textfield_theme_picker_component"
        case stylePicker = "textfield_style_picker_component"
        case sizePicker = "textfield_size_picker_component"
        case leftImagePicker = "textfield_content_leftImage_component"
        case rightImagePicker = "textfield_content_rightImage_component"
        case supportImagePicker = "textfield_support_image_component"
        case errorImagePicker = "textfield_error_image_component"
    }
}

final class SDSTextFieldSectionConverter {
    private var switchState: [String: Bool] = [:]
    
    func createSections(
        with model: SDSTextfieldComponentModel,
        imageMenu: [SDSTextFieldViewController.ImageType],
        themeMenu: [SDSTextFieldViewController.ThemeType],
        styleMenu: [SDSTextFieldViewController.StyleType],
        sizeMenu: [SDSTextFieldViewController.SizeType],
        switchState: [String: Bool]
    ) -> [SectionModelType] {
        self.switchState = switchState
        
        return [
            createTitleInputSection(with: model.title ?? ""),
            createSupportInputSection(with: model.supportText),
            createErrorInputSection(with: model.errorText),
            createThemePickerSection(
                with: themeMenu,
                selectedItem: model.theme
            ),
            createStylePickerSection(
                with: styleMenu,
                selectedItem: model.style
            ),
            creatSizePickerSection(
                with: sizeMenu,
                selectedItem: model.size
            ),
            createContentLeftImagePickerSection(
                with: imageMenu,
                selectedItem: model.leftImage
            ),
            createContentRightImagePickerSection(
                with: imageMenu,
                selectedItem: model.rightImage
            ),
            createSupportImagePickerSection(
                with: imageMenu,
                selectedItem: model.supportImage
            ),
            createErrorImagePickerSection(
                with: imageMenu,
                selectedItem: model.errorImage
            ),
        ].flatMap { $0 }
    }
    
    private func retrieveSwitchState(with identifier: String) -> Bool {
        return switchState[identifier].isNotNil
    }
}

// MARK: - UserInput Sections
extension SDSTextFieldSectionConverter {
    private func createTitleInputSection(with title: String) -> [SectionModelType] {
        let contentInputComponent = SDSUserInputComponent(
            identifier: SectionIdentifier.titleInput.rawValue,
            title: "TextField's title",
            subTitle: "텍스트 필드의 타이들을 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.titleInput.rawValue),
            placeHolder: "타이틀을 입력해주세요.",
            text: title,
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_content_title_input_section",
            itemModels: [contentInputComponent]
        )
        
        return [section]
    }
    
    private func createSupportInputSection(with text: String?) -> [SectionModelType] {
        let contentInputComponent = SDSUserInputComponent(
            identifier: SectionIdentifier.supportInput.rawValue,
            title: "TextField's Support Text",
            subTitle: "텍스트 필드의 도움말을 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.supportInput.rawValue),
            placeHolder: "도움말을 입력해주세요.",
            text: text ?? "",
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_content_support_input_section",
            itemModels: [contentInputComponent]
        )
        
        return [section]
    }
    
    private func createErrorInputSection(with text: String?) -> [SectionModelType] {
        let inputComponent = SDSUserInputComponent(
            identifier: SectionIdentifier.errorInput.rawValue,
            title: "TextField's Error Text",
            subTitle: "텍스트 필드의 에러문구를 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.errorInput.rawValue),
            placeHolder: "에러 문구를 입력해주세요.",
            text: text ?? "",
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_content_error_input_section",
            itemModels: [inputComponent]
        )
        
        return [section]
    }
}

//MARK: - Picker Sections
extension SDSTextFieldSectionConverter {
    private func createThemePickerSection(with menu: [SDSTextFieldViewController.ThemeType], selectedItem: TextFieldThemeType) -> [SectionModelType] {
        let selectedTheme = SDSTextFieldViewController.ThemeType.toThemeType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.themePicker.rawValue,
            title: "Theme",
            subTitle: "TextField 의 Theme 를 설정해보세요.",
            selectedItem: selectedTheme.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "textfield_theme_picker_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
    
    private func createStylePickerSection(with menu: [SDSTextFieldViewController.StyleType], selectedItem: BaseTextField.Variant) -> [SectionModelType] {
        let selectedStyle = SDSTextFieldViewController.StyleType.toStyleType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.stylePicker.rawValue,
            title: "Style",
            subTitle: "TextField 의 Style 를 설정해보세요.",
            selectedItem: selectedStyle.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "textfield_style_picker_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
    
    private func creatSizePickerSection(with menu: [SDSTextFieldViewController.SizeType], selectedItem: BaseTextField.Size) -> [SectionModelType] {
        let selectedSize = SDSTextFieldViewController.SizeType.toSizeType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.sizePicker.rawValue,
            title: "Size",
            subTitle: "TextField 의 Size 를 설정해보세요.",
            selectedItem: selectedSize.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "textfield_size_picker_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
    
    private func createContentLeftImagePickerSection(with menu: [SDSTextFieldViewController.ImageType], selectedItem: UIImage?) -> [SectionModelType] {
        let selectedImage = SDSTextFieldViewController.ImageType.toImageType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.leftImagePicker.rawValue,
            title: "Field Left Image",
            subTitle: "TextField의 Left Image를 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.leftImagePicker.rawValue),
            selectedItem: selectedImage.rawValue,
            pickerItems: menu.map { $0.rawValue },
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_content_leftImage_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
    
    private func createContentRightImagePickerSection(with menu: [SDSTextFieldViewController.ImageType], selectedItem: UIImage?) -> [SectionModelType] {
        let selectedImage = SDSTextFieldViewController.ImageType.toImageType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.rightImagePicker.rawValue,
            title: "Field Right Image",
            subTitle: "TextField의 Right Image를 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.rightImagePicker.rawValue),
            selectedItem: selectedImage.rawValue,
            pickerItems: menu.map { $0.rawValue },
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_content_rightImage_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
    
    private func createSupportImagePickerSection(with menu: [SDSTextFieldViewController.ImageType], selectedItem: UIImage?) -> [SectionModelType] {
        let selectedImage = SDSTextFieldViewController.ImageType.toImageType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.supportImagePicker.rawValue,
            title: "Field Support Image",
            subTitle: "TextField의 Support Image 를 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.supportImagePicker.rawValue),
            selectedItem: selectedImage.rawValue,
            pickerItems: menu.map { $0.rawValue },
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_support_image_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
    
    private func createErrorImagePickerSection(with menu: [SDSTextFieldViewController.ImageType], selectedItem: UIImage?) -> [SectionModelType] {
        let selectedImage = SDSTextFieldViewController.ImageType.toImageType(with: selectedItem)
        
        let pickerComponent = SDSPickerComponent(
            identifier: SectionIdentifier.errorImagePicker.rawValue,
            title: "Field Error Image",
            subTitle: "TextField의 Error Image 를 설정해보세요.",
            isOn: retrieveSwitchState(with: SectionIdentifier.errorImagePicker.rawValue),
            selectedItem: selectedImage.rawValue,
            pickerItems: menu.map { $0.rawValue },
            isOptionalOption: true
        )
        
        let section = SectionModel(
            identifier: "textfield_error_image_section",
            itemModels: [pickerComponent]
        )
        
        return [section]
    }
}
