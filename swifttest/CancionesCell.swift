//
//  CancionesCell.swift
//  swifttest
//
//  Created by PEDRO ARMANDO MANFREDI on 30/5/17.
//  Copyright © 2017 Slash Mobility S.L. All rights reserved.
//

import UIKit

class CancionesCell: UITableViewCell {
    
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
