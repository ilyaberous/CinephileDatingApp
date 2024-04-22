//
//  ViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 06.04.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var verticalStack = HomeVerticalStackView(frame: .zero, superview: view)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(verticalStack)
    }



}

