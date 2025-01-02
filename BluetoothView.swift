//
//  BluetoothView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 1.01.2025.
//

import SwiftUI

struct BluetoothView: View {
    @StateObject private var bluetoothManager = BluetoothManager()

    var body: some View {
        VStack {
            Text("Bluetooth Ayarları")
                .font(.title)
                .bold()
                .padding()

            if bluetoothManager.isBluetoothOn {
                Text("Bluetooth açık")
                    .foregroundColor(.green)
            } else {
                Text("Bluetooth kapalı veya desteklenmiyor")
                    .foregroundColor(.red)
            }

            Button(action: {
                bluetoothManager.startScanning()
            }) {
                Text("Bluetooth Taramasını Başlat")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                bluetoothManager.stopScanning()
            }) {
                Text("Bluetooth Taramasını Durdur")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            print("Bluetooth ekranı açıldı.") // Çıktı ile kontrol
        }
    }
}
