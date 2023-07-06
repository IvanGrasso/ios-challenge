//
//  CharacterListViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation
import UIKit

protocol CharacterListView: AnyObject {
    func setUp(withLists lists: [CharacterList])
    func update(with items: [Character])
    func showActivityIndicator()
    func hideActivityIndicator()
    func showErrorMessage(_ message: String)
}

final class CharacterListViewController: UIViewController, CharacterListView {
    
    private var presenter: CharacterListPresenting
    
    private let segmentedControl = UISegmentedControl()
    private var collectionViewController = CharacterCollectionViewController()
    
    init(presenter: CharacterListPresenting = CharacterListPresenter()) {
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
        
        addChild(collectionViewController)
        collectionViewController.delegate = self
        view.addSubview(collectionViewController.view)
        collectionViewController.view.pinToSuperview()
        
        presenter.viewDidLoad()
    }
    
    func setUp(withLists lists: [CharacterList]) {
        guard !lists.isEmpty else { return }
        segmentedControl.removeAllSegments()
        navigationItem.titleView = segmentedControl
        lists.enumerated().forEach { index, list in
            let handler: UIActionHandler = { [weak self] _ in
                self?.presenter.didSelect(list: list)
            }
            let action = UIAction(title: list.rawValue, handler: handler)
            segmentedControl.insertSegment(action: action, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        presenter.didSelect(list: lists.first!)
    }
    
    func update(with items: [Character]) {
        collectionViewController.items = items
    }
    
    func showActivityIndicator() {
        
    }
    
    func hideActivityIndicator() {
        
    }
    
    func showErrorMessage(_ message: String) {
        
    }
}

extension CharacterListViewController: CharacterCollectionViewControllerDelegate {
    func didScrollToLastItem() {
        presenter.didScrollToLastItem()
    }
    
    func didSelect(_ item: Character) {
        
    }
}
