//
//  AIService.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 2.01.2025.
//

import Foundation

class AIService {
    private let apiKey = 

    func generateRecommendation(prompt: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": prompt,
            "max_tokens": 100
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("AI API Hatası: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data,
                  let result = try? JSONDecoder().decode(AIResponse.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(result.choices.first?.text)
        }.resume()
    }
}

struct AIResponse: Codable {
    let choices: [AIChoice]
}

struct AIChoice: Codable {
    let text: String
}
