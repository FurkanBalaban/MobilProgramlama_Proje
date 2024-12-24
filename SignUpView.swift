//
//  SignUpView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

//
//  SignUpView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var rememberMe = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Kayıt Ol")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("E-posta adresi", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocapitalization(.none)

            SecureField("Şifre", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            SecureField("Şifreyi Onayla", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Toggle("Beni Hatırla", isOn: $rememberMe)
                .padding()

            Button(action: {
                if validateInputs() {
                    saveUserToCoreData()
                } else {
                    showError = true
                }
            }) {
                Text("Kayıt Ol")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Hata"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("Tamam"))
                )
            }

            Spacer()
        }
        .padding()
    }

    // Kullanıcı girişlerini kontrol et
    func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Tüm alanları doldurmanız gerekiyor."
            return false
        }

        if password != confirmPassword {
            errorMessage = "Şifreler uyuşmuyor!"
            return false
        }

        if !email.contains("@") {
            errorMessage = "Geçerli bir e-posta adresi girin."
            return false
        }

        return true
    }
    func saveUserToCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let newUser = User(context: context)
        newUser.email = email
        newUser.password = password
        newUser.rememberMe = true // Kullanıcı kaydı sırasında "rememberMe" değerini true olarak ayarla

        do {
            try context.save()
            print("Kayıt başarılı: \(email)")
        } catch {
            print("Kullanıcı kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
    }

}




#Preview {
    SignUpView()
}
