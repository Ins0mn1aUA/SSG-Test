//
//  PhotosViewModel.swift
//  SSG
//
//  Created by Григорий Стеценко on 02.12.2023.
//

import UIKit

class PhotosViewModel {
    
    // MARK: - Public properties
    
    public var items: [PhotoModel] = [
        PhotoModel(id: 0, image: UIImage(named: "photo_0"), gender: .female, age: 24),
        PhotoModel(id: 1, image: UIImage(named: "photo_1"), gender: .male, age: 36),
        PhotoModel(id: 2, image: UIImage(named: "photo_2"), gender: .female, age: 18),
        PhotoModel(id: 3, image: UIImage(named: "photo_3"), gender: .male, age: 19),
        PhotoModel(id: 4, image: UIImage(named: "photo_4"), gender: .female, age: 54),
        PhotoModel(id: 5, image: UIImage(named: "photo_5"), gender: .female, age: 34),
        PhotoModel(id: 6, image: UIImage(named: "photo_6"), gender: .male, age: 61),
        PhotoModel(id: 7, image: UIImage(named: "photo_7"), gender: .female, age: 36),
        PhotoModel(id: 8, image: UIImage(named: "photo_8"), gender: .male, age: 25),
        PhotoModel(id: 9, image: UIImage(named: "photo_9"), gender: .female, age: 21),
        PhotoModel(id: 10, image: UIImage(named: "photo_10"), gender: .female, age: 19),
        PhotoModel(id: 11, image: UIImage(named: "photo_11"), gender: .male, age: 41),
        PhotoModel(id: 12, image: UIImage(named: "photo_12"), gender: .female, age: 26),
        PhotoModel(id: 13, image: UIImage(named: "photo_13"), gender: .male, age: 48),
        PhotoModel(id: 14, image: UIImage(named: "photo_14"), gender: .female, age: 22),
    ]
    
    public let defaultMinimumAge: Int = 20
    public let defaultMaximumAge: Int = 60
    
    public var selectedGender: Gender = .any
    
    public var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public var collectionViewColumnsCount: Int {
        return isIPad ? 5 : 3
    }

    // MARK: - Public methods
    
    public func getFormattedAgeRangeString(fromAge: Int, toAge: Int) -> String {
        return "\(fromAge) - \(toAge)"
    }
}
