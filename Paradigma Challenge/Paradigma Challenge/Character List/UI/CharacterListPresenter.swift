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
    func didSelectResultList() async
    func didSelectFavoritesList() async
    func didScrollToLastResult() async
    func didSelect(_ item: Character)
    func didMarkAsFavorite(_ item: Character) async
    func didUnmarkAsFavorite(_ item: Character) async
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
    
    func viewDidLoad() {
        view?.setUp(withListTitles: ["All", "Favorites"])
    }
    
    func didScrollToLastResult() async {
        guard resultRepository.pageCount > resultsCurrentPage else { return }
        await loadResults(forPage: resultsCurrentPage + 1)
    }
    
    func didSelectResultList() async {
        if resultsCurrentPage == 0 {
            await MainActor.run {
                view?.showActivityIndicator()
            }
            await loadResults(forPage: 1)
        } else {
            await MainActor.run {
                view?.updateResults(with: resultRepository.results, isPagingEnabled: isPagingEnabled)
            }
        }
    }
    
    func didSelectFavoritesList() async {
        await MainActor.run {
            view?.showActivityIndicator()
        }
        await loadFavorites()
    }
    
    func didSelect(_ item: Character) {
        view?.navigateToDetailView(withTitle: "\(item.name)'s Last Location", location: item.location)
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
    
    private func loadResults(forPage page: Int) async {
        do {
            try await resultRepository.getResults(forPage: page)
            resultsCurrentPage += 1
            await MainActor.run {
                view?.hideActivityIndicator()
                view?.updateResults(with: resultRepository.results, isPagingEnabled: isPagingEnabled)
            }
        } catch {
            await MainActor.run {
                view?.showAlert(withTitle: "Something's wrong",
                                message: "There was an error loading your content.",
                                buttonTitle: "Retry",
                                handler: { [weak self] in
                    guard let self = self else { return }
                    self.view?.showActivityIndicator()
                    await self.loadResults(forPage: page)
                })
            }
        }
    }
    
    private func loadFavorites() async {
        do {
            let favorites = try await favoritesRepository.getFavorites()
            await MainActor.run {
                view?.hideActivityIndicator()
                view?.updateFavorites(with: favorites)
            }
        } catch {
            await MainActor.run {
                view?.showAlert(withTitle: "Something's wrong",
                                message: "There was an error loading your favorites.",
                                buttonTitle: "Retry",
                                handler: { [weak self] in
                    guard let self = self else { return }
                    self.view?.showActivityIndicator()
                    Task.init {
                        await self.loadFavorites()
                    }
                })
            }
        }
    }
}
