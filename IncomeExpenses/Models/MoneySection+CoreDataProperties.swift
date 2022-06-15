//
//  MoneySection+CoreDataProperties.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//
//

import Foundation
import CoreData


extension MoneySection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoneySection> {
        return NSFetchRequest<MoneySection>(entityName: "MoneySection")
    }

    @NSManaged public var date: Date?
    @NSManaged public var data: NSOrderedSet?
    
    public var moneyData: [MoneyData] {
        data?.array as? [MoneyData] ?? []
    }
    
    public var totalIncome: Double {
        moneyData.filter { $0.dataType == .income }
            .map { $0.amount }
            .reduce(0.0, +)
    }
    
    public var totalExpenses: Double {
        moneyData.filter { $0.dataType == .expense }
            .map { $0.amount }
            .reduce(0.0, +)
    }
}

extension MoneySection : Identifiable, Comparable {
    public static func < (lhs: MoneySection, rhs: MoneySection) -> Bool {
        guard let lhsDate = lhs.date, let rhsDate = rhs.date else {
            return false
        }
        
        return lhsDate < rhsDate
    }
}

// MARK: Generated accessors for data
extension MoneySection {

    @objc(insertObject:inDataAtIndex:)
    @NSManaged public func insertIntoData(_ value: MoneyData, at idx: Int)

    @objc(removeObjectFromDataAtIndex:)
    @NSManaged public func removeFromData(at idx: Int)

    @objc(insertData:atIndexes:)
    @NSManaged public func insertIntoData(_ values: [MoneyData], at indexes: NSIndexSet)

    @objc(removeDataAtIndexes:)
    @NSManaged public func removeFromData(at indexes: NSIndexSet)

    @objc(replaceObjectInDataAtIndex:withObject:)
    @NSManaged public func replaceData(at idx: Int, with value: MoneyData)

    @objc(replaceDataAtIndexes:withData:)
    @NSManaged public func replaceData(at indexes: NSIndexSet, with values: [MoneyData])

    @objc(addDataObject:)
    @NSManaged public func addToData(_ value: MoneyData)

    @objc(removeDataObject:)
    @NSManaged public func removeFromData(_ value: MoneyData)

    @objc(addData:)
    @NSManaged public func addToData(_ values: NSOrderedSet)

    @objc(removeData:)
    @NSManaged public func removeFromData(_ values: NSOrderedSet)

}
