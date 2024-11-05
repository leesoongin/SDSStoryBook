//
//  UITextView+AttributedTextPublisher.swift
//  SoongBook
//
//  Created by 이숭인 on 11/5/24.
//

import UIKit
import Combine
import CombineCocoa

public extension UITextView {
    var attributedTextPublisher: AnyPublisher<NSAttributedString?, Never> {
        Deferred { [weak textView = self] in
            textView?.textStorage
                .didProcessEditingRangeChangeInLengthPublisher
                .receive(on: DispatchQueue.main)
                .map { _ in textView?.attributedText }
                .prepend(textView?.attributedText)
                .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

