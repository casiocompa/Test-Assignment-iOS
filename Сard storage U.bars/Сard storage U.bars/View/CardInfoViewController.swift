//
//  CardInfoViewController.swift
//  Сard storage U.bars
//
//  Created by Ruslan Kasian on 21.05.2021.
//

import UIKit


class CardInfoViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var cardBGOutlet: UIView!{
    didSet {
      cardBGOutlet.layer.cornerRadius = 16
      cardBGOutlet.layer.masksToBounds = true
    }
  }
  
  @IBOutlet  private weak var cardTypeImage: UIImageView!
  @IBOutlet private weak var bankNameOutlet: UILabel!
  @IBOutlet private weak var cardNumberOutlet: UILabel!
  
  // MARK: - Properties
  var currentCard : Card?
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let currentCard = currentCard {
      bankNameOutlet.text = currentCard.bankName
      cardTypeImage.image = UIImage(named: currentCard.cardIsVisa ? "visa" : "mastercard")
      cardBGOutlet.backgroundColor = UIColor(named: currentCard.cardIsVisa ? "visa" : "mastercard")
     
      if let cardNumber = currentCard.cardNumber {
        cardNumberOutlet.text  = "**** " + String(cardNumber.suffix(4))
      }
        
    }
        
  }
}
