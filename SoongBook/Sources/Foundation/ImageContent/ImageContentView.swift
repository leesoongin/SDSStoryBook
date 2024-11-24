//
//  ImageContentView.swift
//  SoongBook
//
//  Created by 이숭인 on 11/11/24.
//

import UIKit
import Kingfisher
import Lottie

public class ImageContentView: UIImageView {
    // MARK: - Private Properties
    private var cachedImage: UIImage?
    private var cachedURL: URL?

    // MARK: - Public Properties
    /// lottie animation view
    public let animationView = LottieAnimationView().then {
        $0.backgroundBehavior = .pauseAndRestore
    }
    /// lottie loopMode. default: .playOnce
    public var loopMode: LottieLoopMode = .playOnce {
        didSet { animationView.loopMode = loopMode }
    }
    /// lottie backgroundBehavior. default: .pauseAndRestore
    public var backgroundBehavior: LottieBackgroundBehavior = .pauseAndRestore {
        didSet { animationView.backgroundBehavior = backgroundBehavior }
    }
    /// lottie fetch 이후 자동 재생 여부. Default: true
    public var autoPlayIfPossible: Bool = true
    
    /// Kingfisher image fetch options
    public var imageFetchOptions: KingfisherOptionsInfo = [
        .transition(.fade(0.20)),
        .callbackQueue(.mainAsync),
        .scaleFactor(UIScreen.main.scale),
        .cacheOriginalImage
    ]
    /// image placeholder. default: nil
    public var imagePlaceholder: UIImage? {
        didSet { image = imagePlaceholder }
    }
}

// MARK: - image fetch
extension ImageContentView {
    public func fetch(
        _ imageSource: (any ImageSource)?,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        if needsInitialize(with: imageSource) {
            initializeForReuse()
            image = imagePlaceholder
        }

        if imageSource is URL {
            fetchImageFromURL(imageSource, completion: completion)
        } else {
            fetchImage(imageSource)
        }
    }

    private func fetchImage(_ imageSource: (any ImageSource)?) {
        guard let imageSource = imageSource as? UIImage else { return }
        image = imageSource
        cachedImage = imageSource
    }

    private func fetchImageFromURL(_ imageSource: (any ImageSource)?,
                                   completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) {
        let imageSource = imageSource as? URL
        var options = imageFetchOptions
        if !needsInitialize(with: imageSource) {
            options.append(.keepCurrentImageWhileLoading)
        }
        let completionWrapper: ((Result<RetrieveImageResult, KingfisherError>) -> Void) = { [weak self] result in
            self?.cachedURL = imageSource
            completion?(result)
        }
        kf.setImage(with: imageSource,
                    placeholder: imagePlaceholder,
                    options: options,
                    completionHandler: completionWrapper)
    }
}

// MARK: - animation fetch
extension ImageContentView {
    public func playIfPossible(completion: ((Bool) -> Void)? = nil) {
        guard !animationView.isAnimationPlaying, animationView.animation.isNotNil else { return }
        animationView.play(completion: completion)
    }

    public func fetch(_ animationSource: (any AnimationSource)?, completion: ((Bool) -> Void)? = nil) {
        attachAnimationViewIfNeeded()

        if let animationSource = animationSource as? LocalAnimation {
            fetchLocalAnimationIfPossible(animationSource, completion: completion)
        } else if let animationSource = animationSource as? RemoteAnimation {
            fetchRemoteAnimationIfPossible(animationSource, completion: completion)
        }
    }

    private func fetchLocalAnimationIfPossible(_ animationSource: LocalAnimation, completion: ((Bool) -> Void)?) {
        let animation = LottieAnimation.named(animationSource.name, animationCache: DefaultAnimationCache.sharedCache)
        animationView.animation = animation
        requestPlayIfPossible(completion: completion)
    }

    private func fetchRemoteAnimationIfPossible(_ animationSource: RemoteAnimation, completion: ((Bool) -> Void)?) {
        LottieAnimation.loadedFrom(url: animationSource.url, closure: { [weak self] animation in
            self?.animationView.animation = animation
            self?.requestPlayIfPossible(completion: completion)
        }, animationCache: DefaultAnimationCache.sharedCache)
    }

    private func requestPlayIfPossible(completion: ((Bool) -> Void)? = nil) {
        guard autoPlayIfPossible else { return }
        playIfPossible(completion: completion)
    }
}

// MARK: - Private Method
extension ImageContentView {
    private func needsInitialize(with imageSource: (any ImageSource)?) -> Bool {
        if let imageSource = imageSource as? UIImage, imageSource == cachedImage {
            return false
        }

        if let imageSource = imageSource as? URL, imageSource == cachedURL {
            return false
        }

        return true
    }

    private func initializeForReuse() {
        kf.cancelDownloadTask()
        let resource: Resource? = nil
        kf.setImage(with: resource)
    }
}

// MARK: - animationView attach, detach
extension ImageContentView {
    private func attachAnimationViewIfNeeded() {
        guard animationView.superview.isNil else { return }
        initializeForReuse()
        image = nil
        addSubview(animationView)
        animationView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func detachAnimationViewIfNeeded() {
        guard animationView.superview.isNotNil else { return }
        animationView.stop()
        animationView.removeFromSuperview()
        animationView.snp.removeConstraints()
    }
}
