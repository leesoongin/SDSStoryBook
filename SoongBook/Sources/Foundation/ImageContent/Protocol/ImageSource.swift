//
//  ImageSource.swift
//  SoongBook
//
//  Created by 이숭인 on 11/14/24.
//

import UIKit

public protocol ImageSource: Hashable { }

extension UIImage: ImageSource { }
extension URL: ImageSource { }
