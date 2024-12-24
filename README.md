# MobilProgramlama_Proje
Mobil Programlama proje ödevidir 
# Akıllı Seyahat Asistanı

## Proje Hakkında
Akıllı Seyahat Asistanı, kullanıcıların seyahat planlarını organize etmelerini, favori mekanlarını saklamalarını ve kullanıcı dostu bir arayüz ile seyahatlerini daha keyifli hale getirmelerini sağlayan bir mobil uygulamadır. Uygulama, SwiftUI kullanılarak geliştirilmiştir ve CoreData ile veriler kalıcı olarak saklanmaktadır.

## Özellikler

### 1. Kullanıcı Giriş ve Kayıt İşlemleri
- Kullanıcılar, kayıt olabilir, giriş yapabilir ve şifrelerini sıfırlayabilir.
- Giriş yapan kullanıcıların bilgileri "Beni Hatırla" seçeneği ile CoreData üzerinden saklanmaktadır.

### 2. Profil Ekranı
- Kullanıcı bilgileri (e-posta) ve seyahat planları profil ekranında görüntülenmektedir.
- Kullanıcılar, profil bilgilerini güncelleyebilir ve hesaplarından çıkış yapabilir.
- Favori mekanlar ve seyahat planları bu ekrandan yönetilebilir.

### 3. Seyahat Planları
- Kullanıcılar seyahat planlarını ekleyebilir, listeleyebilir ve silebilir.
- Seyahat detayları ayrı bir ekranda görüntülenebilir.
- Tüm seyahat planları CoreData üzerinde saklanmaktadır.

### 4. Favori Mekanlar
- Kullanıcılar favori mekanlarını ekleyebilir, listeleyebilir ve silebilir.
- Favori mekanlar kullanıcı bilgileriyle ilişkilendirilmiştir (User-FavoritePlace).
- Mekan adı, lokasyon ve detay bilgileri kullanıcıdan alınarak kaydedilmektedir.

### 5. Tema Modu
- Kullanıcılar, Light ve Dark mod arasında geçiş yapabilir.
- Seçilen tema modu, UserDefaults ile saklanmaktadır ve uygulama yeniden açıldığında hatırlanır.

### 6. Hava Durumu Entegrasyonu
- OpenWeatherMap API kullanılarak kullanıcıya seyahat destinasyonlarına ait hava durumu bilgisi sağlanmaktadır.

## Teknik Detaylar

### Kullanılan Teknolojiler
- **SwiftUI**: Kullanıcı arayüzü tasarımı.
- **CoreData**: Kalıcı veri saklama.
- **UserDefaults**: Basit kullanıcı tercihlerini saklama.
- **OpenWeatherMap API**: Hava durumu verilerini sağlamak için.

### Veritabanı Yapısı
- **User Entity**:
  - `email`: Kullanıcı e-posta adresi.
  - `password`: Kullanıcı şifresi.
  - `rememberMe`: Kullanıcının giriş durumunu hatırlamak için.

- **FavoritePlace Entity**:
  - `name`: Mekan adı.
  - `location`: Mekan lokasyonu.
  - `details`: Mekan detayları.
  - `user`: Kullanıcı ile ilişki.

- **Trip Entity**:
  - `title`: Seyahat başlığı.
  - `destination`: Seyahat destinasyonu.
  - `startDate`: Başlangıç tarihi.
  - `endDate`: Bitiş tarihi.
  - `user`: Kullanıcı ile ilişki.

### Proje Mimarisi
- **Main Branch**: Çalışır durumdaki tüm özelliklerin birleştiği ana branch.
- **Develop Branch**: Tüm geliştirme branch'lerinin birleştirildiği branch.
- **Özellik Branch'leri**:
  - `develop-CoreData`: CoreData ile ilgili işlemler.
  - `develop-SwiftUI-Profil-FavoriMekan`: Favori mekanlar özelliği.
  - `develop-SwiftUI-Profil-FavoriMekan,develop-SwiftUI-Kullanıcı-İşlemleri`: UI geliştirmeleri (Profil, Tema Modu vb.).
  - `develop-WeatherAPI`: Hava durumu API entegrasyonu.
