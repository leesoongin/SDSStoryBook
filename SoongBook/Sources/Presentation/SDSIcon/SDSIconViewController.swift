//
//  SDSIconViewController.swift
//  SoongBook
//
//  Created by 이숭인 on 11/11/24.
//

import UIKit
import SnapKit
import Then
import Combine

final class SDSIconView: BaseView {
    let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    override func setup() {
        super.setup()
        
        backgroundColor = .white000
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

final class SDSIconViewController: ViewController<SDSIconView> {
    lazy var adapter = CollectionViewAdapter(with: contentView.collectionView).then {
        $0.pinToVisibleBoundsSectionHeader()
    }
    var cancellables = Set<AnyCancellable>()
    
    let imageContents: [ImageContentType] = ImageContentType.allCases
    var imageComponents: [SDSImageComponent] {
        return imageContents.map { imageType in
            SDSImageComponent(
                identifier: imageType.rawValue,
                name: imageType.rawValue, 
                imageSource: imageType.image!
            )
        }
    }
    
    let animationImageContents: [AnimationImageContentType] = AnimationImageContentType.allCases
    var animationImageComponents: [SDSAnimationImageComponent] {
        return animationImageContents.map { imageContent in
            SDSAnimationImageComponent(
                identifier: imageContent.name,
                name: imageContent.name,
                animationImageSource: imageContent.name.asLocalAnimation
            )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        bind()
    }
    
    func bind() {
        Publishers.CombineLatest(Just(imageComponents), Just(animationImageComponents))
            .map { (imageComponents, animationComponents) -> [SectionModelType] in
                let imageSectionHeader = SDSIconHeaderComponent(
                    identifier: "image_content_section_header",
                    title: "일반 이미지"
                )
                let imageSection = SectionModel(
                    identifier: "image_content_section",
                    header: imageSectionHeader,
                    itemModels: imageComponents
                )
                
                let animationImageSectionHeader = SDSIconHeaderComponent(
                    identifier: "animation_content_section_header",
                    title: "애니메이션 이미지"
                )
                let animationImageSection = SectionModel(
                    identifier: "animation_image_content_section",
                    header: animationImageSectionHeader,
                    itemModels: animationComponents
                )
                
                return [imageSection] + [animationImageSection]
            }
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
    }
}

extension SDSIconViewController {
    enum ImageContentType: String, CaseIterable {
        case ic_chevronrt_line
        case ic_chevrondn_line
        case ic_chevronlf_line
        case ic_chevronup_line
        
        var image: UIImage? {
            switch self {
            case .ic_chevronup_line:
                return UIImage(named: "ic_chevronup_line")
            case .ic_chevrondn_line:
                return UIImage(named: "ic_chevrondn_line")
            case .ic_chevronlf_line:
                return UIImage(named: "ic_chevronlf_line")
            case .ic_chevronrt_line:
                return UIImage(named: "ic_chevronrt_line")
            }
        }
    }
    
    enum AnimationImageContentType: String, CaseIterable {
        case loadingOne
        case loadingTwo
        case indicatorOne
        case indicatorTwo
        
        var name: String {
            switch self {
            case .loadingOne:
                return "loading_one"
            case .loadingTwo:
                return "loading_two"
            case .indicatorOne:
                return "indicator_one"
            case .indicatorTwo:
                return "indicator_two"
            }
        }
    }
}
