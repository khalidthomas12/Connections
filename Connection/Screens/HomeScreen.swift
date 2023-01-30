//
//  HomeScreen.swift
//  Connection
//
//  Created by Khalid Thomas on 1/29/23.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage



struct HomeScreen: View {
    
    @State private var selection = 0
    var workoutData: WorkoutData
    
    var body: some View {
        TabView(selection: $selection) {
            InputWorkoutView().tabItem {
                Image(systemName: "square.and.pencil")
                Text("Input Workout")
            }.tag(0)
            WorkoutsListView().tabItem {
                Image(systemName: "list.bullet")
                Text("Workouts List")
            }.tag(1)
            WorkoutForumView(workoutData: workoutData).tabItem {
                Image(systemName: "message")
                Text("Workout Forum")
            }.tag(2)
        }
    }
}

struct InputWorkoutView: View {
    
    @State private var workoutName = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 15) {
                HStack {
                    TextField("Workout Name", text: $workoutName)
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(5.0)
                        .shadow(radius: 5.0)
                    Button(action: {
                        self.showImagePicker.toggle()
                    }) {
                        Image(systemName: "camera")
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(5.0)
                            .shadow(radius: 5.0)
                    }
                }
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                Button(action: {
                    // Save workout data and image to Firebase
                    let workoutRef = db.collection("workouts").document()
                    let workoutID = workoutRef.documentID
                    workoutRef.setData([
                        "workoutName": workoutName,
                        "workoutID": workoutID
                    ]) { (error) in
                        if let error = error {
                            print("Error adding workout data: \(error)")
                        } else {
                            print("Workout data added with ID: \(workoutID)")
                        }
                    }
                    // Upload image to Firebase Storage
                    if let image = self.image {
                        let storageRef = Storage.storage().reference().child("workout_images/\(workoutID).jpg")
                        if let uploadData = image.jpegData(compressionQuality: 0.75) {
                            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                                if let error = error {
                                    print("Error uploading image: \(error)")
                                } else {
                                    print("Image uploaded successfully")
                                }
                            }
                        }
                    }
                }) {
                    Text("Save Workout")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5.0)
                        .shadow(radius: 5.0)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: self.$image)
                }
            }
            .padding()
        }
    }
    
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
    
    
struct WorkoutsListView: View {
    
    @State private var workoutTitle: String = ""
    @State private var workoutDetails: String = ""
    @State private var workoutImage: UIImage? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Workout Title", text: $workoutTitle)
                    TextField("Workout Details", text: $workoutDetails)
                }
                
                Section {
                    HStack {
                        Image(uiImage: workoutImage ?? UIImage(named: "placeholder")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                        Button(action: {
                            // Show image picker here to select an image
                        }) {
                            Text("Select Image")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Store the workout information and image in Firebase
                        // You can use the Firebase API to store the data, for example:
                        // Firebase.storeWorkout(title: self.workoutTitle, details: self.workoutDetails, image: self.workoutImage)
                        self.workoutTitle = ""
                        self.workoutDetails = ""
                        self.workoutImage = nil
                    }) {
                        Text("Save Workout")
                    }
                }
            }
            .navigationBarTitle("Add Workout")
        }
    }
}

    
    
struct WorkoutForumView: View {
    @ObservedObject var workoutData: WorkoutData
    @State private var newPostText = ""
    @State private var username = UserDefaults.standard.string(forKey: "currentUserUsername") ?? "anonymous"
    

  var body: some View {
    VStack {
      List {
        ForEach(workoutData.posts) { post in
          HStack {
            Image(systemName: "person.fill")
              .resizable()
              .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
              Text(post.username)
                .font(.headline)
              Text(post.text)
                .font(.body)
            }
          }
        }
      }
      .navigationBarTitle("Workout Forum")

      HStack {
          TextField("Add a post", text: $workoutData.newPostText)
          .padding()
          Button(action: {
              self.workoutData.addPost(text: self.newPostText)
                  }) {
                      Text("Post")
                  }
        .padding()
      }
    }
  }
    
}

    
class WorkoutData: ObservableObject {
    @Published var posts: [Post]
    @Published var currentUsername: String
    @Published var newPostText = ""

    init(posts: [Post], currentUsername: String) {
        self.posts = posts
        self.currentUsername = currentUsername
    }

    func addPost(text: String) {
        let post = Post(username: currentUsername, text: text)
        posts.append(post)
    }
}


    
struct Post: Identifiable {
    let id = UUID()
    let username: String
    let text: String
}


