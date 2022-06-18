//
//  MainViewController.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import UIKit
import Combine

protocol MainViewControllerProtocol: AnyObject {
    func didTapAdd(type: String, description: String, amount: Double)
}

final class MainViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    
    private var deletionCompleted: ((MainViewController.Item) -> Void)?
    
    enum Section: Hashable {
        case section(date: Date)
    }
    
    enum Item: Hashable {
        case item(transaction: MoneyData)
        case date(date: Date)
    }
    
    let viewModel: MainViewModel
    var datasource: TableViewDiffableDataSource!
    
    private var subscriptions = Set<AnyCancellable>()
    private let refresh = PassthroughSubject<Void, Never>()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundView?.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(MyCell.self, forCellReuseIdentifier: MyCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.sectionHeaderTopPadding = 15
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
        
        title = "Income Expenses"
        
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        datasource = TableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.reuseIdentifier, for: indexPath) as? MyCell else {
                return nil
            }
            
            switch item {
            case .item(let transaction):
                cell.configure(description: transaction.description, amount: "$\(transaction.amount)")
                
            case .date(let date):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM, y"
                cell.configure(description: dateFormatter.string(from: date))
            }
            
            return cell
        }
        
        deletionCompleted = { [weak self] item in
            switch item {
            case .item(let transaction):
                self?.viewModel.delete(item: transaction)
                break
                
            case .date:
                break
            }
        }
        
        let input = MainViewModel.Input(refresh: refresh)
        viewModel.bind(input: input)
        
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.datasource.apply(data.snapshot)
                self?.headerView.configure(
                    expenses: data.header.expenses,
                    income: data.header.income,
                    balance: data.header.balance
                )
            }
            .store(in: &subscriptions)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50.0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            
            tableView.topAnchor.constraint(equalTo: headerView.layoutMarginsGuide.bottomAnchor, constant: 20.0),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            
            addButton.heightAnchor.constraint(equalToConstant: 50.0),
            addButton.widthAnchor.constraint(equalToConstant: 50.0),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        refresh.send(())
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

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self = self else { return }
            let snapshot = self.datasource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            let item = snapshot.itemIdentifiers(inSection: section)[indexPath.row]
            self.deletionCompleted?(item)
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 0.0
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef: CGMutablePath = CGMutablePath()
        let bounds: CGRect = cell.bounds.insetBy(dx: 8, dy: 0)
        var addLine: Bool = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            
        } else if indexPath.row == 0 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.minY),
                           radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            addLine = true
            
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            
        } else {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            
            pathRef.move(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            addLine = true
        }
        
        layer.path = pathRef
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 1.0
        layer.fillColor = UIColor.clear.cgColor
        
        if addLine == true {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
            lineLayer.backgroundColor = UIColor.clear.cgColor
            layer.addSublayer(lineLayer)
        }
        
        let backgroundView: UIView = UIView(frame: bounds)
        backgroundView.layer.insertSublayer(layer, at: 0)
        backgroundView.backgroundColor = .clear
        cell.backgroundView = backgroundView
    }
}

final class TableViewDiffableDataSource: UITableViewDiffableDataSource<MainViewController.Section, MainViewController.Item> {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.row != 0 else {
            return false
        }
        return true
    }
}
