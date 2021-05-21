//
//  CardListCell.swift
//  Сard storage U.bars
//
//  Created by Ruslan Kasian on 20.05.2021.
//


import UIKit

class CardListCell: UITableViewCell {
  // MARK: - Outlets
  @IBOutlet private weak var cardTypeImage: UIImageView!
  @IBOutlet private weak var cardName: UILabel!
  
// MARK: - Properties
  var cardtitle: String? {
      get { return cardName.text }
      set { cardName.text = newValue != nil ? "**** **** **** " + String(newValue!.suffix(4)) : "" }
  }
  
  var cardType: Bool = false {
    didSet {cardTypeImage.image = UIImage(named: cardType ? "visa" : "mastercard")}
  }

}
