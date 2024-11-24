//
//  SDSLabelSectionConverter.swift
//  SoongBook
//
//  Created by 이숭인 on 11/17/24.
//

import Foundation
import UIKit

final class SDSLabelSectionConverter {
    func createSections(
        with labelModel: SDSLabelComponentModel,
        typoMenus: [SDSLabelViewController.TypographyMenu],
        numberOfLinesMenus: [SDSLabelViewController.NumberOfLinesMenu],
        lineBreakModelMenus: [SDSLabelViewController.LineBreakModeMenu],
        textAlignmentMenus: [SDSLabelViewController.AlignmentMenu]
    ) -> [SectionModelType] {
        return [
            createTextChangeSection(with: labelModel.text),
            createTypoMenuSection(
                with: typoMenus,
                selectedItem: labelModel.typoStyle
            ),
            createNumberOfLinesMenuSection(
                with: numberOfLinesMenus,
                selectedItem: labelModel.numberOfLines
            ),
            createLineBreakModeMenuSection(
                with: lineBreakModelMenus,
                selectedItem: labelModel.lineBreakMode
            ),
            createTextAlignmentMenuSection(
                with: textAlignmentMenus,
                selectedItem: labelModel.alignment
            )
        ].flatMap { $0 }
    }
}

extension SDSLabelSectionConverter {
    private func createTextChangeSection(with text: String) -> [SectionModelType] {
        let inputComponent = SDSUserInputComponent(
            identifier: "userInput_component",
            title: "Label's Text",
            subTitle: "텍스트를 변경해보세요.",
            placeHolder: "텍스트를 입력해주세요.",
            text: text
        )
        
        let section = SectionModel(
            identifier: "userInput_component_section",
            itemModels: [inputComponent])
        
        return [section]
    }
    
    private func createTypoMenuSection(
        with menu: [SDSLabelViewController.TypographyMenu],
        selectedItem: SDSTypographyToken
    ) -> [SectionModelType] {
        let selectedMenu = SDSLabelViewController.TypographyMenu.tokenToTypoMenu(with: selectedItem)
        
        let menuTitles = menu.map { $0.rawValue }
        let component = SDSPickerComponent(
            identifier: "typoMenu_picker_component",
            title: "Typography",
            subTitle: "Typography 를 변경해보세요.",
            selectedItem: selectedMenu.rawValue,
            pickerItems: menuTitles
        )
        
        let section = SectionModel(
            identifier: "typoMenu_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createNumberOfLinesMenuSection(with menu: [SDSLabelViewController.NumberOfLinesMenu], selectedItem: Int) -> [SectionModelType] {
        let selectedItem = SDSLabelViewController.NumberOfLinesMenu.toMenu(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "number_of_line_picker_component",
            title: "numberOfLine",
            subTitle: "Label의 최대 라인수를 설정해보세요.",
            selectedItem: selectedItem.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "number_of_lines_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createLineBreakModeMenuSection(with menu: [SDSLabelViewController.LineBreakModeMenu], selectedItem: NSLineBreakMode) -> [SectionModelType] {
        let selectedMenu = SDSLabelViewController.LineBreakModeMenu.toLineBreakModeMenu(with: selectedItem)
        
        let component = SDSPickerComponent(
            identifier: "line_break_mode_picker_component",
            title: "LineBreakMode",
            subTitle: "말줄임 형태를 설정해보세요.",
            selectedItem:selectedMenu.rawValue ,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "line_break_mode_picker_section",
            itemModels: [component]
        )
        
        return [section]
    }
    
    private func createTextAlignmentMenuSection(with menu: [SDSLabelViewController.AlignmentMenu], selectedItem: NSTextAlignment) -> [SectionModelType] {
        let selectedMenu = SDSLabelViewController.AlignmentMenu.toAlignmentMenu(with: selectedItem)
        let component = SDSPickerComponent(
            identifier: "text_alignment_picker_component",
            title: "Text Alignment",
            subTitle: "Text 정렬 상태를 설정해보세요.",
            selectedItem: selectedMenu.rawValue,
            pickerItems: menu.map { $0.rawValue }
        )
        
        let section = SectionModel(
            identifier: "text_alignment_picker_section",
            itemModels: [component])
        
        return [section]
    }
}
