//
//  pawn_test_appApp.swift
//  pawn-test-app
//
//  Created by Ignas on 2022-11-22.
//

import SwiftUI
import ComposableArchitecture

@main
struct pawn_test_appApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView(store:
                        Store(initialState: Login.State(),
                              reducer: Login()._printChanges()
                             )
            )
        }
    }
}
