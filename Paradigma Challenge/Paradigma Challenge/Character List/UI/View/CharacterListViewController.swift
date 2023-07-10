//
//  CharacterListViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation
import UIKit

protocol CharacterListView: AnyObject {
    func setUp(withListTitles titles: [String])
    func updateResults(with items: [Character], isPagingEnabled: Bool)
    func updateFavorites(with items: [Character])
    func navigateToDetailView(withTitle title: String, location: CharacterLocation?)
    func showActivityIndicator()
    func hideActivityIndicator()
    func showAlert(withTitle title: String, message: String, buttonTitle: String, handler: @escaping () -> Void)
}

final class CharacterListViewController: UIViewController, CharacterListView {
    
    private var presenter: CharacterListPresenting
    
    private let segmentedControl = UISegmentedControl()
    private let imageCache: ImageCache
    private lazy var resultViewController = ResultCollectionViewController(imageCache: imageCache)
    private lazy var favoritesViewController = FavoritesCollectionViewController(imageCache: imageCache)
    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private var currentViewController: UIViewController?
    private var alertController = UIAlertController()
    
    init(presenter: CharacterListPresenting = CharacterListPresenter(),
         imageCache: ImageCache = ImageCache()) {
        self.presenter = presenter
        self.imageCache = imageCache
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(resultViewController)
        resultViewController.delegate = self
        
        addChild(favoritesViewController)
        favoritesViewController.delegate = self
        
        presenter.viewDidLoad()
    }
    
    func setUp(withListTitles titles: [String]) {
        guard !titles.isEmpty else { return }
        segmentedControl.removeAllSegments()
        navigationItem.titleView = segmentedControl
        titles.enumerated().forEach { index, title in
            switch index {
            case 0:
                let handler: UIActionHandler = { [weak self] _ in
                    guard let self = self else { return }
                    self.show(resultViewController)
                    self.presenter.didSelectResultList()
                }
                let action = UIAction(title: title, handler: handler)
                segmentedControl.insertSegment(action: action, at: index, animated: false)
            case 1:
                let handler: UIActionHandler = { [weak self] _ in
                    guard let self = self else { return }
                    self.show(favoritesViewController)
                    self.presenter.didSelectFavoritesList()
                }
                let action = UIAction(title: title, handler: handler)
                segmentedControl.insertSegment(action: action, at: index, animated: false)
            default: break
            }
        }
        
        segmentedControl.selectedSegmentIndex = 0
        presenter.didSelectResultList()
        show(resultViewController)
    }
    
    private func show(_ viewController: UIViewController) {
        currentViewController?.view.removeFromSuperview()
        view.addSubview(viewController.view)
        viewController.view.pinToSuperview()
        currentViewController = viewController
    }
    
    func updateResults(with items: [Character], isPagingEnabled: Bool) {
        resultViewController.items = items
        resultViewController.showsActivityFooter = isPagingEnabled
    }
    
    func updateFavorites(with items: [Character]) {
        favoritesViewController.items = items
    }
    
    func navigateToDetailView(withTitle title: String, location: CharacterLocation?) {
        let detailPresenter = CharacterLocationDetailPresenter(locationID: location?.id)
        let detailVC = CharacterLocationDetailViewController(presenter: detailPresenter)
        detailVC.title = title
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func showActivityIndicator() {
        currentViewController?.view.isHidden = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        currentViewController?.view.isHidden = false
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

extension CharacterListViewController: CharacterCollectionViewControllerDelegate {
    
    func didScrollToLastItem() {
        presenter.didScrollToLastResult()
    }
    
    func didSelect(_ item: Character) {
        presenter.didSelect(item)
    }
    
    func didMarkAsFavorite(_ item: Character) {
        presenter.didMarkAsFavorite(item)
    }
}

extension CharacterListViewController: FavoritesCollectionViewControllerDelegate {
    func didUnmarkAsFavorite(_ item: Character) {
        presenter.didUnmarkAsFavorite(item)
    }
}
