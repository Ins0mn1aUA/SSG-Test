//
//  PhotoModel.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

struct PhotoModel: Hashable {
    let id: Int
    let image: UIImage?
    let gender: Gender
    let age: Int
}
