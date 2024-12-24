//
//  WeatherService.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 22.12.2024.
//

import Foundation

struct WeatherResponse: Decodable {
    let main: Main
    let weather: [Weather]

    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
    }

    struct Weather: Decodable {
        let description: String
        let icon: String
    }
}

class WeatherService {
    private let apiKey = "dcc96e894328acd692650fa792c6c895" // OpenWeatherMap'ten aldığınız API Key'i buraya yapıştırın
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric") else {
            completion(.failure(NSError(domain: "URL Error", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -2, userInfo: nil)))
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

