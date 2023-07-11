//
//  MockCharacterListView.swift
//  Paradigma ChallengeTests
//
//  Created by Ivan Grasso on 7/9/23.
//

import Foundation
@testable import Paradigma_Challenge

final class MockCharacterListView: CharacterListView {
    
    var mockUpdateResults: ((_ items: [Paradigma_Challenge.Character], _ isPagingEnabled: Bool) -> Void)?
    var showActivityIndicatorWasCalled = false
    var hideActivityIndicatorWasCalled = false
    
    func setUp(withListTitles titles: [String]) {
        
    }
    
    func updateResults(with items: [Paradigma_Challenge.Character], isPagingEnabled: Bool) {
        mockUpdateResults?(items, isPagingEnabled)
    }
    
    func updateFavorites(with items: [Paradigma_Challenge.Character]) {
        
    }
    
    func navigateToDetailView(withTitle title: String, location: Paradigma_Challenge.CharacterLocation?) {
        
    }
    
    func showActivityIndicator() {
        showActivityIndicatorWasCalled = true
    }
    
    func hideActivityIndicator() {
        hideActivityIndicatorWasCalled = true
    }
    
    func showAlert(withTitle title: String, message: String, buttonTitle: String, handler: @escaping () -> Void) {
        
    }
}
