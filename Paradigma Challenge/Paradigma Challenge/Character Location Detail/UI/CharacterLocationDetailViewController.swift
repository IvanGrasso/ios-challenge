//
//  CharacterLocationDetailViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation
import UIKit

protocol CharacterLocationDetailView: AnyObject {
    func update(with detail: LocationDetail)
    func showActivityIndicator()
    func hideActivityIndicator()
    func showErrorMessage(_ message: String)
}

class CharacterLocationDetailViewController: UIViewController, CharacterLocationDetailView {
    
    private var presenter: CharacterLocationDetailPresenting
    
    private let nameLabel = UILabel()
    
    init(presenter: CharacterLocationDetailPresenting) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        presenter.viewDidLoad()
    }
    
    func update(with detail: LocationDetail) {
        nameLabel.text = detail.name
    }
    
    func showActivityIndicator() {
        
    }
    
    func hideActivityIndicator() {
        
    }
    
    func showErrorMessage(_ message: String) {
        
    }
}
