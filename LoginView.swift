import SwiftUI
import CoreData

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @State private var showForgotPassword = false
    @State private var showSignUp = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Akıllı Seyahat Asistanı")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            TextField("E-posta adresi", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocapitalization(.none)

            SecureField("Şifre", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button(action: {
                if validateLogin(email: email, password: password) {
                    isLoggedIn = true
                } else {
                    showError = true
                }
            }) {
                Text("Giriş Yap")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            .padding()

            // Şifremi Unuttum Butonu
            Button("Şifremi Unuttum") {
                showForgotPassword = true
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView() // Şifremi Unuttum Ekranı
            }

            // Kayıt Ol Butonu
            Button("Kayıt Ol") {
                showSignUp = true
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $showSignUp) {
                SignUpView() // Kayıt Ol Ekranı
            }
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Hata"),
                message: Text(errorMessage),
                dismissButton: .default(Text("Tamam"))
            )
        }
        .fullScreenCover(isPresented: $isLoggedIn) {
            ProfileView()
        }
    }

    func validateLogin(email: String, password: String) -> Bool {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                // Tüm kullanıcıların "rememberMe" değerini sıfırla
                resetRememberMe(context: context)

                // Giriş yapılan kullanıcıyı işaretle
                user.rememberMe = true
                try context.save()
                return true
            } else {
                errorMessage = "E-posta veya şifre hatalı!"
                return false
            }
        } catch {
            errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
            return false
        }
    }

    // Tüm kullanıcıların "rememberMe" değerini sıfırla
    func resetRememberMe(context: NSManagedObjectContext) {
        let fetchRequest = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                user.rememberMe = false
            }
            try context.save()
        } catch {
            print("RememberMe değerleri sıfırlanırken hata oluştu: \(error.localizedDescription)")
        }
    }

}

struct MainView: View {
    var body: some View {
        Text("Hoş Geldiniz! Bu ana ekran.")
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
}

#Preview {
    LoginView()
}
