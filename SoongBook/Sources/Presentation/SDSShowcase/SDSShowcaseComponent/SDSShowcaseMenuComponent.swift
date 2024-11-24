//
//  SDSShowcaseMenuComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/11/24.
//

import UIKit
import Combine
import SnapKit
import Then
import CombineCocoa

struct SDSShowcaseMenuAction: ActionEventItem {
    let identifier: String
}

struct SDSShowcaseMenuComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension SDSShowcaseMenuComponent {
    typealias ContentType = SDSShowcaseMenuView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.title)
        
        content.tapGesture.tapPublisher
            .sink { [weak content] _ in
                let action = SDSShowcaseMenuAction(identifier: context.identifier)
                content?.actionEventEmitter.send(action)
                
            }
            .store(in: &cancellable)
    }
}

extension SDSShowcaseMenuView {
    private enum Constants {
        static let titleTypo = Typography(token: .mediumBody, colorStyle: .grayPrimary)
    }
}

final class SDSShowcaseMenuView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    let tapGesture = UITapGestureRecognizer()
    
    let container = UIView()
    
    let titleLabel = SDSLabel(typography: Constants.titleTypo)
    let rightButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_chevronrt_line"), for: .normal)
        $0.tintColor = .gray900
    }
    
    override func setup() {
        super.setup()
        
        self.addGestureRecognizer(tapGesture)
    }
    
    override func setupSubviews() {
        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(rightButton)
    }
    
    override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.size.equalTo(32)
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(16)
        }
    }
    
    func bind(with title: String) {
        titleLabel.text = title
    }
}

