//
//  Card+CoreDataClass.swift
//  Сard storage U.bars
//
//  Created by Ruslan Kasian on 20.05.2021.
//
//

import Foundation
import CoreData

public class Card: NSManagedObject {
  // MARK: - Initialization
  
  convenience init() {
      self.init(entity: CoreDataManager.sharedInstance.entityForName("Card"), insertInto: CoreDataManager.sharedInstance.persistentContainer.viewContext)
  }
  
  // MARK: - Methods
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
      return NSFetchRequest<Card>(entityName: "Card")
  }
}
