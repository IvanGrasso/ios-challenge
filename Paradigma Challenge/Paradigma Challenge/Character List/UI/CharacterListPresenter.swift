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
    func didSelect(sectionWithIndex index: Int)
}

final class CharacterListPresenter: CharacterListPresenting {
    
    weak var view: CharacterListView?
    let repository: CharacterRepository
    
    init(repository: CharacterRepository = CharacterWebAPIRepository()) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        Task.init {
            do {
                let characters = try await repository.getCharacters(forPage: 1)
                let viewData = CharacterListViewData(sectionTitles: ["All", "Favorites"], selectedSectionIndex: 0, items: characters)
                await MainActor.run {
                    view?.update(with: viewData)
                }
            } catch {
                // TODO: Handle error
            }
        }
    }
    
    func didSelect(sectionWithIndex index: Int) {
        
    }
}
