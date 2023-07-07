//
//  CharacterCollectionViewController.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation
import UIKit

protocol CharacterCollectionViewControllerDelegate: AnyObject {
    func didScrollToLastItem()
    func didSelect(_ item: Character)
}

class CharacterCollectionViewController: UITableViewController {
    
    weak var delegate: CharacterCollectionViewControllerDelegate?
    
    var items = [Character]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "DefaultCell")
        
        tableView.tableFooterView = {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
            spinner.startAnimating()
            return spinner
        }()
        
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as? CharacterCell else { return UITableViewCell() }
        let character = items[indexPath.row]
        cell.character = character
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
}
