//
//  NumberPadCell.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit
protocol NumberPadCellDelegate: AnyObject {
    func didTapNumber(_ number: String)
    func didTapBackspace()
}

class NumberPadCell: UITableViewCell {
    // MARK: - Outlets for Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    // MARK: - Delegate
    weak var delegate: NumberPadCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButtons()
    }
    // MARK: - Button Actions
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        delegate?.didTapNumber(number)
    }

    @IBAction func backspaceButtonTapped(_ sender: UIButton) {
        delegate?.didTapBackspace()
    }

    // MARK: - Configuration
    private func configureButtons() {
        // Assign tags to buttons for convenience (optional if titles are used)
        button1.tag = 1
        button2.tag = 2
        button3.tag = 3
        button4.tag = 4
        button5.tag = 5
        button6.tag = 6
        button7.tag = 7
        button8.tag = 8
        button9.tag = 9
        button0.tag = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
