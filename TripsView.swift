//
//  TripsView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

import SwiftUI

struct TripsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        animation: .default)
    private var trips: FetchedResults<Trip> // Core Data'dan seyahatleri çek

    @State private var showAddTripForm = false

    var body: some View {
        NavigationView {
            VStack {
                if trips.isEmpty {
                    Text("Henüz bir seyahat planınız yok.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(trips) { trip in
                            VStack(alignment: .leading) {
                                Text(trip.title ?? "Bilinmeyen Başlık")
                                    .font(.headline)
                                Text(trip.destination ?? "Bilinmeyen Yer")
                                    .font(.subheadline)
                                Text("Tarih: \(formattedDate(trip.startDate)) - \(formattedDate(trip.endDate))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: deleteTrips) // Silme işlemi
                    }
                }
            }
            .navigationTitle("Seyahatlerim")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddTripForm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTripForm) {
                AddTripView() // Yeni seyahat ekleme formu
            }
        }
    }

    // Tarih formatlama
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Tarih yok" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Seyahat silme
    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            offsets.map { trips[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Silme sırasında hata oluştu: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    TripsView()
}
