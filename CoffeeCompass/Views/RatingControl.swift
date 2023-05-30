//
//  RatingControl.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 30.05.2023.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Public Properties
    var rating = 0
    
    // MARK: - Private Properties
    private var ratingButtons = [UIButton]()
    
    @IBInspectable private var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable private var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: - Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button Pressed")
    }
    
    // MARK: - Private Methods
    private func setupButtons() {
        
        ratingButtons.forEach { button in
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        for _ in 0..<starCount {
            // Create button
            let button = UIButton()
            button.backgroundColor = .brown
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped(button: )), for: .touchUpInside)
            
            // Add button to the stack
            addArrangedSubview(button)
            
            // Add new button on the rating button array
            ratingButtons.append(button)
        }
    }
    
}
