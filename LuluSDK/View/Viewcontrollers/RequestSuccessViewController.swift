//
//  RequestSuccessViewController.swift
//  Sample
//
//  Created by Swathiga on 24/01/25.
//

import UIKit

class RequestSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // Main Container
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemBlue
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Success Icon
        let successIcon = UIImageView()
        successIcon.image = UIImage(systemName: "checkmark.circle.fill") // Use SF Symbol
        successIcon.tintColor = UIColor.systemGreen
        successIcon.contentMode = .scaleAspectFit
        successIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(successIcon)

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Request Successful"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Subtitle Label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Card created successfully"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)

        // Go to Cards Button
        let cardsButton = UIButton(type: .system)
        cardsButton.setTitle("Go to Cards", for: .normal)
        cardsButton.setTitleColor(.systemBlue, for: .normal)
        cardsButton.backgroundColor = .white
        cardsButton.layer.cornerRadius = 8
        cardsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cardsButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cardsButton)
        cardsButton.addTarget(self, action: #selector(goToCardsTapped), for: .touchUpInside)

        // Go Home Button
        let homeButton = UIButton(type: .system)
        homeButton.setTitle("Go Home", for: .normal)
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.backgroundColor = UIColor.systemBlue
        homeButton.layer.cornerRadius = 8
        homeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeButton)
        homeButton.addTarget(self, action: #selector(goHomeTapped), for: .touchUpInside)

        // Constraints
        NSLayoutConstraint.activate([
            // Container View
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalToConstant: 250),

            // Success Icon
            successIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            successIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            successIcon.widthAnchor.constraint(equalToConstant: 60),
            successIcon.heightAnchor.constraint(equalToConstant: 60),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: successIcon.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Go to Cards Button
            cardsButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            cardsButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cardsButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            cardsButton.heightAnchor.constraint(equalToConstant: 40),

            // Go Home Button at Bottom
            homeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            homeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Button Actions
    @objc private func goToCardsTapped() {
        print("Go to Cards tapped")
        if let targetViewController = navigationController?.viewControllers.first(where: { $0 is CardsMangementViewController }) {
            navigationController?.popToViewController(targetViewController, animated: true)
        }
    }

    @objc private func goHomeTapped() {
        print("Go Home tapped")
//        if let targetViewController = navigationController?.viewControllers.first(where: { $0 is CardsMangementViewController }) {
//            navigationController?.popToViewController(targetViewController, animated: true)
//        }   
        // Access the parent UITabBarController
        if let tabBarController = self.tabBarController {
            // Switch to Tab 0
            tabBarController.selectedIndex = 0
        }

    }

    

}
