//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)
class WorkoutData: ObservableObject {
    lazy var posts = [Post]()
    @State var username: String
    @State var post = [Post]
    @State var text: String
    @State var newPostText = ""
    @ObservedObject var workoutData: WorkoutData
    
    init(username: String, text: String) {
        self.username = username
        self.text = text
        
    }
    func addPost(username: String, text: String) {
        let db = Firestore.firestore()
        db.collection("posts").addDocument(data: [
            "username": username,
            "text": text
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added")
            }
        }
    }
}
