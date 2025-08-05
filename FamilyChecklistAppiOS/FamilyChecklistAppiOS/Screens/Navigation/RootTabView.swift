//
//  RootTabView.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 05/08/2025.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            //TODO: build these views
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
//
//            ProfileScreen()
//                .tabItem {
//                    Label("Profile", systemImage: "person.crop.circle")
//                }
        }
    }
}
