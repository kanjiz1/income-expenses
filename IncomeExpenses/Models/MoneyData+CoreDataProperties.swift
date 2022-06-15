//
//  MoneyData+CoreDataProperties.swift
//  IncomeExpenses
//
//  Created by Oforkanji Odekpe on 6/15/22.
//
//

import Foundation
import CoreData


extension MoneyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoneyData> {
        return NSFetchRequest<MoneyData>(entityName: "MoneyData")
    }

    @NSManaged public var descriptionData: String?
    @NSManaged public var amount: Double
    @NSManaged public var type: String?
    @NSManaged public var section: MoneySection?
    
    public enum DataType: String {
        case income
        case expense
    }
    
    public var dataType: DataType? {
        guard let type = type else { return nil }
            
        return DataType(rawValue: type)
    }
}

extension MoneyData : Identifiable {

}
