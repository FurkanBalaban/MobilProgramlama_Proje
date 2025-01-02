//
//  Post.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 30.12.2024.
//

import Foundation

struct Post: Codable, Identifiable {
    var id: Int?
    var title: String
    var content: String // JSON'da `body` varsa eşleme yapılacak
    var userId: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content = "body" // JSON'daki `body` alanı, `content` ile eşleştiriliyor
        case userId
    }
}
