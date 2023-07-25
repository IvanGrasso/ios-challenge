//
//  CharacterListViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation
import UIKit

protocol CharacterListView: AnyObject {
    var viewState: CharacterListViewState { get set }
    func navigateToDetail(withTitle title: String,
                          location: CharacterLocation?)
}

enum CharacterListViewState {
    case loading
    case results(items: [Character],
                 isPagingEnabled: Bool)
    case favorites(items: [Character])
    case resultsError
    case favoritesError
}

final class CharacterListViewController: UIViewController, CharacterListView {
    
    var viewState: CharacterListViewState = .loading {
        didSet {
            updateLayout()
        }
    }
    
    private var presenter: CharacterListPresenting
    
    private let segmentedControl = UISegmentedControl()
    private let imageCache: ImageCache
    private lazy var resultViewController = ResultTableViewController(imageCache: imageCache)
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
        resultViewController.delegate = self
        favoritesViewController.delegate = self
        
        let resultsHandler: UIActionHandler = { [weak self] _ in
            self?.show(self?.resultViewController ?? UIViewController())
            self?.presenter.didSelectResultList()
        }
        let resultsAction = UIAction(title: "Results",
                                     handler: resultsHandler)
        segmentedControl.insertSegment(action: resultsAction,
                                       at: 0,
                                       animated: false)
        
        let favoritesHandler: UIActionHandler = { [weak self] _ in
            self?.show(self?.favoritesViewController ?? UIViewController())
            Task() {
                await self?.presenter.didSelectFavoritesList()
            }
        }
        let favoritesAction = UIAction(title: "Favorites",
                                       handler: favoritesHandler)
        segmentedControl.insertSegment(action: favoritesAction,
                                       at: 1,
                                       animated: false)
        
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
        show(resultViewController)
        
        Task() {
            await presenter.viewDidLoad()
        }
    }
    
    private func show(_ viewController: UIViewController) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.pinToSuperview()
        viewController.didMove(toParent: self)
        currentViewController = viewController
    }
    
    private func updateLayout() {
        switch viewState {
        case .loading:
            showActivityIndicator()
            
        case .results(let items, let isPagingEnabled):
            hideActivityIndicator()
            resultViewController.items = items
            resultViewController.showsActivityFooter = isPagingEnabled
            
        case .favorites(let items):
            hideActivityIndicator()
            favoritesViewController.items = items
            
        case .resultsError:
            hideActivityIndicator()
            showAlert(withTitle: "Something's wrong",
                      message: "There was an error loading your content.\nPlease try again.",
                      buttonTitle: "OK",
                      handler: { [weak self] in
                Task() {
                    await self?.presenter.didRetryLoadingResults()
                }
            })
            
        case .favoritesError:
            hideActivityIndicator()
            showAlert(withTitle: "Something's wrong",
                      message: "There was an error loading your favorites.",
                      buttonTitle: "Retry",
                      handler: { [weak self] in
                Task() {
                    await self?.presenter.didRetryLoadingFavorites()
                }
            })
        }
    }
    
    func navigateToDetail(withTitle title: String,
                          location: CharacterLocation?) {
        let detailPresenter = CharacterLocationDetailPresenter(locationID: location?.id)
        let detailVC = CharacterLocationDetailViewController(presenter: detailPresenter)
        detailVC.title = title
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func showActivityIndicator() {
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
    
    func showAlert(withTitle title: String,
                   message: String,
                   buttonTitle: String,
                   handler: @escaping () -> Void) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: { [weak self] _ in
            handler()
            self?.alertController.dismiss(animated: true)
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension CharacterListViewController: ResultTableViewControllerDelegate {
    
    func didScrollToLastItem() {
        Task() {
            await presenter.didScrollToLastResult()
        }
    }
    
    func didSelect(_ item: Character) {
        presenter.didSelect(item)
    }
    
    func didMarkAsFavorite(_ item: Character) {
        Task() {
            await presenter.didMarkAsFavorite(item)
        }
    }
}

extension CharacterListViewController: FavoritesCollectionViewControllerDelegate {
    
    func didUnmarkAsFavorite(_ item: Character) {
        Task() {
            await presenter.didUnmarkAsFavorite(item)
        }
    }
}
