//
//  PhotosViewController.swift
//  SSG
//
//  Created by Григорий Стеценко on 02.12.2023.
//

import UIKit
import collection_view_layouts
import MaterialComponents.MaterialRipple

class PhotosViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var filtersView: UIView!
    private var filtersViewHeightConstraint: NSLayoutConstraint!
    
    private var filterButtonsStackView: UIStackView!
    private var filterByGenderButton: BaseButton!
    private let filterByGenderButtonRippleTouchController = MDCRippleTouchController()
    private var filterByAgeButton: BaseButton!
    private let filterByAgeButtonRippleTouchController = MDCRippleTouchController()
     
    private var leftSeparatorView: UIView!
    private var rightSeparatorView: UIView!
    
    private var filterByCountryButton: BaseButton!
    private let filterByCountryButtonRippleTouchController = MDCRippleTouchController()

    private var filterByAgeRangeSlider: RangeSlider!
    private var isFilterByAgeRangeSliderShown: Bool = false

    private var photosCollectionView: UICollectionView!
    private var photosCollectionViewLayout = PinterestLayout()
    private let photosCollectionViewProvider = CollectionViewProvider()
    private var photosCollectionViewCellSizes: [CGSize] = []

    private var isFirstTimeLayoutSubviews: Bool = true
    
    private let viewModel = PhotosViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        // Ripple effect controller
        setupRoundedCorners()
        
        filterByGenderButtonRippleTouchController.rippleView.rippleColor = UIColor.appColor(.baseButtonHighlightedBackgroundColor)
        filterByGenderButtonRippleTouchController.addRipple(to: filterByGenderButton)
        
        filterByAgeButtonRippleTouchController.rippleView.rippleColor = UIColor.appColor(.baseButtonHighlightedBackgroundColor)
        filterByAgeButtonRippleTouchController.addRipple(to: filterByAgeButton)
        
        filterByCountryButtonRippleTouchController.rippleView.rippleColor = UIColor.appColor(.baseButtonHighlightedBackgroundColor)
        filterByCountryButtonRippleTouchController.addRipple(to: filterByCountryButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        if isFirstTimeLayoutSubviews {
            isFirstTimeLayoutSubviews = false
            prepareCollectionViewCellSizes()
            photosCollectionView.reloadData()
        }
        
        filterByAgeRangeSlider.updateLayerFrames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] _ in
            self?.updateLayout()
        }
        
        coordinator.animate(alongsideTransition: completionHandler, completion: completionHandler)

    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        
        navigationItem.title = "New Photos"
        
        // Filters View
        filtersView = UIView()
        filtersView.backgroundColor = .white
        view.addSubview(filtersView)
        
        // Filter buttons StackView
        filterButtonsStackView = UIStackView()
        filterButtonsStackView.axis = .horizontal
        filterButtonsStackView.alignment = .center
        filterButtonsStackView.distribution = .fill
        filtersView.addSubview(filterButtonsStackView)
        
        // Filter by gender BaseButton
        filterByGenderButton = BaseButton()
        filterByGenderButton.layer.cornerRadius = 3
        filterByGenderButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        filterByGenderButton.clipsToBounds = true
        
        filterByGenderButton.setImage(viewModel.selectedGender.image, for: .normal)
        filterByGenderButton.setImage(viewModel.selectedGender.image, for: .highlighted)
        filterByGenderButton.setTitle(viewModel.selectedGender.rawValue, for: .normal)
        filterByGenderButton.centerTextAndImage(spacing: 8)
        filterByGenderButton.addTarget(self, action: #selector(filterByGenderButtonTapped), for: .touchUpInside)
        filterButtonsStackView.addArrangedSubview(filterByGenderButton)
        
        // Left Separator
        leftSeparatorView = UIView()
        leftSeparatorView.backgroundColor = UIColor.appColor(.separatorGray)
        filterButtonsStackView.addArrangedSubview(leftSeparatorView)
        
        // Filter by age RangeSlider
        filterByAgeRangeSlider = RangeSlider()
        filterByAgeRangeSlider.lowerValue = CGFloat(viewModel.defaultMinimumAge)
        filterByAgeRangeSlider.upperValue = CGFloat(viewModel.defaultMaximumAge)
        filterByAgeRangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        filtersView.addSubview(filterByAgeRangeSlider)
        
        // Filter by age BaseButton
        filterByAgeButton = BaseButton()
        filterByAgeButton.setTitle(viewModel.getFormattedAgeRangeString(fromAge: viewModel.defaultMinimumAge, toAge: viewModel.defaultMaximumAge), for: .normal)
        filterByAgeButton.setTitleColor(UIColor.appColor(.mainBlue), for: .normal)
        filterByAgeButton.addTarget(self, action: #selector(filterByAgeButtonTapped), for: .touchUpInside)
        filterButtonsStackView.addArrangedSubview(filterByAgeButton)
        
        // Right Separator
        rightSeparatorView = UIView()
        rightSeparatorView.backgroundColor = UIColor.appColor(.separatorGray)
        filterButtonsStackView.addArrangedSubview(rightSeparatorView)
        
        // Filter by country BaseButton
        filterByCountryButton = BaseButton()
        filterByCountryButton.setTitle("Azerbaijan", for: .normal)
        filterByCountryButton.setImage(UIImage(named: "AzerbaijanFlag"), for: .normal)
        filterByCountryButton.setImage(UIImage(named: "AzerbaijanFlag"), for: .highlighted)
        filterByCountryButton.layer.cornerRadius = 3
        filterByCountryButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        filterByCountryButton.clipsToBounds = true
        filterByCountryButton.centerTextAndImage(spacing: 8)
        filterButtonsStackView.addArrangedSubview(filterByCountryButton)
        
        // Photos CollectionView Layout
        photosCollectionViewLayout.delegate = self
        photosCollectionViewLayout.columnsCount = viewModel.collectionViewColumnsCount
        photosCollectionViewLayout.contentPadding = .init(horizontal: viewModel.isIPad ? 0 : 3, vertical: 0)
        photosCollectionViewLayout.cellsPadding = .init(horizontal: 3, vertical: 3)
        
        // Photos CollectionView Provider
        photosCollectionViewProvider.items = viewModel.items
        photosCollectionViewProvider.filter(by: viewModel.selectedGender)
        photosCollectionViewProvider.filterByAge(from: viewModel.defaultMinimumAge, to: viewModel.defaultMaximumAge)
        
        // Photos CollectionView
        photosCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: photosCollectionViewLayout)
        photosCollectionView.backgroundColor = UIColor.appColor(.sliderTrackTintColor)
        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        photosCollectionView.collectionViewLayout = photosCollectionViewLayout
        photosCollectionView.dataSource = photosCollectionViewProvider
        photosCollectionView.contentInset = .init(top: viewModel.isIPad ? 16 : 3, left: 0, bottom: 0, right: 0)
        photosCollectionView.showsVerticalScrollIndicator = false
        photosCollectionView.alwaysBounceVertical = true
        view.addSubview(photosCollectionView)
        
        prepareCollectionViewCellSizes()
        photosCollectionView.reloadData()
    }
    
    private func setupLayout() {
        
        filtersViewHeightConstraint = filtersView.heightAnchor.constraint(equalToConstant: 64)
        filtersViewHeightConstraint.isActive = true
        
        filtersView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        filtersView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        filtersView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        
        filterButtonsStackView.widthAnchor.constraint(equalTo: filtersView.widthAnchor).isActive = true
        filterButtonsStackView.centerXAnchor.constraint(equalTo: filtersView.centerXAnchor).isActive = true
        filterButtonsStackView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        filterButtonsStackView.topAnchor.constraint(equalTo: filtersView.topAnchor).isActive = true
        filterButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        filterByGenderButton.widthAnchor.constraint(equalTo: filterButtonsStackView.widthAnchor, multiplier: 1/3, constant: -1).isActive = true
        filterByGenderButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        filterByGenderButton.centerYAnchor.constraint(equalTo: filterButtonsStackView.centerYAnchor).isActive = true
        filterByGenderButton.translatesAutoresizingMaskIntoConstraints = false
        
        leftSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        leftSeparatorView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        leftSeparatorView.centerYAnchor.constraint(equalTo: filterButtonsStackView.centerYAnchor).isActive = true
        leftSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        filterByAgeRangeSlider.topAnchor.constraint(equalTo: filterButtonsStackView.bottomAnchor).isActive = true
        filterByAgeRangeSlider.heightAnchor.constraint(equalToConstant: 44).isActive = true
        filterByAgeRangeSlider.widthAnchor.constraint(equalTo: filtersView.widthAnchor, constant: -32).isActive = true
        filterByAgeRangeSlider.centerXAnchor.constraint(equalTo: filtersView.centerXAnchor).isActive = true
        filterByAgeRangeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        filterByAgeButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        filterByAgeButton.centerYAnchor.constraint(equalTo: filterButtonsStackView.centerYAnchor).isActive = true
        filterByAgeButton.translatesAutoresizingMaskIntoConstraints = false
        
        rightSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        rightSeparatorView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        rightSeparatorView.centerYAnchor.constraint(equalTo: filterButtonsStackView.centerYAnchor).isActive = true
        rightSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        filterByCountryButton.widthAnchor.constraint(equalTo: filterButtonsStackView.widthAnchor, multiplier: 1/3, constant: -1).isActive = true
        filterByCountryButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        filterByCountryButton.centerYAnchor.constraint(equalTo: filterButtonsStackView.centerYAnchor).isActive = true
        filterByCountryButton.translatesAutoresizingMaskIntoConstraints = false
        
        photosCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        photosCollectionView.topAnchor.constraint(equalTo: filtersView.bottomAnchor).isActive = true
        photosCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photosCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func updateLayout() {
        prepareCollectionViewCellSizes()
        photosCollectionView.reloadData()
        filterByAgeRangeSlider.updateLayerFrames()
    }
    
    private func setupRoundedCorners() {
        if viewModel.isIPad {
            filtersView.layer.cornerRadius = 8
            filtersView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            navigationController?.navigationBar.layer.cornerRadius = 8
            navigationController?.navigationBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            navigationController?.navigationBar.clipsToBounds = true
        }
    }
    
    private func prepareCollectionViewCellSizes() {
        
        let columnsCount = photosCollectionViewLayout.columnsCount
        let cellWidth = (photosCollectionView.bounds.width - (CGFloat(columnsCount - 1) * photosCollectionViewLayout.cellsPadding.horizontal)) / CGFloat(columnsCount)
        
        photosCollectionViewCellSizes.removeAll()

        photosCollectionViewProvider.filteredItems.forEach { item in
            guard let image = item.image else { return }
            let height = cellWidth / image.size.width * image.size.height
            photosCollectionViewCellSizes.append(CGSize(width: cellWidth, height: height))
        }
    }
    
    private func updateCollectionView() {
        prepareCollectionViewCellSizes()
        if let difference = photosCollectionViewProvider.difference, !difference.isEmpty {
            photosCollectionView.performBatchUpdates {
                for change in difference {
                    switch change {
                    case .remove(let offset, _, _):
                        self.photosCollectionView.deleteItems(at: [IndexPath(item: offset, section: .zero)])
                    case .insert(let offset, _, _):
                        self.photosCollectionView.insertItems(at: [IndexPath(item: offset, section: .zero)])
                    }
                }
            }
        }
    }
    
    // MARK: - @objc methods

    @objc func filterByAgeButtonTapped() {
        filterByAgeButton.setTitleColor(UIColor.appColor(isFilterByAgeRangeSliderShown ? .mainBlue : .separatorGray), for: .normal)
        
        view.layoutIfNeeded()
        filtersViewHeightConstraint.constant = isFilterByAgeRangeSliderShown ? 64 : 108
        view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
        }
        
        isFilterByAgeRangeSliderShown.toggle()
    }
    
    @objc func filterByGenderButtonTapped() {
        
        viewModel.selectedGender = viewModel.selectedGender.next
        
        filterByGenderButton.setImage(viewModel.selectedGender.image, for: .normal)
        filterByGenderButton.setImage(viewModel.selectedGender.image, for: .highlighted)
        filterByGenderButton.setTitle(viewModel.selectedGender.rawValue, for: .normal)
        
        photosCollectionViewProvider.filter(by: viewModel.selectedGender)
        updateCollectionView()
    }

    @objc func rangeSliderValueChanged() {
        
        filterByAgeButton.setTitle(viewModel.getFormattedAgeRangeString(fromAge: filterByAgeRangeSlider.lowerValueInt,
                                                                        toAge: filterByAgeRangeSlider.upperValueInt), for: .normal)
        
        photosCollectionViewProvider.filterByAge(from: filterByAgeRangeSlider.lowerValueInt, 
                                                 to: filterByAgeRangeSlider.upperValueInt)
        updateCollectionView()
    }
    
}

// MARK: - LayoutDelegate

extension PhotosViewController: LayoutDelegate {
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return photosCollectionViewCellSizes[indexPath.row]
    }
    
}
