//
//  NetworkMonitor.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 1.01.2025.
//

import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("İnternet bağlantısı mevcut.")
                if path.usesInterfaceType(.wifi) {
                    print("Wi-Fi bağlantısı kullanılıyor.")
                } else if path.usesInterfaceType(.cellular) {
                    print("Hücresel bağlantı kullanılıyor.")
                } else {
                    print("Bağlantı başka bir ağ türü ile sağlanıyor.")
                }
            } else {
                print("İnternet bağlantısı yok.")
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
