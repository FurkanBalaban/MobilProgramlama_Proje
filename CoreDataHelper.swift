//
//  CoreDataHelper.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataHelper {
    static let shared = CoreDataHelper()
    let context = PersistenceController.shared.container.viewContext

    // Kullanıcı Kaydetme
    func saveUser(email: String, password: String, rememberMe: Bool) {
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password
        newUser.rememberMe = rememberMe
        
        do {
            try context.save()
            print("Kullanıcı başarıyla kaydedildi.")
        } catch {
            print("Kullanıcı kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
    }

    // Kullanıcı Getirme
    func fetchRememberedUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rememberMe == YES")

        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Kullanıcı getirilirken hata oluştu: \(error.localizedDescription)")
            return nil
        }
    }

    // Favori Mekan Ekleme
    func addFavoritePlace(name: String, location: String, details: String?, user: User) {
        let favoritePlace = FavoritePlace(context: context)
        favoritePlace.name = name
        favoritePlace.location = location
        favoritePlace.details = details
        favoritePlace.user = user

        saveContext()
    }

    // Favori Mekanları Getirme
    func fetchFavoritePlaces(for user: User) -> [FavoritePlace] {
        let request: NSFetchRequest<FavoritePlace> = FavoritePlace.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)

        do {
            return try context.fetch(request)
        } catch {
            print("Favori mekanlar getirilemedi: \(error.localizedDescription)")
            return []
        }
    }

    // Favori Mekan Silme
    func deleteFavoritePlace(_ place: FavoritePlace) {
        context.delete(place)
        saveContext()
    }

    // Core Data Kaydetme
    private func saveContext() {
        do {
            try context.save()
            print("Veriler başarıyla kaydedildi.")
        } catch {
            print("Veriler kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
    }
}
