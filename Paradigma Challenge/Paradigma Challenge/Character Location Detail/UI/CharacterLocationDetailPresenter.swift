//
//  CharacterLocationDetailPresenter.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/7/23.
//

import Foundation

protocol CharacterLocationDetailPresenting {
    var view: CharacterLocationDetailView? { get set }
    func viewDidLoad()
}

final class CharacterLocationDetailPresenter: CharacterLocationDetailPresenting {
    
    weak var view: CharacterLocationDetailView?
    
    private let locationID: String?
    private let repository: LocationDetailRepository
    
    init(locationID: String?,
         repository: LocationDetailRepository = LocationDetailWebAPIRepository()) {
        self.locationID = locationID
        self.repository = repository
    }
    
    func viewDidLoad() {
        guard let locationID = locationID else { return }
        Task.init {
            do {
                let detail = try await repository.getLocationDetail(forLocationID: locationID)
                await MainActor.run {
                    view?.update(with: detail)
                }
            } catch {
                // TODO: Handle error
            }
        }
    }
}
