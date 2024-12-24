//
//  AddTripView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

import SwiftUI

struct AddTripView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var destination: String = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Seyahat Detayları")) {
                    TextField("Başlık", text: $title)
                    TextField("Gidilecek Yer", text: $destination)
                    DatePicker("Başlangıç Tarihi", selection: $startDate, displayedComponents: .date)
                    DatePicker("Bitiş Tarihi", selection: $endDate, displayedComponents: .date)
                    TextField("Notlar", text: $notes)
                }
            }
            .navigationTitle("Yeni Seyahat Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        addTrip()
                    }
                }
            }
        }
    }

    private func addTrip() {
        let newTrip = Trip(context: viewContext)
        newTrip.title = title
        newTrip.destination = destination
        newTrip.startDate = startDate
        newTrip.endDate = endDate
        newTrip.notes = notes

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Seyahat eklenirken hata oluştu: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddTripView()
}
