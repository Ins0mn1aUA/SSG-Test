//
//  PhotoCollectionViewCell.swift
//  SSG
//
//  Created by Григорий Стеценко on 01.12.2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlets
    
    private var photoImageView: UIImageView!

    // MARK: - Public properties
    
//    public var photoModel: PhotoModel? {
//        didSet {
//            guard let photoModel = photoModel else { return }
//            setup(with: photoModel)
//        }
//    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photoImageView = UIImageView()
        photoImageView.layer.cornerRadius = 4
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photoImageView)
        
        photoImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    
    public func setup(with photoModel: PhotoModel) {
        photoImageView?.image = photoModel.image
    }

}
