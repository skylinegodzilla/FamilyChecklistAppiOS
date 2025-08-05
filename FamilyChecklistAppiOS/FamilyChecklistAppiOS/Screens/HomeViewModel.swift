//
//  HomeViewModel.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 05/08/2025.
//

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - Public ViewState
    @Published
    private(set) var viewState: ViewState = .initial

    // MARK: - Private State
    private var model: Model {
        didSet {
            viewState = createViewState(from: model)
        }
    }

    private let toDoListRepository: ToDoListRepository
    private let sessionHelper: SessionHelper

    // MARK: - Init
    init(toDoListRepository: ToDoListRepository = ToDoListRepository(),
    sessionHelper: SessionHelper = .shared
    ) {
        self.toDoListRepository = toDoListRepository
        self.sessionHelper = sessionHelper
        self.model = Model()
        self.viewState = createViewState(from: model)
        loadLists()
    }

    // MARK: - Public Methods
    func onAppear() {
        loadLists()
    }

    // MARK: - ViewState Mapping
    private func createViewState(from model: Model) -> ViewState {
        ViewState(
            title: "To-Do Lists",
            isLoading: model.isLoading,
            errorMessage: model.errorMessage,
            toDoLists: model.toDoLists,
            onSelectList: { [weak self] list in
                self?.selectList(list)
            }
        )
    }

    // MARK: - Internal Logic
    private func loadLists() {
        model.isLoading = true
        model.errorMessage = nil
        
        let token = sessionHelper.getSession()?.token ?? ""

        Task {
            let result = await toDoListRepository.fetchLists(token: token)
            switch result {
            case .success(let lists):
                model.toDoLists = lists
            case .failure(let error):
                model.errorMessage = error.localizedDescription
            }
            model.isLoading = false
        }
    }

    private func selectList(_ list: ToDoList) {
        print("Selected list: \(list.title)")
        // TODO: Navigate to list items screen
    }

    // MARK: - Internal Types
    private struct Model {
        var isLoading: Bool = false
        var errorMessage: String? = nil
        var toDoLists: [ToDoList] = []
    }

    struct ViewState {
        let title: String
        let isLoading: Bool
        let errorMessage: String?
        let toDoLists: [ToDoList]
        let onSelectList: (ToDoList) -> Void

        static let initial = ViewState(
            title: "To-Do Lists",
            isLoading: false,
            errorMessage: nil,
            toDoLists: [],
            onSelectList: { _ in }
        )
    }
}
