//
//  PinEntryCell.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class PinEntryCell: UITableViewCell {
    @IBOutlet weak var pinStackView: UIStackView!
    var pin: [String] = ["", "", "", ""] {
           didSet {
               updatePinFields()
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupPinFields()
    }
    private func setupPinFields() {
        pinStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 0..<4 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)

            // Add the label to the stack view
            pinStackView.addArrangedSubview(label)

            // Create an underline view
            let underlineView = UIView()
            underlineView.backgroundColor = UIColor.lightGray // Set the underline color
            underlineView.translatesAutoresizingMaskIntoConstraints = false
            label.addSubview(underlineView)

            // Set constraints for the underline view to position it below the label
            NSLayoutConstraint.activate([
                underlineView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                underlineView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                underlineView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2), // Adjust spacing
                underlineView.heightAnchor.constraint(equalToConstant: 2) // Set height for the underline
            ])

            // Set the width and height of the label itself
            label.widthAnchor.constraint(equalToConstant: 40).isActive = true
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
        }
    }
    
    private func updatePinFields() {
        for (index, view) in pinStackView.arrangedSubviews.enumerated() {
            if let label = view as? UILabel {
                label.text = pin.indices.contains(index) ? pin[index] : ""
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
