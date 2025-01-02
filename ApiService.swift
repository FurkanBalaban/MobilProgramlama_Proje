//
//  ApiService.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 30.12.2024.
//

import Foundation

/// API Servis sınıfı - JSONPlaceholder üzerinden Post CRUD işlemleri için.
class ApiService {
    static let shared = ApiService() // Singleton örneği
    private let baseUrl = "https://jsonplaceholder.typicode.com/posts" // API Temel URL'i
    
    public init() {} // Singleton yapısı için private init
    
    // MARK: - GET Request - Verileri Al
    /// Tüm gönderileri alır
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    func createPost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: baseUrl) else {
            completion(.failure(NSError(domain: "URL Error", code: -1, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(post)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let createdPost = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(createdPost))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    // MARK: - PUT Request - Veri Güncelle
    /// Mevcut bir gönderiyi günceller
    func updatePost(post: Post, completion: @escaping (Post?) -> Void) {
        guard let id = post.id, let url = URL(string: "\(baseUrl)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(post)
        } catch {
            print("Update Post Encoding Error: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Update Post Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Update Post Error: Veri alınamadı.")
                completion(nil)
                return
            }
            
            do {
                let updatedPost = try JSONDecoder().decode(Post.self, from: data)
                completion(updatedPost)
            } catch {
                print("Update Post Decoding Error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    // MARK: - DELETE Request - Veri Sil
    /// Belirtilen id'ye sahip gönderiyi siler
    func deletePost(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Delete Post Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}
