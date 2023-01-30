import UIKit
import SwiftUI
import Firebase

struct WorkoutPage: View {
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
                            let storageRef = Storage.storage().reference().child("workouts").child(workout.imageName)
                            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                                if let error = error {
                                    print("Error fetching image from Firebase Storage: \(error.localizedDescription)")
                                    return
                                }
                                if let data = data {
                                    self.workoutImage = UIImage(data: data)
                                }
                            }
                        }) {
                            Text("Fetch Image")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        let storageRef = Storage.storage().reference().child("workouts").child(UUID().uuidString)
                        if let imageData = workoutImage?.jpegData(compressionQuality: 0.75) {
                            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                                if let error = error {
                                    print("Error uploading image to Firebase Storage: \(error.localizedDescription)")
                                    return
                                }
                                storageRef.downloadURL { (url, error) in
                                    if let error = error {
                                        print("Error getting download URL: \(error.localizedDescription)")
                                        return
                                    }
                                    if let downloadURL = url {
                                        let workout = ["title": self.workoutTitle, "details": self.workoutDetails, "imageURL": downloadURL.absoluteString]
                                        let db = Firestore.firestore()
                                        db.collection("workouts").addDocument(data: workout) { (error) in
                                            if let error = error {
                                                print("Error saving workout data to Firebase: \(error.localizedDescription)")
                                            } else {
                                                print("Workout saved successfully!")
                                                self.workoutTitle = ""
                                                self.workoutDetails = ""
                                                self.workoutImage = nil
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }) {
                        Text("Save Workout")
                    }
                }
            }
            .navigationBarTitle("Add Workout")
        }
    }
}

