//
//  ForgotPasswordView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 21.12.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Şifremi Unuttum")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("E-posta adresinizi girin", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .autocapitalization(.none)

            Button(action: {
                print("Şifre sıfırlama e-postası gönderildi: \(email)")
            }) {
                Text("Şifre Sıfırla")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}


#Preview {
    ForgotPasswordView()
}
