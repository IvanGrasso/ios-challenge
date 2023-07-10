//
//  FavoritesCollectionViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/9/23.
//

import Foundation
import UIKit

protocol FavoritesCollectionViewControllerDelegate: AnyObject {
    func didSelect(_ item: Character)
    func didUnmarkAsFavorite(_ item: Character)
}

class FavoritesCollectionViewController: UITableViewController {
    
    weak var delegate: FavoritesCollectionViewControllerDelegate?
    
    var items = [Character]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as? CharacterCell else { return UITableViewCell() }
        let character = items[indexPath.row]
        cell.configure(with: character, imageCache: imageCache)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelect(item)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        tableView.beginUpdates()
        let item = self.items[indexPath.row]
        delegate?.didUnmarkAsFavorite(item)
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}
