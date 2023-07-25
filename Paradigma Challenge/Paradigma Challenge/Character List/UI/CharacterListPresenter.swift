//
//  CharacterListPresenter.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/4/23.
//

import Foundation

protocol CharacterListPresenting {
    var view: CharacterListView? { get set }
    func viewDidLoad() async
    func didSelectResultList() async
    func didSelectFavoritesList() async
    func didScrollToLastResult() async
    func didSelect(_ item: Character)
    func didMarkAsFavorite(_ item: Character) async
    func didUnmarkAsFavorite(_ item: Character) async
    func didRetryLoadingResults() async
    func didRetryLoadingFavorites() async
}

final class CharacterListPresenter: CharacterListPresenting {
    
    weak var view: CharacterListView?
    
    private let resultRepository: ResultRepository
    private let favoritesRepository: FavoritesRepository
    
    private var resultsCurrentPage = 0
    private var isPagingEnabled: Bool {
        return resultRepository.pageCount > resultsCurrentPage
    }
    
    init(resultRepository: ResultRepository = ResultWebAPIRepository(),
         favoritesRepository: FavoritesRepository = FavoritesLocalRepository()) {
        self.resultRepository = resultRepository
        self.favoritesRepository = favoritesRepository
    }
    
    func viewDidLoad() async {
        await loadResults(forPage: 1)
    }
    
    func didScrollToLastResult() async {
        guard resultRepository.pageCount > resultsCurrentPage else { return }
        await loadResults(forPage: resultsCurrentPage + 1)
    }
    
    func didSelectResultList() async {
        await MainActor.run {
            view?.viewState = .results(items: resultRepository.results,
                                       isPagingEnabled: isPagingEnabled)
        }
    }
    
    func didSelectFavoritesList() async {
        await MainActor.run {
            view?.viewState = .loading
        }
        await loadFavorites()
    }
    
    func didSelect(_ item: Character) {
        view?.navigateToDetail(withTitle: "\(item.name)'s Last Location",
                               location: item.location)
    }
    
    func didMarkAsFavorite(_ item: Character) {
        Task.init {
            try await favoritesRepository.addFavorite(item)
        }
    }
    
    func didUnmarkAsFavorite(_ item: Character) {
        Task.init {
            try await favoritesRepository.removeFavorite(item)
        }
    }
    
    func didRetryLoadingResults() async {
        await loadResults(forPage: resultsCurrentPage)
    }
    
    func didRetryLoadingFavorites() async {
        await loadFavorites()
    }
    
    private func loadResults(forPage page: Int) async {
        await MainActor.run {
            view?.viewState = .loading
        }
        do {
            try await resultRepository.getResults(forPage: page)
            resultsCurrentPage += 1
            await MainActor.run {
                view?.viewState = .results(items: resultRepository.results,
                                           isPagingEnabled: isPagingEnabled)
            }
        } catch {
            await MainActor.run {
                view?.viewState = .resultsError
            }
        }
    }
    
    private func loadFavorites() async {
        await MainActor.run {
            view?.viewState = .loading
        }
        do {
            let favorites = try await favoritesRepository.getFavorites()
            await MainActor.run {
                view?.viewState = .favorites(items: favorites)
            }
        } catch {
            view?.viewState = .favoritesError
        }
    }
}
