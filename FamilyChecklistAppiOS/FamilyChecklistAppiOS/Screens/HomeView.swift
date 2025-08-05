//
//  HomeView.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 05/08/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.viewState.isLoading {
                    ProgressView("Loading your lists...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.viewState.errorMessage {
                    VStack(spacing: 12) {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            viewModel.onAppear()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.viewState.toDoLists.isEmpty {
                    Text("📝 You have no to-do lists yet.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.viewState.toDoLists) { list in
                        Button {
                            viewModel.viewState.onSelectList(list)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(list.title)
                                    .font(.headline)
                                if !list.description.isEmpty {
                                    Text(list.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle(viewModel.viewState.title)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    HomeView() // TODO: need to mock this since it will not have a valid SessionToken
}
