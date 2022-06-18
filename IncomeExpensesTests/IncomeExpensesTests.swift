//
//  IncomeExpensesTests.swift
//  IncomeExpensesTests
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import XCTest
import CoreData
import Combine
@testable import IncomeExpenses

final class IncomeExpensesTests: XCTestCase {
    private let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
    private var subscriptions = Set<AnyCancellable>()
    
    private var data1: MoneyData?
    private var data2: MoneyData?
    private var data3: MoneyData?
    private var section: MoneySection?
    
    override func setUp() {
        super.setUp()
        
        section = MoneySection(context: context)
        section?.date = Date()
        
        data1 = MoneyData(context: context)
        data1?.amount = 10.0
        data1?.type = MoneyData.DataType.expense.rawValue
        data1?.descriptionData = "Coffee"
        data1?.section = section
        
        data2 = MoneyData(context: context)
        data2?.amount = 10000.0
        data2?.type = MoneyData.DataType.income.rawValue
        data2?.descriptionData = "Salary"
        data2?.section = section
        
        data3 = MoneyData(context: context)
        data3?.amount = 2375.0
        data3?.type = MoneyData.DataType.expense.rawValue
        data3?.descriptionData = "Rent"
        data3?.section = section
        
        try! context.saveIfNeeded()
    }
    
    func testViewModel() {
        let exp = expectation(description: "Got data")
        let viewModel = MainViewModel(viewContext: context)
        let refresh = PassthroughSubject<Void, Never>()
        
        viewModel.bind(input: MainViewModel.Input(refresh: refresh))
        viewModel.$data.sink { data in
            if !data.snapshot.itemIdentifiers.isEmpty {
                XCTAssert(data.snapshot.numberOfSections == 1)
                XCTAssert(data.snapshot.numberOfItems == 4)
                exp.fulfill()
            }
        }
        .store(in: &subscriptions)
        
        refresh.send(())
        waitForExpectations(timeout: 2.0)
    }
}
