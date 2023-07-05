//
//  CharacterListViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation
import UIKit

protocol CharacterListView: AnyObject {
    func update(with viewData: CharacterListViewData)
    func showActivityIndicator()
    func hideActivityIndicator()
    func showErrorMessage(_ message: String)
}

struct CharacterListViewData {
    let sectionTitles: [String]
    let selectedSectionIndex: Int
    let items: [Character]
}

final class CharacterListViewController: UIViewController, CharacterListView {
    
    private var presenter: CharacterListPresenting
    
    private let segmentedControl = UISegmentedControl()
    private var collectionViewControllers = [CharacterCollectionViewController]()
    private var selectedCollectionViewController: CharacterCollectionViewController?
    
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
        presenter.viewDidLoad()
        view.backgroundColor = UIColor.purple
    }
    
    func update(with viewData: CharacterListViewData) {
        segmentedControl.removeAllSegments()
        viewData.sectionTitles.enumerated().forEach { index, sectionTitle in
            let handler: UIActionHandler = { [weak self] action in
                guard let selectedSectionIndex = self?.segmentedControl.selectedSegmentIndex else { return }
                self?.presenter.didSelect(sectionWithIndex: selectedSectionIndex)
            }
            let action = UIAction(title: sectionTitle, handler: handler)
            segmentedControl.insertSegment(action: action, at: index, animated: false)
            
            let collectionViewController = CharacterCollectionViewController(collectionViewLayout: UICollectionViewLayout())
            collectionViewControllers.append(collectionViewController)
            addChild(collectionViewController)
            collectionViewController.didMove(toParent: self)
            collectionViewController.delegate = self
        }
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = viewData.selectedSectionIndex
        let selectedViewController = collectionViewControllers[segmentedControl.selectedSegmentIndex]
        show(selectedViewController)
        selectedViewController.items = viewData.items
    }
    
    private func show(_ collectionViewController: CharacterCollectionViewController) {
        selectedCollectionViewController?.view.removeFromSuperview()
        view.addSubview(collectionViewController.view)
        collectionViewController.view.pinToSuperview()
        selectedCollectionViewController = collectionViewController
    }
    
    func showActivityIndicator() {
        
    }
    
    func hideActivityIndicator() {
        
    }
    
    func showErrorMessage(_ message: String) {
        
    }
}

extension CharacterListViewController: CharacterCollectionViewControllerDelegate {
    func didSelect(_ item: Character) {
        
    }
}
