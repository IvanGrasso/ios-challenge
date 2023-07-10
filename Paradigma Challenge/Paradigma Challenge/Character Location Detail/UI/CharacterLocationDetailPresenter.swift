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
        guard locationID != nil else {
            view?.update(with: LocationDetail(id: 0, name: "Location Unknown", type: "", dimension: ""))
            return
        }
        view?.showActivityIndicator()
        loadLocation()
    }
    
    func loadLocation() {
        Task.init {
            do {
                guard let locationID = locationID else { return }
                let detail = try await repository.getLocationDetail(forLocationID: locationID)
                await MainActor.run {
                    view?.hideActivityIndicator()
                    view?.update(with: detail)
                }
            } catch {
                await MainActor.run {
                    view?.showAlert(withTitle: "Something's wrong",
                                    message: "There was an error loading the location.",
                                    buttonTitle: "Retry",
                                    handler: { [weak self] in
                        guard let self = self else { return }
                        self.view?.showActivityIndicator()
                        self.loadLocation()
                    })
                }
            }
        }
        
    }
}
