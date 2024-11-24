//
//  AnimationSource.swift
//  SoongBook
//
//  Created by 이숭인 on 11/14/24.
//

import Foundation

//MARK: - AnimationSource
public protocol AnimationSource: Hashable { }

/// 프로젝트 내에 존재하는 lottie json
public struct LocalAnimation: AnimationSource {
    let name: String
}

/// 네트워크를 사용해 받아와야하는 lottie json
public struct RemoteAnimation: AnimationSource {
    let url: URL
}

extension String {
    public var asLocalAnimation: LocalAnimation { LocalAnimation(name: self) }
}

extension URL {
    public var asRemoteAnimation: RemoteAnimation { RemoteAnimation(url: self) }
}
