//
//  SDSSearchBarViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/24/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class SDSSearchBarView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class SDSSearchBarViewController: ViewController<SDSSearchBarView
> {
    private var cancellables = Set<AnyCancellable>()
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private let converter = SDSSearchBarSectionConverter()
    
    private var variantSubject = CurrentValueSubject<VariantType, Never>(.filled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAdapter()
    }
    
    private func bindAdapter() {
        variantSubject
            .sink { [weak self] variantType in
                let sections = self?.converter.createSections(variant: variantType) ?? []
                
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)

        adapter.actionEventPublisher
            .sink { [weak self] action in
                switch action {
                case let action as SDSPickerEvent:
                    self?.handlePickerEvent(with: action)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension SDSSearchBarViewController {
    enum VariantType: String, CaseIterable {
        case filled
        case outline
        
        var toTextFieldVariant: BaseTextField.Variant {
            switch self {
            case .filled:
                return .filled
            case .outline:
                return .outline
            }
        }
    }
    
    private func handlePickerEvent(with action: SDSPickerEvent) {
        let variantType = VariantType(rawValue: action.item) ?? .filled
        
        variantSubject.send(variantType)
    }
}
