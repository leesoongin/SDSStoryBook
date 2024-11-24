//
//  ToastShowcaseViewController.swift
//  DesignSystem
//
//  Created by 이숭인 on 10/30/24.
//

import Combine
import UIKit

final class ToastShowcaseView: BaseView {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setup() {
        super.setup()
        
    }
    
    override func setupSubviews() {
        addSubview(collectionView)
        
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ToastShowcaseViewController {
    enum Constants {
        static let showAnimationIdentifier: String = "show_animation_identifier"
        static let hideAnimationIdentifier: String = "hide_animation_identifier"
        static let positionIdentifier: String = "position_identifier"
        static let positionMarginIdentifier: String = "position_margin_identifier"
        static let toastPresentIdentifier = "toast_present_identifier"
    }
}

final class ToastShowcaseViewController: ViewController<ToastShowcaseView> {
    private var cancellables = Set<AnyCancellable>()
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    private var toastConfigure = ToastConfig()
    private var margin: CGFloat = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        Just(makeOptionSegment())
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        adapter.actionEventPublisher
            .sink { [weak self] actionItem in
                switch actionItem {
                case let action as SegmentControlAction:
                    self?.updateToastConfigure(
                        with: action.identifier, 
                        selectedIndex: action.selectedIndex
                    )
                case let action as ToastPresentAction:
                    if let configure = self?.toastConfigure {
                        Toast(with: configure)
                            .show()
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateToastConfigure(with identifier: String, selectedIndex: Int) {
        switch identifier {
        case Constants.showAnimationIdentifier:
            toastConfigure.showAnimationType = ToastConfig.ShowAnimationType(rawValue: selectedIndex) ?? .fadeIn
        case Constants.hideAnimationIdentifier:
            toastConfigure.hideAnimationType = ToastConfig.HideAnimationType(rawValue: selectedIndex) ?? .fadeOut
        case Constants.positionIdentifier:
            switch selectedIndex {
            case 0:
                toastConfigure.positionType = .absolute(.top(margin: margin))
            case 1:
                toastConfigure.positionType = .absolute(.center)
            case 2:
                toastConfigure.positionType = .absolute(.bottom(margin: margin))
            default: break
            }
        case Constants.positionMarginIdentifier:
            switch selectedIndex {
            case 0:
                self.margin = 12
            case 1:
                self.margin = 16
            case 2:
                self.margin = 20
            default:
                break
            }
        default: break
        }
    }
    
    func makeOptionSegment() -> [SectionModelType] {
        let items = [
            SegmentControlOptionComponent(
                identifier: Constants.showAnimationIdentifier,
                title: "Show Animation Type",
                items: ["fadeIn", "fromTop", "fromBottom"]
            ),
            SegmentControlOptionComponent(
                identifier: Constants.hideAnimationIdentifier,
                title: "Hide Animation Type",
                items: ["fadeOut", "toTop", "toBottom", "toLeft", "toRight"]),
            SegmentControlOptionComponent(
                identifier: Constants.positionIdentifier,
                title: "Position Type",
                items: ["top", "center", "bottom"]),
            SegmentControlOptionComponent(
                identifier: Constants.positionMarginIdentifier,
                title: "Position margin",
                items: ["12", "16", "20"]),
        ]
        
        let presentComponent = ToastPresentComponent(identifier: Constants.toastPresentIdentifier)
        
        let section = SectionModel(
            identifier: "Option_section",
            itemModels: items + [presentComponent]
        )
        
        return [section]
    }
}



import UIKit
import Combine

struct SegmentControlAction: ActionEventItem {
    let identifier: String
    let selectedIndex: Int
}

struct SegmentControlOptionComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    let title: String
    let items: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(items)
    }
}

extension SegmentControlOptionComponent {
    typealias ContentType = SegmentControlOptionView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.items, title: context.title)
        
        content.segmentControl?.selectedSegmentIndexPublisher
            .sink { [weak content] selectedIndex in
                let action = SegmentControlAction(
                    identifier: context.identifier,
                    selectedIndex: selectedIndex
                )
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
    }
}

final class SegmentControlOptionView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .black
    }
    
    let segmentContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
    }
    
    var segmentControl: UISegmentedControl? = nil
    
    override func setup() {
        super.setup()
        
    }
    
    override func setupSubviews() {
        addSubview(titleLabel)
        addSubview(segmentContainerView)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        segmentContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func bind(with items: [String], title: String) {
        titleLabel.text = title
        
        self.segmentControl = UISegmentedControl(items: items)
        segmentControl?.selectedSegmentIndex = 0
        segmentControl?.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        segmentContainerView.addArrangedSubview(segmentControl!)
    }
}

struct ToastPresentComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .adaptive
    
    var identifier: String
    
    func hash(into hasher: inout Hasher) {
        
    }
}

struct ToastPresentAction: ActionEventItem {
    let identifier: String
}

extension ToastPresentComponent {
    typealias ContentType = ToastPresentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.button.tap
            .sink { [weak content] _ in
                
                let action = ToastPresentAction(identifier: context.identifier)
                content?.actionEventEmitter.send(action)
            }
            .store(in: &cancellable)
    }
}

final class ToastPresentView: BaseView, ActionEventEmitable {
    var actionEventEmitter = PassthroughSubject<ActionEventItem, Never>()
    
    
    
    let button = SDSButton(
        theme: .purple,
        variant: .primary,
        style: .filled,
        size: .midium,
        state: .enabled
    ).then {
        $0.text = "Show Toast Message"
    }
    
    override func setupSubviews() {
        addSubview(button)
    }
    
    override func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

