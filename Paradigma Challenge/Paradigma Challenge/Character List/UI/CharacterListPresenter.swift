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
    func didSelect(_ item: Character)
}

enum CharacterList: String {
    case results = "All"
    case favorites
}

final class CharacterListPresenter: CharacterListPresenting {
    
    weak var view: CharacterListView?
    
    private let resultRepository: ResultRepository
    private let favoritesRepository: FavoritesRepository
    
    private var selectedList: CharacterList?
    private var resultsCurrentPage = 1
    
    init(resultRepository: ResultRepository = ResultWebAPIRepository(),
         favoritesRepository: FavoritesRepository = FavoritesLocalRepository()) {
        self.resultRepository = resultRepository
        self.favoritesRepository = favoritesRepository
    }
    
    func viewDidLoad() {
        view?.setUp(withLists: [.results, .favorites])
    }
    
    func didScrollToLastItem() {
        guard selectedList == .results else { return }
        resultsCurrentPage += 1
        Task.init {
            await loadResults(untilPage: resultsCurrentPage)
        }
    }
    
    func didSelect(list: CharacterList) {
        switch list {
        case .results:
            Task.init {
                await loadResults(untilPage: resultsCurrentPage)
            }
        case .favorites:
            Task.init {
                await loadFavorites()
            }
        }
        selectedList = list
    }
    
    func didSelect(_ item: Character) {
        view?.navigateToDetailView(for: item.location)
    }
    
    private func loadResults(untilPage page: Int) async {
        do {
            let results = try await resultRepository.getResults(untilPage: resultsCurrentPage)
            await MainActor.run {
                view?.update(with: results)
            }
        } catch {
            // TODO: Handle error
        }
    }
    
    private func loadFavorites() async {
        do {
            let favorites = try await favoritesRepository.getFavorites()
            await MainActor.run {
                view?.update(with: favorites)
            }
        } catch {
            // TODO: Handle error
        }
    }
}
