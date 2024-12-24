//
//  ProfileView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode // Çıkış yaparken ekranı kapatmak için
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        animation: .default)
    private var trips: FetchedResults<Trip> // Core Data'dan seyahat planları

    @State private var email: String = ""
    @State private var showUpdateForm = false // Profil güncelleme formunu açmak için toggle
    @State private var showAddTripForm = false // Yeni seyahat ekleme formu toggle
    @StateObject private var settingsManager = SettingsManager()
    @State private var favoritePlaces: [FavoritePlace] = []
    @State private var showAddFavoritePlaceForm = false
    var body: some View {
        NavigationView {
            ScrollView{ VStack(spacing: 20) {
                // Profil Başlığı
                Text("Profil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Kullanıcı Bilgileri
                Text("Hoş Geldiniz, \(email)")
                    .font(.title2)
                    .padding()
                
                // Seyahatlerim Bölümü
                Divider()
                Text("Seyahatlerim")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                if trips.isEmpty {
                    Text("Henüz bir seyahat planınız yok.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(trips) { trip in
                            NavigationLink(destination: TripDetailView(trip: trip)) {
                                VStack(alignment: .leading) {
                                    Text(trip.title ?? "Bilinmeyen Başlık")
                                        .font(.headline)
                                    Text(trip.destination ?? "Bilinmeyen Yer")
                                        .font(.subheadline)
                                    Text("Tarih: \(formattedDate(trip.startDate)) - \(formattedDate(trip.endDate))")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteTrips) // Seyahat silme
                    }
                    .frame(height: 300) // Listeyi sınırlı bir yükseklikte tut
                }
                // Favori Mekanlar Bölümü
                Divider()
                Text("Favori Mekanlar")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                if favoritePlaces.isEmpty {
                    Text("Henüz bir favori mekan eklenmedi.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(favoritePlaces, id: \.self) { place in
                        VStack(alignment: .leading) {
                            Text(place.name ?? "Bilinmeyen Mekan")
                                .font(.headline)
                            Text(place.location ?? "Bilinmeyen Lokasyon")
                                .font(.subheadline)
                            if let details = place.details {
                                Text(details)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(height: 200)
                }

                
                Spacer()
                //Tema Modu Seçimi
                Text("Tema Modu: \(settingsManager.themeMode)")
                    .font(.title2)
                
                Button(action: {
                    settingsManager.themeMode = "dark"
                }) {
                    Text("Dark Mode")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    settingsManager.themeMode = "light"
                }) {
                    Text("Light Mode")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
                
                // Yeni Seyahat Planı Ekleme Butonu
                Button(action: {
                    showAddTripForm = true
                }) {
                    Text("Yeni Seyahat Planı Ekle")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showAddTripForm) {
                    AddTripView() // Yeni seyahat ekleme ekranı
                }
                // Profil Güncelleme Butonu
                Button(action: {
                    showUpdateForm = true
                }) {
                    Text("Bilgilerimi Güncelle")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showUpdateForm) {
                    UpdateProfileView(email: $email)
                }
                Button(action: {
                    showAddFavoritePlaceForm = true
                }) {
                    Text("Favori Mekan Ekle")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showAddFavoritePlaceForm) {
                    AddFavoritePlaceView { name, location, details in
                        if let currentUser = CoreDataHelper.shared.fetchRememberedUser() {
                            CoreDataHelper.shared.addFavoritePlace(name: name, location: location, details: details, user: currentUser)
                            loadFavoritePlaces() // Listeyi güncelle
                        }
                    }
                }


                // Çıkış Yap Butonu
                Button(action: {
                    logout()
                }) {
                    Text("Çıkış Yap")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
                
            .padding()
            .background(settingsManager.themeMode == "dark" ? Color.black : Color.white)
            .foregroundColor(settingsManager.themeMode == "dark" ? Color.white : Color.black)
            .onAppear {
                loadUserInfo()
            }
            .navigationTitle("Profil")
            }
        }
    }

    // Kullanıcı bilgilerini yükleme
    func loadUserInfo() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rememberMe == YES") // Giriş yapılan kullanıcıyı getir

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                email = user.email ?? "Bilinmiyor"
            } else {
                email = "Kayıtlı kullanıcı bulunamadı"
            }
        } catch {
            print("Kullanıcı bilgileri alınamadı: \(error.localizedDescription)")
        }
    }

    // Tarih formatlama
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Tarih yok" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    // Seyahat silme
    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            offsets.map { trips[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Seyahat silinirken hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    func loadFavoritePlaces() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rememberMe == YES")
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                favoritePlaces = CoreDataHelper.shared.fetchFavoritePlaces(for: user)
            }
        } catch {
            print("Favori mekanlar yüklenirken hata oluştu: \(error.localizedDescription)")
        }
    }

    // Çıkış yapma işlemi
    func logout() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rememberMe == YES")

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.rememberMe = false // "Beni Hatırla" durumunu sıfırla
                try context.save()
                presentationMode.wrappedValue.dismiss() // Login ekranına dön
            }
        } catch {
            print("Çıkış işlemi sırasında hata oluştu: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ProfileView()
}
