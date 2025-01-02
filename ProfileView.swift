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
        entity: Trip.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Trip.startDate, ascending: true)],
        predicate: NSPredicate(format: "user.email == %@", UserDefaults.standard.string(forKey: "currentUserEmail") ?? "")
    ) private var trips: FetchedResults<Trip>
    
    @State private var posts: [Post] = [] // API'den gelen postlar
    @State private var isLoading = false
    @State private var email: String = ""
    @State private var showUpdateForm = false // Profil güncelleme formunu açmak için toggle
    @State private var showAddTripForm = false // Yeni seyahat ekleme formu toggle
    @StateObject private var settingsManager = SettingsManager()
    @State private var favoritePlaces: [FavoritePlace] = []
    @State private var showAddFavoritePlaceForm = false
    @State private var weatherResponse: WeatherResponse? // Hava durumu bilgisi
    @State private var errorMessage: String? // Hata mesajı
    private let weatherService = WeatherService() // WeatherService örneği
    @State private var showPostList = false
    @State private var showAddPostView = false
    @StateObject private var locationManager = LocationManager()
    @State private var recommendation: String = "AI önerisi yükleniyor..."
    private let aiService = AIService()
    
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Profil")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Kullanıcı Bilgileri
                    Text("Hoş Geldiniz, \(email)")
                        .font(.title2)
                        .padding()
                    
                    // Hava Durumu Bilgisi
                    Divider()
                    Text("Hava Durumu")
                        .font(.title2)
                        .fontWeight(.semibold)
                    if let weather = weatherResponse {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Sıcaklık: \(weather.main.temp, specifier: "%.1f")°C")
                            Text("Hissedilen Sıcaklık: \(weather.main.feels_like, specifier: "%.1f")°C")
                            Text("Durum: \(weather.weather.first?.description.capitalized ?? "Bilinmiyor")")
                        }
                        .padding()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        Text("Hava durumu yükleniyor...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    // Konum Bilgisi
                    Divider()
                    Text("Konum Bilgisi")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let location = locationManager.currentLocation {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Enlem: \(location.latitude)")
                            Text("Boylam: \(location.longitude)")
                        }
                        .padding()
                    } else if let locationError = locationManager.locationError {
                        Text("Hata: \(locationError)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("Konum bilgisi alınıyor...")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    Button(action: {
                        locationManager.checkAuthorizationStatus()
                    }) {
                        Text("Konumu Güncelle")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Text("AI Seyahat Önerisi")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(recommendation)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                    
                    Button(action: fetchRecommendation) {
                        Text("Yeni Öneri Al")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
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
                    
                    
                    
                    // Post Ekleme Butonu
                    Button(action: {
                        showAddPostView = true
                    }) {
                        Text("Post Ekle")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showAddPostView) {
                        AddPostView { newPost in
                            ApiService.shared.createPost(post: newPost) { _ in
                                fetchPosts() // Postları yeniden yükle
                            }
                        }
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
                    
                    // Tema Modu Seçimi
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
                    
                    // Favori Mekan Ekleme Butonu
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
                    Button(action: {
                        showPostList = true
                    }) {
                        Text("Postları Yönet")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showPostList) {
                        PostListView()
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
                    locationManager.requestPermission() // Konum izni iste
                    locationManager.checkAuthorizationStatus()
                    fetchWeather() // Hava durumu bilgisini yükle
                    fetchPosts() // Postları yükle
                    loadFavoritePlaces()
                }
                .navigationTitle("Profil")
            }
        }
    }
    
    // Kullanıcı Bilgilerini Yükle
    func loadUserInfo() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = User.fetchRequest()
        
        if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
            fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
        } else {
            email = "Kullanıcı bulunamadı"
            return
        }
        
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
    
    // Favori mekanları yükle
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
    
    // Postları yükle
    private func fetchPosts() {
        isLoading = true
        ApiService().fetchPosts { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let posts):
                    self.posts = posts
                case .failure(let error):
                    self.errorMessage = "Postlar yüklenirken hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    
    // Çıkış yapma işlemi
    func logout() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = User.fetchRequest()
        
        if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
            fetchRequest.predicate = NSPredicate(format: "email == %@", currentUserEmail)
            
            do {
                let users = try context.fetch(fetchRequest)
                if let user = users.first {
                    user.rememberMe = false // RememberMe durumunu sıfırla
                    try context.save()
                    UserDefaults.standard.removeObject(forKey: "currentUserEmail") // Kullanıcı bilgilerini temizle
                    presentationMode.wrappedValue.dismiss() // Login ekranına dön
                }
            } catch {
                print("Çıkış işlemi sırasında hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    
    // Hava durumu bilgisini yükleme
    func fetchWeather() {
        let city = "Istanbul" // Burayı dinamik olarak seyahat destinasyonundan alabilirsiniz
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.weatherResponse = response
                case .failure(let error):
                    self.errorMessage = "Hava durumu alınamadı: \(error.localizedDescription)"
                }
            }
        }
    }
    private func fetchRecommendation() {
        let prompt = "Istanbul'da önerilecek en iyi 3 turistik mekan nedir?"
        aiService.generateRecommendation(prompt: prompt) { result in
            DispatchQueue.main.async {
                self.recommendation = result ?? "Bir hata oluştu. Lütfen tekrar deneyin."
            }
        }
    }
}

#Preview {
    ProfileView()
}
