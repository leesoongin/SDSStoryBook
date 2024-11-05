//
//  ViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/4/24.
//

import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    let testLabel = SDSLabel(typography: Typography(
        style: .largeSubTitle,
        colorStyle: .textWarned)
    ).then {
        $0.text = "안녕하세요"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .violet400
        
        view.addSubview(testLabel)
        
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
        }
    }
}
