//
//  PostEditView.swift
//  Akilli_Seyahat_Asistani
//
//  Created by Furkan Balaban on 30.12.2024.
//

import SwiftUI

struct PostEditView: View {
    @Binding var post: Post // Düzenlenecek gönderiyi temsil eder
    var onSave: (Post) -> Void // Kaydetme işlemi tamamlandığında tetiklenecek closure
    @Environment(\.presentationMode) private var presentationMode // Görünüm kapatma işlemi için

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Detayları")) {
                    TextField("Başlık", text: $post.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    
                    TextEditor(text: $post.content) // 'body' yerine 'content' olarak güncellenmeli
                        .frame(height: 150)
                        .border(Color.gray, width: 1)
                        .padding(.vertical, 5)
                        .cornerRadius(8)
                }
            }

            .navigationTitle("Post Düzenle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss() // Görünümü kapat
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        onSave(post) // Kaydetme işlemini tetikle
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
#Preview {
    // Örnek bir gönderi ile test görünümü
    let samplePost = Post(id: 1, title: "Örnek Başlık", content: "Bu bir örnek post içeriğidir.", userId: 123)
    PostEditView(post: .constant(samplePost), onSave: { _ in })
}

