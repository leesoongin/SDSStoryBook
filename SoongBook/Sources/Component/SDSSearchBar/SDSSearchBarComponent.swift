//
//  SDSSearchBarComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/24/24.
//

import UIKit
import Combine
import SnapKit
import Then

struct SDSSearchBarTextChangeAction: ActionEventItem {
    let identifier: String
    let text: String
}

struct SDSSearchBarClearAction: ActionEventItem {
    let identifier: String
}

struct SDSSearchBarComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .static(300)
    
    var identifier: String
    let variant: BaseTextField.Variant
    let size: BaseTextField.Size
    let theme: TextFieldThemeType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(variant)
        hasher.combine(size)
        hasher.combine(theme)
    }
    
    func prepareForReuse(content: SDSSearchBarComponentView) {
        content.container.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension SDSSearchBarComponent {
    typealias ContentType = SDSSearchBarComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(
            variant: context.variant,
            size: context.size,
            theme: context.theme
        )
        
        content.searchBar?.textChangedPublisher
            .dropFirst()
            .sink { [weak content] text in
                let textChangeAction = SDSSearchBarTextChangeAction(
                    identifier: context.identifier,
                    text: text
                )
                
                content?.actionEventEmitter.send(textChangeAction)
            }
            .store(in: &cancellable)
        
        content.searchBar?.clearButtonTapPublisher
            .sink { [weak content] _ in
                let clearAction = SDSSearchBarClearAction(
                    identifier: context.identifier
                )
                
                content?.actionEventEmitter.send(clearAction)
            }
            .store(in: &cancellable)
    }
}

final class SDSSearchBarComponentView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let container = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    var searchBar: SDSSearchBar? = nil
    
    override func setupSubviews() {
        addSubview(container)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func bind(variant: BaseTextField.Variant, size: BaseTextField.Size, theme: TextFieldThemeType) {
        searchBar = SDSSearchBar(
            variant: variant,
            size: size,
            theme: theme
        )
        
        searchBar?.placeholder = "검색어를 입력해주세요."
        searchBar?.leftImage = .icSearchUnpressed
        
        container.addArrangedSubview(searchBar!)
    }
}

