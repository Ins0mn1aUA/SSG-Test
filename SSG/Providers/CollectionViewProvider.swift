//
//  CollectionViewProvider.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

class CollectionViewProvider: NSObject, UICollectionViewDataSource {
    
    enum Filter {
        case age(from: Int, to: Int)
        case gender(_: Gender)
    }
    
    // MARK: - Public properties
    
    public var items: [PhotoModel] = []
    
    // The variable is necessary for understanding the difference between old and new array values
    public var difference: CollectionDifference<PhotoModel>?
    // This variable stores filtered data using gender and age filters
    public var filteredItems: [PhotoModel] = []
    
    // MARK: - Private properties
    
    // An auxiliary variable for storing gender-filtered values
    private var filteredByGender: [PhotoModel] = []
    private var genderFilter: Gender? {
        didSet {
            guard let gender = genderFilter else { return }
            if gender == .any {
                filteredByGender = items
            } else {
                filteredByGender = items.filter({ $0.gender == gender })
            }
            filteredItems = intersectionByAllFilters()
        }
    }
    
    // An auxiliary variable for storing age-filtered values
    private var filteredByAge: [PhotoModel] = []
    private var ageFilter: (from: Int, to: Int)? {
        didSet {
            guard let ageFilter = ageFilter else {
                return
            }
            filteredByAge = items.filter({ $0.age >= ageFilter.from && $0.age <= ageFilter.to })
            filteredItems = intersectionByAllFilters()
        }
    }
    
    
    // MARK: - Public methods
    
    public func filterByAge(from: Int, to: Int) {
        ageFilter = (from, to)
    }
    
    public func filter(by gender: Gender) {
        genderFilter = gender
    }
    
    // MARK: - Private methods
    
    private func intersectionByAllFilters() -> [PhotoModel] {
        
        let oldFilteredItems = filteredItems
        
        let filteredByGenderSet = Set(filteredByGender)
        let filteredByAgeSet = Set(filteredByAge)
        let intersection = filteredByGenderSet.intersection(filteredByAgeSet)
        let newFilteredItems = Array(intersection).sorted(by: { $0.id > $1.id })
        
        // Storing difference to propper update of collectionView
        difference = newFilteredItems.difference(from: oldFilteredItems)
        
        return newFilteredItems
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { filteredItems.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(with: filteredItems[indexPath.row]) 
        return cell
    }
}
