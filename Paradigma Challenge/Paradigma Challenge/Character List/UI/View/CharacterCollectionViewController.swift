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

class CharacterCollectionViewController: UICollectionViewController {
    
    enum CollectionViewSection {
        case main
    }
    
    weak var delegate: CharacterCollectionViewControllerDelegate?
    
    var items = [Character]() {
        didSet {
            applySnapshot(animatingDifferences: false)
        }
    }
    
    lazy var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, Character> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Character> { (cell, indexPath, item) in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.name
            cell.contentConfiguration = configuration
        }
        let dataSource = UICollectionViewDiffableDataSource<CollectionViewSection, Character>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Character) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: layoutConfiguration)
        definesPresentationContext = true
    }
    
    private func applySnapshot(animatingDifferences: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, Character>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item == items.count - 1 else { return }
        delegate?.didScrollToLastItem()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelect(item)
    }
}
