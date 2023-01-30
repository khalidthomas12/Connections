//
//  ConnectionApp.swift
//  Connection
//
//  Created by Khalid Thomas on 1/29/23.
//

import SwiftUI
import FirebaseCore

@main
struct SwiftUI_AuthApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
