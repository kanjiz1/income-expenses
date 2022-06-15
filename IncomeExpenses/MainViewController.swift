//
//  MainViewController.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func didTapAdd(type: String, description: String, amount: Double)
}

final class MainViewController: UIViewController {
    
    let viewModel: MainViewModel
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundView?.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 50.0),
            addButton.widthAnchor.constraint(equalToConstant: 50.0),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func didTapAddButton() {
        if view.subviews.contains(where: { $0 is AddTransactionView }) {
            return
        }
        
        let addView = AddTransactionView()
        
        addView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addView)
        
        NSLayoutConstraint.activate([
            addView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.bringSubviewToFront(addView)
    }
}

extension MainViewController: MainViewControllerProtocol {
    func didTapAdd(type: String, description: String, amount: Double) {
        
    }
}
