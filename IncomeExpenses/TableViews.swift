//
//  TableViews.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/16/22.
//

import UIKit

final class MyCell: UITableViewCell {
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 5.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 5.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -5.0),
            
            amountLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -5.0),
            amountLabel.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 5.0)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(description: String, amount: String? = nil) {
        descriptionLabel.text = description
        
        if let amount = amount {
            amountLabel.text = amount
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        amountLabel.text = ""
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        "\(Self.self)"
    }
}
