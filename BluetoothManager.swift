//
//  BluetoothManager.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 1.01.2025.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject {
    private var centralManager: CBCentralManager!
    @Published var isBluetoothOn: Bool = false
    @Published var discoveredDevices: [CBPeripheral] = []
    private var connectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth açık değil.")
            return
        }
        print("Bluetooth taraması başlıyor...")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        centralManager.stopScan()
        print("Bluetooth taraması durduruldu.")
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        self.connectedPeripheral = peripheral
    }

    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            connectedPeripheral = nil
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth açık.")
            isBluetoothOn = true
        case .poweredOff:
            print("Bluetooth kapalı.")
            isBluetoothOn = false
        case .unsupported:
            print("Bluetooth bu cihazda desteklenmiyor.")
        case .unauthorized:
            print("Bluetooth kullanımı için izin verilmedi.")
        default:
            print("Bluetooth durumu bilinmiyor.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !discoveredDevices.contains(peripheral) {
            discoveredDevices.append(peripheral)
            print("Bulunan cihaz: \(peripheral.name ?? "Bilinmeyen cihaz")")
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Cihaza bağlandı: \(peripheral.name ?? "Bilinmeyen cihaz")")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Cihaza bağlanılamadı: \(peripheral.name ?? "Bilinmeyen cihaz"). Hata: \(error?.localizedDescription ?? "Bilinmiyor")")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Cihaz bağlantısı kesildi: \(peripheral.name ?? "Bilinmeyen cihaz")")
    }
}
