//
//  SegmentedBarView.swift
//  CinephileDatingApp
//
//  Created by Ilya on 25.04.2024.
//

import UIKit

class SegmentedBarView: UIStackView {
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = Constants.Colors.barDeselect
            addArrangedSubview(barView)
        }
        
        spacing = 4
        distribution = .fillEqually
        
        arrangedSubviews.first?.backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setHighlighted(index: Int) {
       arrangedSubviews.forEach({ $0.backgroundColor = Constants.Colors.barDeselect })
       arrangedSubviews[index].backgroundColor = .white
    }
}
