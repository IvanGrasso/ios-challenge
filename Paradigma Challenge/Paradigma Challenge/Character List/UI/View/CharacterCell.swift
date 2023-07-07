//
//  CharacterCell.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation
import UIKit

final class CharacterCell: UITableViewCell {
    
    var character: Character? {
        didSet {
            updateLayout()
        }
    }
    
    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        return stack
    }()
    
    private var labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private var portraitImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 95).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.2).isActive = true
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var originTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    private var originLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
        mainStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 4).isActive = true
        let bottomConstraint = mainStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -4)
        bottomConstraint.isActive = true
        bottomConstraint.priority = .defaultHigh
        
        mainStackView.addArrangedSubview(portraitImageView)
        
        mainStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        labelStackView.addArrangedSubview(UIView())
        labelStackView.addArrangedSubview(originTitleLabel)
        labelStackView.addArrangedSubview(originLabel)
    }
    
    private func updateLayout() {
        guard let character = character else { return }
        portraitImageView.image = UIImage(named: "image-placeholder")
        titleLabel.text = character.name
        
        let statusIndicator = character.status == "Alive" ? "🟢" : "🔴"
        let subtitle = "\(statusIndicator) \(character.status) - \(character.species)"
        subtitleLabel.text = subtitle
        
        originTitleLabel.text = "First seen in:"
        originLabel.text = "\(character.origin?.name ?? "Unknown")"
        ImageCache.shared.loadImage(with: character.image) { [weak self] image in
            self?.portraitImageView.image = image
        }
    }
}
