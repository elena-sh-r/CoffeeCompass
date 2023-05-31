//
//  RatingControl.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 30.05.2023.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Public Properties
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
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
    override init(frame: CGRect) { // programmatically
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) { // Interface Builder
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: - Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        rating = (selectedRating == rating)
            ? 0
            : selectedRating
    }
    
    // MARK: - Private Methods
    private func setupButtons() {
        ratingButtons.forEach { button in
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Load button image
        let bundle = Bundle(for: type(of: self)) // определяет местоположение ресурсов, которые хранятся в ассетст
        
        let filledStar = UIImage(
            named: "filledStar",
            in: bundle,
            compatibleWith: self.traitCollection
        )
        
        let emptyStar = UIImage(
            named: "emptyStar",
            in: bundle,
            compatibleWith: self.traitCollection
        )
        
        let highlightedStar = UIImage(
            named: "highlightedStar",
            in: bundle,
            compatibleWith: self.traitCollection
        )
        
        
        for _ in 0..<starCount {
            // Create button
            let button = UIButton()
            
            // Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
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
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected  = index < rating
        }
    }
}
