//
//  MainTableCell.swift
//  Fetch Rewards Coding Challenge
//
//  Created by Jonathan Beebout on 1/10/20.
//  Copyright © 2020 Jonathan Beebout. All rights reserved.
//
import UIKit

class MainTableViewCell: UITableViewCell {
  // MARK: - Outlets

  @IBOutlet weak var nameLabel: UILabel!
  
  // Called when cell is created
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // Called when cell is selected
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
