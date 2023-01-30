//: [Previous](@previous)

struct WorkoutForumView: View {
    
    @ObservedObject var workoutData: WorkoutData
    
    @State private var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(workoutData.posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.username)
                                .font(.headline)
                            Text(post.text)
                                .padding(.leading)
                        }
                    }
                }
                HStack {
                    TextField("Leave a comment", text: $text)
                    Button(action: {
                        self.workoutData.addPost(text: self.text)
                        self.text = ""
                    }) {
                        Image(systemName: "paperplane")
                            .padding(.trailing)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Forum")
        }
    }
}

class WorkoutData: ObservableObject {
    @Published var posts: [Post]
    init() {
        // Your code to fetch posts from Firebase goes here
    }
    func addPost(text: String) {
        // Your code to add a new post to Firebase goes here
    }
}

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let text: String
}
