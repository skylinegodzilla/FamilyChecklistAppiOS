//
//  ToDoListRepository.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 05/08/2025.
//

import Foundation

protocol ToDoListRepositoryProtocol {
    func fetchLists(token: String) async -> Result<[ToDoList], Error>
    func createList(title: String, description: String, token: String) async -> Result<ToDoList, Error>
    func updateList(listId: Int64, title: String, description: String, token: String) async -> Result<ToDoList, Error>
    func deleteList(listId: Int64, token: String) async -> Result<[ToDoList], Error>
}

// MARK: - Request Models
struct ToDoListCreateUpdateRequest: Codable, Sendable {
    let listId: Int64?
    let title: String
    let description: String
}

// MARK: - Response Models
struct ToDoItemResponse: Codable, Equatable, Sendable, Identifiable {
    let itemId: Int64
    let title: String
    let description: String
    let completed: Bool
    let dueDate: String
    let position: Int

    var id: Int64 { itemId }
}


final actor ToDoListRepository: ToDoListRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    private let baseURLString: String
    
    init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
        self.baseURLString = AppEnvironment.current.baseURL
    }

    func fetchLists(token: String) async -> Result<[ToDoList], Error> {
        do {
            let request = try RequestBuilder(baseURL: baseURLString, path: "/api/todolists")
                .setMethod("GET")
                .addAuthorization(token: token)
                .build()

            return await networkClient.performRequest(request)
        } catch {
            return .failure(error)
        }
    }

    func createList(title: String, description: String, token: String) async -> Result<ToDoList, Error> {
        do {
            let payload = ToDoListCreateUpdateRequest(listId: nil, title: title, description: description)
            let request = try RequestBuilder(baseURL: baseURLString, path: "/api/todolists")
                .setMethod("POST")
                .addAuthorization(token: token)
                .setJSONBody(payload)
                .build()

            return await networkClient.performRequest(request)
        } catch {
            return .failure(error)
        }
    }

    func updateList(listId: Int64, title: String, description: String, token: String) async -> Result<ToDoList, Error> {
        do {
            let payload = ToDoListCreateUpdateRequest(listId: listId, title: title, description: description)
            let request = try RequestBuilder(baseURL: baseURLString, path: "/api/todolists")
                .setMethod("PUT")
                .addAuthorization(token: token)
                .setJSONBody(payload)
                .build()

            return await networkClient.performRequest(request)
        } catch {
            return .failure(error)
        }
    }

    func deleteList(listId: Int64, token: String) async -> Result<[ToDoList], Error> {
        do {
            let request = try RequestBuilder(baseURL: baseURLString, path: "/api/todolists/\(listId)")
                .setMethod("DELETE")
                .addAuthorization(token: token)
                .build()

            return await networkClient.performRequest(request)
        } catch {
            return .failure(error)
        }
    }
}



