//
//  MainViewModel.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//

import Foundation
import Combine

final class MainViewModel {
    
    let subscriptions = Set<AnyCancellable>()
    
    struct Input {
        let refresh: PassthroughSubject<Void, Never>
    }
    
    func bind() {
        
    }
}
