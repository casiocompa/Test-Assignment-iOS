//
//  CardsListViewController.swift
//  Сard storage U.bars
//
//  Created by Ruslan Kasian on 20.05.2021.
//

import UIKit
import CoreData

class CardsListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
  // MARK: - Properties
  private var navigationBarTitle: String = "Картки"
  lazy var addItem: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItemPressed))
  }()
  
  var fetchedResultsController = CoreDataManager.sharedInstance.fetchedResultsController("Card", keyForSort: "createDate", ascending: false)
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    let nib = UINib(nibName: "CardListCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "CardListCell")
    
    fetchedResultsController.delegate = self
    do {
      try fetchedResultsController.performFetch()
    } catch {print(error)}
  }
  
  private func setupView() {
    title = navigationBarTitle
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItems = [addItem]
  }
  
  // MARK: - Actions
  func random(digits:Int) -> String {
    var number = String()
    for _ in 1...digits {
      number += "\(Int.random(in: 1...9))"
    }
    return number
  }
  
  @objc private func addButtonItemPressed() {
    let cardNumberRandom = random(digits: 16)
    let bank = "Bank"
    addCard(bank: bank, cardNumber: cardNumberRandom, cardIsVisa: Bool.random()) {_ in }
  }

  func addCard (bank: String, cardNumber: String, cardIsVisa: Bool, completion: (_ complete: Bool) -> ()) {
    let context = fetchedResultsController.managedObjectContext
    // Creating object
    let card = Card(context: context)
    card.bankName = bank
    card.cardIsVisa = cardIsVisa
    card.cardNumber = cardNumber
    card.createDate = Date()
    do {
      CoreDataManager.sharedInstance.saveContext()
      completion(true)
      print("successfully saved person in core data")
    } catch {
      print("Could not save. \(error.localizedDescription)")
      completion(false)
    }
    
  }
    
  // MARK: - TableView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      return sections[section].numberOfObjects
    } else {
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as! CardListCell
    let card = fetchedResultsController.object(at: indexPath) as! Card
    cell.cardtitle = card.cardNumber
    cell.cardType = card.cardIsVisa
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      let storyboard = UIStoryboard(name: "CardsList", bundle: .main)
      let cardInfoVC = storyboard.instantiateViewController(withIdentifier: "CardInfoVC") as! CardInfoViewController
      let currentCard = fetchedResultsController.object(at: indexPath) as! Card
      cardInfoVC.currentCard =  currentCard
      navigationController?.pushViewController(cardInfoVC, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
      CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(managedObject)
      CoreDataManager.sharedInstance.saveContext()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  // MARK: - Fetched Results Controller Delegate
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    switch type {
    case .insert:
      if let indexPath = newIndexPath {
        tableView.insertRows(at: [indexPath], with: .automatic)
      }
    case .update:
      if let indexPath = indexPath {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as! CardListCell
        let card = fetchedResultsController.object(at: indexPath) as! Card
        
        cell.cardtitle = card.cardNumber
        cell.cardType = card.cardIsVisa
        
      }
      tableView.reloadData()
    case .move:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
      if let newIndexPath = newIndexPath {
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
    case .delete:
      if let indexPath = indexPath {
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}
