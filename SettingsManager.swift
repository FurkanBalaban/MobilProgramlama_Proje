//
//  SettingsManager.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 24.12.2024.
//

import Foundation

class SettingsManager: ObservableObject {
    @Published var themeMode: String {
        didSet {
            // Kullanıcı tercihlerini kaydet
            UserDefaults.standard.set(themeMode, forKey: "themeMode")
        }
    }

    init() {
        // Kullanıcı tercihlerini yükle
        self.themeMode = UserDefaults.standard.string(forKey: "themeMode") ?? "light"
    }
}
