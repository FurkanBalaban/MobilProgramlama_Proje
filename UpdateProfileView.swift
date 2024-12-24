import SwiftUI

struct UpdateProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var email: String
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Bilgilerimi Güncelle")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Yeni E-posta Adresi", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocapitalization(.none)

            SecureField("Yeni Şifre", text: $newPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            SecureField("Şifreyi Onayla", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

            Button(action: {
                if validateInputs() {
                    updateUser()
                } else {
                    showError = true
                }
            }) {
                Text("Güncelle")
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

    func validateInputs() -> Bool {
        if email.isEmpty {
            errorMessage = "E-posta alanı boş bırakılamaz."
            return false
        }

        if !newPassword.isEmpty && newPassword != confirmPassword {
            errorMessage = "Şifreler uyuşmuyor!"
            return false
        }

        return true
    }

    func updateUser() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rememberMe == YES")

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.email = email
                if !newPassword.isEmpty {
                    user.password = newPassword
                }
                try context.save()
                print("Kullanıcı bilgileri başarıyla güncellendi.")
                presentationMode.wrappedValue.dismiss() // Güncelleme sonrası kapat
            }
        } catch {
            errorMessage = "Kullanıcı güncellenemedi: \(error.localizedDescription)"
            showError = true
        }
    }
}

#Preview {
    UpdateProfileView(email: .constant("test@example.com"))
}
