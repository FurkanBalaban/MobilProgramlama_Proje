import SwiftUI

struct PostListView: View {
    @State private var posts: [Post] = [] // Post listesini tutar
    @State private var showAddPostView = false // Yeni post ekleme görünümünü kontrol eder
    @State private var showEditPostView = false // Post düzenleme görünümünü kontrol eder
    @State private var selectedPost: Post? = nil // Düzenlemek için seçilen post

    var body: some View {
        NavigationView {
            List {
                ForEach(posts) { post in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(post.title)
                            .font(.headline) // Post başlığı
                        Text(post.content) // 'body' yerine 'content'
                            .font(.subheadline) // Post içeriği
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedPost = post // Seçilen postu ayarla
                        showEditPostView = true // Düzenleme görünümünü göster
                    }
                }
                .onDelete(perform: deletePost) // Silme işlemini tetikler
            }

            .navigationTitle("Gönderiler")
            .navigationBarItems(trailing: Button(action: {
                showAddPostView = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $showAddPostView) {
            AddPostView { newPost in
                ApiService.shared.createPost(post: newPost) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let createdPost):
                            print("Yeni post eklendi: \(createdPost)")
                            // Yeni postu doğrudan listeye ekle
                            posts.append(createdPost)
                        case .failure(let error):
                            print("Post eklenirken hata oluştu: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }


        .sheet(item: $selectedPost) { post in
            PostEditView(post: .constant(post)) { updatedPost in
                ApiService.shared.updatePost(post: updatedPost) { _ in
                    fetchPosts() // Postları yeniden yükle
                }
            }
        }

        .onAppear {
            fetchPosts() // Görünüm yüklendiğinde postları getir
        }
    }

    private func fetchPosts() {
        ApiService.shared.fetchPosts { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedPosts):
                    posts = fetchedPosts
                case .failure(let error):
                    print("Postları yüklerken hata oluştu: \(error.localizedDescription)")
                }
            }
        }
    }

    private func deletePost(at offsets: IndexSet) {
        offsets.map { posts[$0] }.forEach { post in
            if let postId = post.id { // `id`nin var olup olmadığını kontrol et
                ApiService.shared.deletePost(id: postId) { success in
                    DispatchQueue.main.async {
                        if success {
                            fetchPosts() // Postları yeniden yükle
                        } else {
                            print("Post silinirken hata oluştu")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PostListView()
}
