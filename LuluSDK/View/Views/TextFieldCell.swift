//
//  TextFieldCell.swift
//  LuluSDK
//
//  Created by Swathiga on 04/02/25.
//

import UIKit

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var txtFieldAmount:UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        txtFieldAmount.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
