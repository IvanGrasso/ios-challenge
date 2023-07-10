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
    func didSelectResultList()
    func didSelectFavoritesList()
    func didScrollToLastResult()
    func didSelect(_ item: Character)
    func didMarkAsFavorite(_ item: Character)
    func didUnmarkAsFavorite(_ item: Character)
}

final class CharacterListPresenter: CharacterListPresenting {
    
    weak var view: CharacterListView?
    
    private let resultRepository: ResultRepository
    private let favoritesRepository: FavoritesRepository
    
    private var resultsCurrentPage = 1
    
    init(resultRepository: ResultRepository = ResultWebAPIRepository(),
         favoritesRepository: FavoritesRepository = FavoritesLocalRepository()) {
        self.resultRepository = resultRepository
        self.favoritesRepository = favoritesRepository
    }
    
    func viewDidLoad() {
        view?.setUp(withListTitles: ["All", "Favorites"])
    }
    
    func didScrollToLastResult() {
        resultsCurrentPage += 1
        Task.init {
            await loadResults(untilPage: resultsCurrentPage)
        }
    }
    
    func didSelectResultList() {
        Task.init {
            await loadResults(untilPage: resultsCurrentPage)
        }
    }
    
    func didSelectFavoritesList() {
        Task.init {
            await loadFavorites()
        }
    }
    
    func didSelect(_ item: Character) {
        view?.navigateToDetailView(for: item.location)
    }
    
    func didMarkAsFavorite(_ item: Character) {
        Task.init {
            do {
                try await favoritesRepository.addFavorite(item)
            } catch {
                // TODO: Handle error
            }
        }
    }
    
    func didUnmarkAsFavorite(_ item: Character) {
        Task.init {
            do {
                try await favoritesRepository.removeFavorite(item)
            } catch {
                // TODO: Handle error
            }
        }
    }
    
    private func loadResults(untilPage page: Int) async {
        do {
            let results = try await resultRepository.getResults(untilPage: resultsCurrentPage)
            await MainActor.run {
                view?.updateResults(with: results, isPagingEnabled: true)
            }
        } catch {
            // TODO: Handle error
        }
    }
    
    private func loadFavorites() async {
        do {
            let favorites = try await favoritesRepository.getFavorites()
            await MainActor.run {
                view?.updateFavorites(with: favorites)
            }
        } catch {
            // TODO: Handle error
        }
    }
}
