//
//  AddPostView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 01.01.2025.
//

import SwiftUI

struct AddPostView: View {
    @State private var title: String = ""
    @State private var content: String = "" // 'body' yerine 'content' kullanıldı
    var onAdd: (Post) -> Void // Yeni post ekleme işlemini tetiklemek için closure
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yeni Gönderi Detayları")) {
                    TextField("Başlık", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextEditor(text: $content) // 'body' yerine 'content'
                        .frame(height: 150)
                        .border(Color.gray, width: 1)
                        .cornerRadius(8)
                        .padding(.vertical, 5)
                }
            }
            .navigationTitle("Yeni Gönderi Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss() // Görünümü kapatır
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        let newPost = Post(id: nil, title: title, content: content, userId: 1) // 'body' yerine 'content'
                        onAdd(newPost) // Post ekleme işlemini tetikle
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty) // Alanlar boşsa butonu devre dışı bırak
                }
            }
        }
    }
}

#Preview {
    AddPostView { _ in }
}
