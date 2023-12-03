//
//  Gender.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

enum Gender: String {
    
    case male = "Male"
    case female = "Female"
    case any = "Any"
    
    var image: UIImage? {
        switch self {
        case .male: return UIImage(named: "GenderMale")
        case .female: return UIImage(named: "GenderFemale")
        case .any: return UIImage(named: "GenderAny")
        }
    }
    
    var next: Gender {
        switch self {
        case .male: return .female
        case .female: return .any
        case .any: return .male
        }
    }
}
