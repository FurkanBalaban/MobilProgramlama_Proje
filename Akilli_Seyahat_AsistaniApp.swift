//
//  Akilli_Seyahat_AsistaniApp.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//


import SwiftUI

@main
struct Akilli_Seyahat_AsistaniApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView() // ContentView yerine LoginView çağırılıyor
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

