//
//  LocationManager.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 29.12.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var currentLocation: CLLocationCoordinate2D? // Kullanıcının koordinat bilgisi
    @Published var authorizationStatus: CLAuthorizationStatus? // Yetkilendirme durumu
    @Published var locationError: String? // Hata mesajı

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
    }

    // Konum izni istemek için
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // Konum güncellemelerini başlatmak için
    func startUpdatingLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            DispatchQueue.main.async {
                self.locationError = "Konum servisleri etkin değil."
            }
            return
        }
        locationManager.startUpdatingLocation()
    }
    func checkAuthorizationStatus() {
        print("checkAuthorizationStatus çağrıldı") // Bu log mutlaka düşmeli

        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("İzin henüz verilmedi, izin istendi")
            requestPermission()
        case .restricted, .denied:
            print("İzin reddedildi")
            DispatchQueue.main.async {
                self.locationError = "Konum erişimi reddedildi."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            print("İzin verildi, konum güncellemeleri başlatılıyor")
            startUpdatingLocation()
        @unknown default:
            print("Bilinmeyen yetkilendirme durumu")
            DispatchQueue.main.async {
                self.locationError = "Bilinmeyen yetkilendirme durumu."
            }
        }
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
            self.locationError = nil
            print("Konum Güncellendi: Enlem \(location.coordinate.latitude), Boylam \(location.coordinate.longitude)")
        }
    }


    // Yetkilendirme durumu değiştiğinde tetiklenir
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
        }
        checkAuthorizationStatus()
    }

    // Hata durumunda tetiklenir
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = "Konum alınamadı: \(error.localizedDescription)"
        }
    }
}
