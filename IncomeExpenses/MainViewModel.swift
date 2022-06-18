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
    
    private let viewContext: NSManagedObjectContext?
    
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
    
    // Added this to be able to inject the context in unit tests.
    init(
        viewContext: NSManagedObjectContext? = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext
    ) {
        self.viewContext = viewContext
    }
    
    func bind(input: Input) {
        subscriptions.forEach { $0.cancel() }
        
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
            
            let sections = result
                .compactMap { data -> MoneySection? in
                    switch data.dataType {
                    case .income:
                        totalIncome += data.amount
                    case .expense:
                        totalExpenses += data.amount
                    default:
                        break
                    }
                    
                    return data.section
                }
                .compactMap { $0.date }
                .sorted(by: { $0 > $1 })
            
            sections
                .forEach { date in
                    if !snapshot.sectionIdentifiers.contains(where: { $0.date.isSameDay(as: date) }) {
                        snapshot.appendSections([.section(date: date)])
                        snapshot.appendItems([.date(date: date)], toSection: .section(date: date))
                    }
                }
            
            result.forEach { data in
                snapshot.appendItems([.item(transaction: data)], toSection: .section(date: sections.first(where: { $0.isSameDay(as: data.section?.date) })!))
            }
            
            header = HeaderData(expenses: totalExpenses.roundToDecimal(2), income: totalIncome.roundToDecimal(2), balance: (totalIncome - totalExpenses).roundToDecimal(2))
            self.data = (snapshot: snapshot, header: header)
        }
        .store(in: &subscriptions)
    }
    
    func fetchData() -> AnyPublisher<[MoneyData], Never> {
        Deferred {
            Future { [weak self] promise in
                
                guard let self = self, let viewContext = self.viewContext else { return }
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MoneyData")
                
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
            try viewContext.saveIfNeeded()
        } catch {
            print("Storing data Failed")
        }
    }
    
    func delete(item: MoneyData, completion: @escaping () -> Void) {
        guard let viewContext = viewContext else {
            return
        }
        
        viewContext.delete(item)
        
        do {
            try viewContext.saveIfNeeded()
        } catch {
            print("Storing data Failed")
        }
        
        completion()
    }
}

extension Date {
    func isSameDay(as date: Date?) -> Bool {
        guard let date = date else {
            return false
        }
        
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}

extension NSManagedObjectContext {

    /// Only performs a save if there are changes to commit.
    /// - Returns: `true` if a save was needed. Otherwise, `false`.
    @discardableResult public func saveIfNeeded() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
