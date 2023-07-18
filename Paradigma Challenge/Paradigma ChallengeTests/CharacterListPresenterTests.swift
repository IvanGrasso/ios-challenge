//
//  CharacterListPresenterTests.swift
//  Paradigma ChallengeTests
//
//  Created by Ivan Grasso on 7/9/23.
//

import XCTest
@testable import Paradigma_Challenge

final class CharacterListPresenterTests: XCTestCase {
    
    var sut: CharacterListPresenter!
    var resultRepository: MockResultRepository!
    var favoritesRepository: MockFavoritesRepository!
    var view: MockCharacterListView!
    
    override func setUp() {
        super.setUp()
        resultRepository = MockResultRepository()
        favoritesRepository = MockFavoritesRepository()
        view = MockCharacterListView()
        sut = CharacterListPresenter(resultRepository: resultRepository, favoritesRepository: favoritesRepository)
        sut.view = view
    }
    
    override func tearDown() {
        sut = nil
        resultRepository = nil
        favoritesRepository = nil
        view = nil
        super.tearDown()
    }
    
    func test_GivenViewIsSetUp_WhenViewDidScrollToLastResult_ThenActivityIndicatorHidesAndItemsUpdateWithPagingEnabled() async throws {
        // Given
        var testPage = 0
        resultRepository.mockGetResults = { page in
            testPage = page
            return []
        }
        
        var testIsPagingEnabled = false
        view.mockUpdateResults = { items, isPagingEnabled in
            testIsPagingEnabled = isPagingEnabled
        }
        
        // When
        await sut.didScrollToLastResult()
        
        // Then
        XCTAssertTrue(view.hideActivityIndicatorWasCalled)
        XCTAssertEqual(testPage, 2)
        XCTAssertTrue(testIsPagingEnabled)
    }
    
}
