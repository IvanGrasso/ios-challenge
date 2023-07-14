//
//  ResultCollectionViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation
import UIKit

protocol CharacterCollectionViewControllerDelegate: AnyObject {
    func didScrollToLastItem()
    func didSelect(_ item: Character)
    func didMarkAsFavorite(_ item: Character)
}

class ResultCollectionViewController: UITableViewController {
    
    weak var delegate: CharacterCollectionViewControllerDelegate?
    
    var items = [Character]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var showsActivityFooter = false {
        didSet {
            tableView.tableFooterView = showsActivityFooter ? activityFooterView : nil
        }
    }
    
    private lazy var activityFooterView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 64)
        spinner.startAnimating()
        return spinner
    }()
    
    private let imageCache: ImageCache
    
    init(imageCache: ImageCache = ImageCache()) {
        self.imageCache = imageCache
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseIdentifier)
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as? CharacterCell else {
            assertionFailure("Failed to load cell")
            return UITableViewCell()
        }
        let character = items[indexPath.row]
        cell.configure(with: character, imageCache: imageCache)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            delegate?.didScrollToLastItem()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelect(item)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favorite") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let item = self.items[indexPath.row]
            self.delegate?.didMarkAsFavorite(item)
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
}
