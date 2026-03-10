//
//  OptionCell.swift
//  appnavigation
//
//  Created by MACM72 on 25/02/26.
//

import UIKit

class OptionCell: UITableViewCell {

    @IBOutlet weak var optionText: UILabel!
    @IBOutlet weak var successImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
