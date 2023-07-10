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
    func showAlert(withTitle title: String, message: String, buttonTitle: String, handler: @escaping () -> Void)
}

class CharacterLocationDetailViewController: UIViewController, CharacterLocationDetailView {
    
    private var presenter: CharacterLocationDetailPresenting
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let dimensionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private var alertController = UIAlertController()
    
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
        
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(dimensionLabel)
        
        presenter.viewDidLoad()
    }
    
    func update(with detail: LocationDetail) {
        nameLabel.text = detail.name
        typeLabel.text = detail.type.isEmpty ? nil: "\nType: \(detail.type)"
        dimensionLabel.text = detail.dimension.isEmpty ?  nil : "Dimension: \(detail.dimension)"
    }
    
    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func showAlert(withTitle title: String, message: String, buttonTitle: String, handler: @escaping () -> Void) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: { [weak self] _ in
            handler()
            self?.alertController.dismiss(animated: true)
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
