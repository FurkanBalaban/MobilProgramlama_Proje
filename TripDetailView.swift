//
//  TripDetailView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 22.12.2024.
//

import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @State private var weatherDescription: String = "Hava durumu yükleniyor..."
    @State private var temperature: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(trip.title ?? "Bilinmeyen Başlık")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            Text("Gidilecek Yer: \(trip.destination ?? "Bilinmeyen Yer")")
                .font(.title2)

            Text("Başlangıç Tarihi: \(formattedDate(trip.startDate))")
                .font(.body)

            Text("Bitiş Tarihi: \(formattedDate(trip.endDate))")
                .font(.body)

            Divider()

            // Hava durumu bilgisi
            Text("Hava Durumu")
                .font(.title3)
                .fontWeight(.bold)

            if !temperature.isEmpty {
                Text("Sıcaklık: \(temperature)°C")
                    .font(.body)
                Text(weatherDescription)
                    .font(.body)
                    .foregroundColor(.gray)
            } else {
                Text(weatherDescription)
                    .font(.body)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Seyahat Detayları")
        .onAppear {
            fetchWeather()
        }
    }

    private func fetchWeather() {
        guard let city = trip.destination else { return }
        let weatherService = WeatherService()

        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    self.temperature = String(format: "%.1f", weatherResponse.main.temp)
                    self.weatherDescription = weatherResponse.weather.first?.description ?? "Açıklama yok"
                case .failure:
                    self.weatherDescription = "Hava durumu bilgisi alınamadı."
                }
            }
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Tarih yok" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    TripDetailView(trip: Trip()) // Örnek veri
}
