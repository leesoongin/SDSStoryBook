//
//  SDSLabel.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit
import SnapKit

public final class SDSLabel: BaseView {
    //MARK: UI
    private let label: UILabel
    private let typography: Typography
    
    //MARK: Properties
    /// `UILabel` 의 `text` 값을 설정합니다.
    public var text: String? {
        didSet { updateText() }
    }
     /// `UILabel` 의 `Color Style` 값을 설정합니다.
    public lazy var textColorStyle: SDSColorToken.Text = typography.colorStyle {
        didSet { updateColorStyle() }
    }
    
    /// `UILabel` 의 `lineBreakMode` 값을 설정합니다. 기본값은 `.byTruncatingTail` 입니다.
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet { updateLineBreakMode() }
    }
    /// `UILabel` 의 `numberOfLines` 값을 설정합니다. 기본값은 `0` 입니다.
    public var numberOfLines: Int = 0 {
        didSet { updateNumberOfLines() }
    }
    
    //MARK: Initializer
    init(typography: Typography) {
        self.typography = typography
        self.label = UILabel(typography: typography)
        
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func setup() {
        super.setup()
    }
    
    override public func setupSubviews() {
        addSubview(label)
    }
    
    override public func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func applyTypography(with typo: Typography) {
        label.applyTypography(with: typo)
    }
}

extension SDSLabel {
    private func updateText() {
        label.text = self.text
//        layoutIfNeeded()
    }
    
    private func updateColorStyle() {
        label.textColor = textColorStyle.color
    }
    
    private func updateLineBreakMode() {
        label.lineBreakMode = self.lineBreakMode
    }
    
    private func updateNumberOfLines() {
        label.numberOfLines = self.numberOfLines
    }
}
