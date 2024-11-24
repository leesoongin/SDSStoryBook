//
//  SDSImageComponent.swift
//  SoongBook
//
//  Created by 이숭인 on 11/12/24.
//

import UIKit
import Combine
import SnapKit
import Then

struct SDSImageComponent: Component {
    var widthStrategy: ViewWidthStrategy = .column(2)
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let name: String
    let imageSource: any ImageSource
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(imageSource)
    }
}

extension SDSImageComponent {
    typealias ContentType = SDSImageView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.imageSource, name: context.name)
    }
}

final class SDSImageView: BaseView {
    let containerView = UIView().then {
        $0.layer.cornerRadius = 8
    }
    
    let nameLabel = SDSLabel(typography: Constants.nameTypo)
    let imageContentView = ImageContentView()
    
    override func setup() {
        super.setup()
        
        containerView.backgroundColor = .gray200
    }
    
    override func setupSubviews() {
        addSubview(containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(imageContentView)
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        imageContentView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
            make.size.equalTo(42)
        }
    }
    
    func bind(with imageSource: any ImageSource, name: String) {
        imageContentView.fetch(imageSource)
        
        nameLabel.text = name
    }
}

extension SDSImageView {
    private enum Constants {
        static let nameTypo = Typography(
            token: .smallSubTitle,
            colorStyle: .grayPrimary
        )
    }
}
