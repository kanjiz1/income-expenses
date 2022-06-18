//
//  MainViewModel.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import Combine
import UIKit
import CoreData

final class MainViewModel {
    
    typealias Section = MainViewController.Section
    typealias Item = MainViewController.Item
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let viewContext: NSManagedObjectContext? = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext
    
    private var subscriptions = Set<AnyCancellable>()
    @Published private(set) var data = (snapshot: Snapshot(), header: HeaderData(expenses: 0.0, income: 0.0, balance: 0.0))
    
    struct HeaderData: Hashable {
        let expenses: Double
        let income: Double
        let balance: Double
    }
    
    struct Input {
        let refresh: PassthroughSubject<Void, Never>
    }
    
    func bind(input: Input) {
        let request = input.refresh
            .flatMap { [unowned self] _ in
                self.fetchData()
            }
            .share()
        
        request.sink { [weak self] result in
            guard let self = self else { return }
            
            var snapshot = Snapshot()
            let header: HeaderData
            var totalIncome: Double = 0.0
            var totalExpenses: Double = 0.0
            
            let sections = result.compactMap { $0.section }
                .compactMap { section -> Date? in
                    totalIncome += section.totalIncome
                    totalExpenses += section.totalExpenses
                    return section.date
                }
            
            sections
                .forEach {
                    snapshot.appendSections([.section(date: $0)])
                }
            
            result.forEach { data in
                snapshot.appendItems([.item(transaction: data)], toSection: .section(date: sections.first(where: { $0 == data.section?.date })!))
            }
            
            header = HeaderData(expenses: totalExpenses, income: totalIncome, balance: (totalIncome - totalExpenses))
            self.data = (snapshot: snapshot, header: header)
        }
        .store(in: &subscriptions)
    }
    
    func fetchData() -> AnyPublisher<[MoneyData], Never> {
        Deferred {
            Future { [weak self] promise in
                
                guard let self = self, let viewContext = self.viewContext else { return }
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoneyData") // "MoneySection"
                
                do {
                    let results = try viewContext.fetch(request)
                    let moneyData = results as! [MoneyData]
                    promise(.success(moneyData))
                    
                } catch let err as NSError {
                    promise(.success([]))
                    print(err.debugDescription)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addItem(type: String, description: String, amount: Double) {
        guard let viewContext = viewContext else {
            return
        }
        
        let section = MoneySection(context: viewContext)
        section.date = Date()
        
        let moneyData = MoneyData(context: viewContext)
        moneyData.amount = amount
        moneyData.descriptionData = description
        moneyData.type = type
        moneyData.section = section
        
        do {
            try viewContext.save()
        } catch {
            print("Storing data Failed")
        }
    }
    
    func delete(item: MoneyData) {
        guard let viewContext = viewContext else {
            return
        }
        
        viewContext.delete(item)
    }
}
