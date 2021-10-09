//
//  AnimatedImageTableViewCell.swift
//  memmove
//
//  Created by Cirno MainasuK on 2021-10-9.
//

import UIKit
import SDWebImage

final class AnimatedImageTableViewCell: UITableViewCell {
    
    let primaryLabel = UILabel()
    let animatedImageView = SDAnimatedImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _init()
    }
    
}

extension AnimatedImageTableViewCell {
    
    private func _init() {
        primaryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(primaryLabel)
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            primaryLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            primaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        animatedImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animatedImageView)
        NSLayoutConstraint.activate([
            animatedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            animatedImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animatedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            animatedImageView.widthAnchor.constraint(equalToConstant: 50).priority(.required - 1),
            animatedImageView.heightAnchor.constraint(equalToConstant: 50).priority(.required - 1),
        ])
    }
    
}

extension NSLayoutConstraint {
    public func priority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
    
    public func identifier(_ identifier: String?) -> Self {
        self.identifier = identifier
        return self
    }
}
