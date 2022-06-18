//
//  HeaderView.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/16/22.
//

import UIKit

final class HeaderView: UIView {
    
    private enum LayoutConstants {
        static let viewWidth: CGFloat = (UIScreen.main.bounds.width - 70) / 3
    }
    
    private lazy var expensesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expensesView: UIStackView = {
        let label = UILabel()
        label.text = "Expenses"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView(arrangedSubviews: [label, expensesLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        
        return stackView
    }()
    
    private lazy var incomeView: UIStackView = {
        let label = UILabel()
        label.text = "Income"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView(arrangedSubviews: [label, incomeLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        
        return stackView
    }()
    
    private lazy var balanceView: UIStackView = {
        let label = UILabel()
        label.text = "Balance"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView(arrangedSubviews: [label, balanceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12.0
        
        return stackView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressViewStyle = .default
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.black.cgColor
        
        let divider1 = Divider()
        divider1.translatesAutoresizingMaskIntoConstraints = false
        let divider2 = Divider()
        divider2.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(expensesView)
        addSubview(incomeView)
        addSubview(balanceView)
        addSubview(progressView)
        addSubview(divider1)
        addSubview(divider2)
        
        NSLayoutConstraint.activate([
            expensesView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 15.0),
            expensesView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 15.0),
            expensesView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.0),
            expensesView.widthAnchor.constraint(equalToConstant: LayoutConstants.viewWidth),
            
            divider1.topAnchor.constraint(equalTo: expensesView.topAnchor),
            divider1.bottomAnchor.constraint(equalTo: expensesView.bottomAnchor),
            divider1.widthAnchor.constraint(equalToConstant: 1.0),
            divider1.leadingAnchor.constraint(equalTo: expensesView.trailingAnchor, constant: 5.0),
            
            incomeView.leadingAnchor.constraint(equalTo: divider1.trailingAnchor, constant: 5.0),
            incomeView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 15.0),
            incomeView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.0),
            incomeView.widthAnchor.constraint(equalToConstant: LayoutConstants.viewWidth),
            
            divider2.topAnchor.constraint(equalTo: incomeView.topAnchor),
            divider2.bottomAnchor.constraint(equalTo: incomeView.bottomAnchor),
            divider2.widthAnchor.constraint(equalToConstant: 1.0),
            divider2.leadingAnchor.constraint(equalTo: incomeView.trailingAnchor, constant: 5.0),
            
            balanceView.leadingAnchor.constraint(equalTo: divider2.trailingAnchor, constant: 5.0),
            balanceView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 15.0),
            balanceView.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.0),
            balanceView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -15.0),
            balanceView.widthAnchor.constraint(equalToConstant: LayoutConstants.viewWidth),
            
            progressView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -15.0),
            progressView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 15.0),
            progressView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -15.0),
            progressView.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(expenses: Double, income: Double, balance: Double) {
        expensesLabel.text = "$\(expenses)"
        incomeLabel.text = "$\(income)"
        balanceLabel.text = balance > 0 ? "$\(balance)" : "-$\(balance)"
        
        progressView.progress = Float(expenses / income)
        
        layoutIfNeeded()
    }
    
    final class Divider: UIView {
        init() {
            super.init(frame: .zero)
            backgroundColor = .black
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
