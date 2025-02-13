//
//  CustomHeaderView.swift
//  Sample
//
//  Created by Swathiga on 20/01/25.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var viewMain:UIView!
    @IBOutlet var btnBack:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.backgroundColor = UIColor(named: "customCyanColor")
    }

}
