//
//  MovieThemeCollectionViewCell.swift
//  NoStoryTest
//
//  Created by Nursultan Konspayev on 17.05.2024.
//

import UIKit

class MovieThemeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ThemeCollectionViewCell"
    
    lazy var labelThemeCollectionCell: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIViews()
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - Setup UI Views
    private func setupUIViews() {
        contentView.addSubview(labelThemeCollectionCell)
        labelThemeCollectionCell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelThemeCollectionCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        labelThemeCollectionCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        labelThemeCollectionCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
}
