//
//  SettingsView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 24.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsManager = SettingsManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Tema Modu: \(settingsManager.themeMode)")
                .font(.title)

            Button("Dark Mode") {
                settingsManager.themeMode = "dark"
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Light Mode") {
                settingsManager.themeMode = "light"
            }
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
