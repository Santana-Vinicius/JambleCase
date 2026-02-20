//
//  ContentView.swift
//  JambleCase
//
//  Created by Vinicius Santana on 17/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView(
            profileViewModel: AppDependencies.shared.makeProfileViewModel()
        )
    }
}
