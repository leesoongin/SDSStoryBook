//
//  SDSButton.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit
import SnapKit
import Then

public final class SDSButton: CommonButton {
    //MARK: - Properties
    private let theme: ButtonTheme
    
    public var text: String? {
        didSet { updateText() }
    }
    
    public var image: (any ImageSource)? {
        didSet { updateImage() }
    }
    
    public var additionalImage: (any ImageSource)? {
        didSet { updateAdditionalImage() }
    }
    
    public var buttonShape: Shape = .default {
        didSet { updateShape() }
    }
    public var imagePosition: ImagePosition = .start {
        didSet { updateImagePosition(with: oldValue) }
    }
    
    public var isStretch: Bool = true {
        didSet { updateStretch() }
    }
    
    private var iconTintColor: UIColor {
        theme.tintColor(variant: variant, style: style, state: buttonState)
    }
    
    private var fontColor: UIColor {
        theme.fontColor(variant: variant, style: style, state: buttonState)
    }
    private var _backgroundColor: UIColor {
        theme.backgroundColor(variant: variant, style: style, state: buttonState)
    }
    private var highlightDimmedColor: UIColor {
        theme.highlightDimmedColor(variant: variant, style: style, state: buttonState)
    }
    private var borderColor: CGColor {
        theme.borderColor(variant: variant, style: style, state: buttonState)
    }
    
    private var sizeLayoutMargins: UIEdgeInsets {
        size.layoutMargin
    }
    
    //MARK: - Views
    private let container = UIView().then {
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    private let highlightDimmedView = UIView().then {
        $0.isUserInteractionEnabled = false
    }
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.isUserInteractionEnabled = false
    }
    
    private let imageView = ImageContentView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    private let label = UILabel()
    private let additionalImageView = ImageContentView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    //MARK: - Initializer
    public init(
        theme: ButtonThemeType,
        variant: CommonButton.Variant,
        style: CommonButton.Style,
        size: CommonButton.Size,
        state: CommonButton.State = .enabled
    ) {
        self.theme = theme.theme
        
        super.init(variant: variant, style: style, size: size, state: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    public override func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        super.setContentCompressionResistancePriority(priority, for: axis)
        label.setContentCompressionResistancePriority(priority, for: axis)
    }
    
    public override func setupSubviews() {
        addSubview(container)
        container.addSubview(highlightDimmedView)
        container.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(additionalImageView)
    }
    
    public override func setupConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(size.height)
        }
        
        highlightDimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.verticalEdges.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(sizeLayoutMargins.left)
            make.trailing.lessThanOrEqualToSuperview().inset(sizeLayoutMargins.right)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(size.imageSize)
        }
        
        additionalImageView.snp.makeConstraints { make in
            make.size.equalTo(size.imageSize)
        }
    }
    
    public override func setup() {
        super.setup()
        // setup
        setupLayer()
        setupStackView()
        
        // update
        updateState()
        updateText()
        updateImage()
        updateAdditionalImage()
        updateShape()
        updateStretch()
    }
    
    public override func updateState() {
        updateColors()
    }
    
    private func setupLayer() {
        layer.borderWidth = 1
        layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 3.0
    }
    
    private func setupStackView() {
        stackView.spacing = size.spacing
    }
}

//MARK: - Update
extension SDSButton {
    private func updateText() {
        label.text = text
        label.isHidden = text == nil
    }
    
    private func updateImage() {
        imageView.fetch(image)
        imageView.isHidden = image.isNil
    }
    
    private func updateAdditionalImage() {
        additionalImageView.fetch(additionalImage)
        additionalImageView.isHidden = additionalImage == nil
    }
    
    private func updateStretch() {
        stackView.snp.remakeConstraints { make in
            make.verticalEdges.centerX.equalToSuperview()
            
            if isStretch {
                make.leading.greaterThanOrEqualToSuperview().inset(sizeLayoutMargins.left)
                make.trailing.lessThanOrEqualToSuperview().inset(sizeLayoutMargins.right)
            } else {
                make.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    private func updateColors() {
        UIView.animate(withDuration: 0.2) {
            self.container.backgroundColor = self._backgroundColor
            self.highlightDimmedView.backgroundColor = self.highlightDimmedColor
        }
        
        label.textColor = fontColor
        
        layer.borderColor = borderColor
        imageView.tintColor = iconTintColor
        additionalImageView.tintColor = iconTintColor
    }
}

//MARK: - ShapeHandleable
extension SDSButton: SDSButton.ShapeHandleable {
    public func updateShape() {
        layer.cornerRadius = buttonShape.getRadius(with: size)
        container.layer.cornerRadius = buttonShape.getRadius(with: size)
    }
}

//MARK: - ImagePositionHandleable
extension SDSButton: SDSButton.ImagePositionHandleable {
    public func updateImagePosition(with position: ImagePosition) {
        //TODO: 보류. 이거 굳이? 어느 상황에 필요할지 잘 모르겠음 고민해보자.
    }
}
