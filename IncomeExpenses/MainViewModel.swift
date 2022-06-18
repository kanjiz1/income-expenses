//
//  MainViewModel.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import Combine
import UIKit

final class MainViewModel {
    
    typealias Section = MainViewController.Section
    typealias Item = MainViewController.Item
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let subscriptions = Set<AnyCancellable>()
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
        
    }
    
    func delete(item: MoneyData) {
        
    }
}
