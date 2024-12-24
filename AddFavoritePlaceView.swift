//
//  AddFavoritePlaceView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 24.12.2024.
//

import SwiftUI

struct AddFavoritePlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var details: String = ""

    var onSave: (String, String, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mekan Bilgileri")) {
                    TextField("Mekan Adı", text: $name)
                    TextField("Lokasyon", text: $location)
                    TextField("Detaylar", text: $details)
                }
            }
            .navigationBarTitle("Favori Mekan Ekle", displayMode: .inline)
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Kaydet") {
                    if !name.isEmpty && !location.isEmpty {
                        onSave(name, location, details)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
    }
}



