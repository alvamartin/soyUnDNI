//
//  dniTableViewCell.swift
//  miDNI
//
//  Created by Álvaro Martín on 08/09/15.
//  Copyright © 2015 Álvaro A. All rights reserved.
//

import UIKit

class dniTableViewCell: UITableViewCell {

    @IBOutlet var nifLabel: UILabel!
    @IBOutlet var fechaCreacionLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
