//
//  Card+CoreDataProperties.swift
//  Сard storage U.bars
//
//  Created by Ruslan Kasian on 20.05.2021.
//
//

import Foundation
import CoreData

extension Card {
    @NSManaged public var bankName: String?
    @NSManaged public var cardNumber: String?
    @NSManaged public var cardIsVisa: Bool
    @NSManaged public var createDate: Date?
}
