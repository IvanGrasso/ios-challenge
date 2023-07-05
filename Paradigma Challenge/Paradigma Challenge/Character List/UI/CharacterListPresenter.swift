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
    func didSelect(sectionWithIndex index: Int)
}

final class CharacterListPresenter: CharacterListPresenting {
    
    weak var view: CharacterListView?
    private let repository: CharacterRepository
    
    private var currentPage = 1
    
    init(repository: CharacterRepository = CharacterWebAPIRepository()) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        Task.init {
            await loadCharacters(untilPage: currentPage)
        }
    }
    
    func didScrollToLastItem() {
        currentPage += 1
        Task.init {
            await loadCharacters(untilPage: currentPage)
        }
    }
    
    func didSelect(sectionWithIndex index: Int) {
        
    }
    
    private func loadCharacters(untilPage page: Int) async {
        do {
            let characters = try await repository.getCharacters(untilPage: currentPage)
            let viewData = CharacterListViewData(sectionTitles: ["All", "Favorites"], selectedSectionIndex: 0, items: characters)
            await MainActor.run {
                view?.update(with: viewData)
            }
        } catch {
            // TODO: Handle error
        }
    }
}
