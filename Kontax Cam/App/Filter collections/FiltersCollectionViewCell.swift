//
//  FiltersCollectionViewCell.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 28/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import SDWebImage

class FiltersCollectionViewCell: UICollectionViewCell {
    
    static let ReuseIdentifier = "filtersCell"
    
    private struct Constants {
        static let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        imageView.sd_imageTransition = .fade
        return imageView
    }()
    private let collectionNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let infoButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = UIColor.label
        return button
    }()
    private let nameLabelView: UIView = {
        let view = UIView()
        return view
    }()
    private let lockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = IconHelper.shared.getIconImage(iconName: "lock.fill")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    private var nameStackView: UIStackView! // Stackview of collection name and lock icon
    private var mStackView: UIStackView! // Stackview of imageView and nameLabelView
    
    var buttonTapped: (() -> Void)?
    var filterCollection: FilterCollection! {
        didSet {
            collectionNameLabel.text = filterCollection.name
            imageView.sd_setImage(with: URL(string: filterCollection.imageURL)!, placeholderImage: UIImage(named: "collection-placeholder"), options: .scaleDownLargeImages)
        }
    }
    var isLocked = true {
        didSet {
            collectionNameLabel.textColor = isLocked ? .secondaryLabel : .label
            lockImageView.isHidden = !isLocked
        }
    }
    
    // Perform a custom selection state so that we can customise its behaviour
    var isCellSelected: Bool = false {
        didSet {
            layer.borderWidth = isCellSelected ? 2 : 0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
        layer.borderColor = UIColor.label.cgColor
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    private func setupView() {
        nameStackView = UIStackView(arrangedSubviews: [collectionNameLabel, lockImageView])
        nameStackView.spacing = 10
        
        nameLabelView.addSubview(nameStackView)
        nameLabelView.addSubview(infoButton)
        
        mStackView = UIStackView(arrangedSubviews: [imageView, nameLabelView])
        mStackView.axis = .vertical
        mStackView.spacing = 10
        
        addSubview(mStackView)
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(self.bounds.height * 0.75)
        }
        
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        
        nameStackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.label.cgColor
        }
    }
    
    @objc private func infoButtonTapped() {
        if let buttonAction = buttonTapped {
            buttonAction()
        }
    }

}
