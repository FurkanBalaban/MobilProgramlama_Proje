# Akıllı Seyahat Asistanı
#210201062 Furkan Balaban
## Proje Hakkında
Akıllı Seyahat Asistanı, kullanıcıların seyahat planlarını organize etmelerini, favori mekanlarını saklamalarını, AI destekli öneriler alabilmelerini ve kullanıcı dostu bir arayüz ile seyahatlerini daha keyifli hale getirmelerini sağlayan bir mobil uygulamadır. Uygulama, SwiftUI kullanılarak geliştirilmiştir ve CoreData ile veriler kalıcı olarak saklanmaktadır. Ayrıca RESTful API ve AI Cloud Servis entegrasyonları ile modern özellikler sunmaktadır.

## Özellikler

### 1. Kullanıcı Giriş ve Kayıt İşlemleri
- Kullanıcılar, kayıt olabilir, giriş yapabilir ve şifrelerini sıfırlayabilir.
- Giriş yapan kullanıcıların bilgileri "Beni Hatırla" seçeneği ile CoreData üzerinden saklanmaktadır.

### 2. Profil Ekranı
- Kullanıcı bilgileri (e-posta), seyahat planları ve favori mekanlar profil ekranında görüntülenmektedir.
- Kullanıcılar, profil bilgilerini güncelleyebilir ve hesaplarından çıkış yapabilir.
- Favori mekanlar ve seyahat planları bu ekrandan yönetilebilir.
- AI önerileri ve konum bilgisi gibi özellikler profil ekranına entegre edilmiştir.

### 3. Seyahat Planları
- Kullanıcılar seyahat planlarını ekleyebilir, listeleyebilir, güncelleyebilir ve silebilir.
- Seyahat detayları ayrı bir ekranda görüntülenebilir.
- Tüm seyahat planları CoreData üzerinde saklanmaktadır.

### 4. Favori Mekanlar
- Kullanıcılar favori mekanlarını ekleyebilir, listeleyebilir, güncelleyebilir ve silebilir.
- Favori mekanlar kullanıcı bilgileriyle ilişkilendirilmiştir (User-FavoritePlace).
- Mekan adı, lokasyon ve detay bilgileri kullanıcıdan alınarak kaydedilmektedir.

### 5. Tema Modu
- Kullanıcılar, Light ve Dark mod arasında geçiş yapabilir.
- Seçilen tema modu, UserDefaults ile saklanmaktadır ve uygulama yeniden açıldığında hatırlanır.

### 6. Hava Durumu Entegrasyonu
- OpenWeatherMap API kullanılarak kullanıcıya seyahat destinasyonlarına ait hava durumu bilgisi sağlanmaktadır.

### 7. Konum Servisleri
- Kullanıcının mevcut konum bilgisi CoreLocation kullanılarak alınır.
- Kullanıcının izin durumu dinamik olarak yönetilir ve hata durumları kullanıcıya iletilir.
- Konum bilgisi profil ekranında görüntülenebilir.

### 8. AI Seyahat Önerileri
- OpenAI API entegrasyonu ile kullanıcıya seyahat önerileri sunulmaktadır.
- Kullanıcıların ilgi alanlarına veya seyahat ihtiyaçlarına göre öneriler sunulur.
- Kullanıcılar bir butona basarak yeni öneriler alabilir.

### 9. RESTful API ile Post Yönetimi
- Kullanıcılar post ekleyebilir, listeleyebilir, güncelleyebilir ve silebilir.
- Postlar profil ekranında bir liste olarak görüntülenebilir.
- Post işlemleri RESTful API üzerinden gerçekleştirilir.

### 10. BLE ve Wi-Fi Entegrasyonu
- Bluetooth ve Wi-Fi bağlantıları uygulama içinde entegre edilmiştir.
- Seyahat sırasında yakındaki cihazlara veya bağlantılara erişim sağlanabilir.

## Teknik Detaylar

### Kullanılan Teknolojiler
- **SwiftUI**: Kullanıcı arayüzü tasarımı.
- **CoreData**: Kalıcı veri saklama.
- **UserDefaults**: Basit kullanıcı tercihlerini saklama.
- **OpenWeatherMap API**: Hava durumu verilerini sağlamak için.
- **OpenAI API**: Seyahat önerileri için AI entegrasyonu.
- **CoreLocation**: Konum servisleri.
- **BLE/Wi-Fi**: Bağlantı özellikleri.
- **RESTful API**: Post CRUD işlemleri.

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
- **Post Entity**:
  - `id`: Post ID.
  - `title`: Post başlığı.
  - `content`: Post içeriği.
  - `userId`: Kullanıcı ID'si.

## Proje Mimarisi
- **Main Branch**: Çalışır durumdaki tüm özelliklerin birleştiği ana branch.
- **Develop Branch**: Tüm geliştirme branch'lerinin birleştirildiği branch.
- **Özellik Branch'leri**:
  - `develop-coredata`: CoreData ile ilgili işlemler.
  - `develop-favorite-places`: Favori mekanlar özelliği.
  - `develop-ui`: UI geliştirmeleri (Profil, Tema Modu vb.).
  - `develop-weather-api`: Hava durumu API entegrasyonu.
  - `develop-ai`: OpenAI API entegrasyonu.
  - `develop-posts`: Post yönetimi.

## Gelecek Planlar
- **Push Notification**: Seyahat hatırlatmaları için bildirim sistemi.
- **Harita Entegrasyonu**: Konum bazlı mekan ve seyahat planlama.
- **Daha Gelişmiş AI Kullanımı**: Kullanıcı geçmişine dayalı seyahat önerileri.

## Kurulum
1. Projeyi klonlayın:
   ```bash
   git clone https://github.com/FurkanBalaban/AkilliSeyahatAsistani.git
