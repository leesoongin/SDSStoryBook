//
//  CommonButton.swift
//  SoongBook
//
//  Created by 이숭인 on 11/16/24.
//

import UIKit
import Combine
import CombineCocoa

public class CommonButton: UIControl {
    private var cancellables = Set<AnyCancellable>()
    
    let variant: CommonButton.Variant
    let size: CommonButton.Size
    let style: CommonButton.Style
    
    public var buttonState: CommonButton.State {
        didSet { updateState() }
    }
    
    public override var isEnabled: Bool {
        get { super.isEnabled }
        set {
            buttonState = newValue ? .enabled : .disabled
            super.isEnabled = newValue
        }
    }

    public override var isSelected: Bool {
        get { super.isSelected }
        set {
            buttonState = newValue ? .pressed : .enabled
            super.isSelected = newValue
        }
    }
    
    init(variant: Variant, style: Style, size: Size, state: State) {
        self.variant = variant
        self.style = style
        self.size = size
        self.buttonState = state
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupSubviews()
        setupConstraints()
        
        bindTouchable()
    }
    
    func setupSubviews() { }
    func setupConstraints() { }
    func updateState() { }
}

//MARK: - Bind Button Touchable
extension CommonButton {
    private func bindTouchable() {
        controlEventPublisher(for: .touchDown)
            .sink { [weak self] _ in
                guard self?.buttonState != .disabled else { return }
                
                self?.buttonState = .pressed
            }
            .store(in: &cancellables)
        
        controlEventPublisher(for: [
            .touchUpInside,
            .touchUpOutside,
            .touchCancel]
        )
            .sink { [weak self] _ in
                guard self?.buttonState != .disabled else { return }
                
                self?.buttonState = .enabled
            }
            .store(in: &cancellables)
    }
}
