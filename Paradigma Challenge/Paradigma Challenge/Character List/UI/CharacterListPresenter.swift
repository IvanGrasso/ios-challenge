//
//  CharacterListPresenter.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation

protocol CharacterListPresenting {
    var view: CharacterListView? { get set }
    func viewDidLoad()
    func didScrollToLastItem()
    func didSelect(list: CharacterList)
}

enum CharacterList: String {
    case all
    case favorites
}

final class CharacterListPresenter: CharacterListPresenting {
    
    weak var view: CharacterListView?
    private let repository: CharacterRepository
    
    private var selectedList: CharacterList?
    private var currentPage = 1
    
    init(repository: CharacterRepository = CharacterWebAPIRepository()) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        view?.setUp(withLists: [.all, .favorites])
    }
    
    func didScrollToLastItem() {
        guard selectedList == .all else { return }
        currentPage += 1
        Task.init {
            await loadCharacters(untilPage: currentPage)
        }
    }
    
    func didSelect(list: CharacterList) {
        selectedList = list
        switch list {
        case .all:
            Task.init {
                await loadCharacters(untilPage: currentPage)
            }
        case .favorites:
            Task.init {
                await loadFavorites()
            }
        }
    }
    
    private func loadCharacters(untilPage page: Int) async {
        do {
            let characters = try await repository.getCharacters(untilPage: currentPage)
            await MainActor.run {
                view?.update(with: characters)
            }
        } catch {
            // TODO: Handle error
        }
    }
    
    private func loadFavorites() async {
        do {
            let characters = try await repository.getFavorites()
            await MainActor.run {
                view?.update(with: characters)
            }
        } catch {
            // TODO: Handle error
        }
    }
}
