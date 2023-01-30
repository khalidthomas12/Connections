//
//  HomeScreen.swift
//  Connection
//
//  Created by Khalid Thomas on 1/29/23.
//

import SwiftUI
import UIKit
import Firebase


import SwiftUI
import Firebase

struct HomePage: View {
    @State private var selection = 0
    @ObservedObject var workoutData: WorkoutData
    
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
                    VStack {
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
                            // Your code to save workout data and image to Firebase goes here
                        }) {
                            Text("Save Workout")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5.0)
                                .shadow(radius: 5.0)
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: self.$image)
                    }
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
              self.$workoutData.addPost(username: username, text: newPostText)
                  }) {
                      Text("Post")
                  }
        .padding()
      }
    }
  }
    
}

    
class WorkoutData: ObservableObject {
    lazy var posts = [Post]()
    @State var username: String
    @State var text: String
    @State var newPostText = ""
    @ObservedObject var workoutData: WorkoutData
    
    init(username: String, text: String) {
        self.username = username
        self.text = text
        
        
    let db = Firestore.firestore()
    db.collection("posts").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
        print("Error fetching documents: \(error!)")
        return
        }
        self.posts = documents.map { document in
        let data = document.data()
        let username = data["username"] as? String ?? "Unknown"
        let text = data["text"] as? String ?? "No text"
        return Post(username: username, text: text)
            
        }
        
    }
            
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









    
struct Post: Identifiable {
    let id = UUID()
    let username: String
    let text: String
}


//
//struct HomeScreen: View {
//    @State private var search: String = ""
//    @State private var selectedIndex: Int = 1
//
//    private let categories = ["All", "Chair", "Sofa", "Lamp", "Kitchen", "Table"]
//
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1))
//                    .ignoresSafeArea()
//
//                ScrollView (showsIndicators: false) {
//                    VStack (alignment: .leading) {
//
//                        //AppBarView()
//
//                        TagLineView()
//                            .padding()
//
//                        SearchAndScanView(search: $search)
//
//                        ScrollView (.horizontal, showsIndicators: false) {
//                            HStack {
//                                ForEach(0 ..< categories.count) { i in
//                                    Button(action: {selectedIndex = i}) {
//                                        CategoryView(isActive: selectedIndex == i, text: categories[i])
//                                    }
//                                }
//                            }
//                            .padding()
//                        }
//
//                        Text("Recent Workouts")
//                            .font(.custom("PlayfairDisplay-Bold", size: 24))
//                            .padding(.horizontal)
//
//                        ScrollView (.horizontal, showsIndicators: false) {
//                            HStack (spacing: 0) {
//                                ForEach(0 ..< 4) { i in
//                                    NavigationLink(
//                                        destination: DetailScreen(),
//                                        label: {
//                                            ProductCardView(image: Image("chair_\(i+1)"), size: 210)
//                                        })
//                                        .navigationBarHidden(true)
//                                        .foregroundColor(.black)
//                                }
//                                .padding(.leading)
//                            }
//                        }
//                        .padding(.bottom)
//
//                        Text("Best")
//                            .font(.custom("PlayfairDisplay-Bold", size: 24))
//                            .padding(.horizontal)
//
//                        ScrollView (.horizontal, showsIndicators: false) {
//                            HStack (spacing: 0) {
//                                ForEach(0 ..< 4) { i in
//                                    ProductCardView(image: Image("chair_\(4-i)"), size: 180)
//                                }
//                                .padding(.leading)
//                            }
//                        }
//
//                    }
//                }
//
//                VStack {
//                    Spacer()
//                    BottomNavBarView()
//                }
//            }
//        }
////        .navigationBarTitle("") //this must be empty
////        .navigationBarHidden(true)
////        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct HomeScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreen()
//    }
//}
//
//
//// MARK: Potential AppBar
//
////struct AppBarView: View {
////    var body: some View {
////        HStack {
////            Button(action: {}) {
////                Image("menu")
////                    .padding()
////                    .background(Color.blue)
////                    .cornerRadius(10.0)
////            }
////
////            Spacer()
////
////            Button(action: {}) {
////                Image(systemName: "star")
////                    .resizable()
////                    .frame(width: 42, height: 42)
////                    .cornerRadius(10.0)
////            }
////        }
////        .padding(.horizontal)
////    }
////}
//
//struct TagLineView: View {
//    var body: some View {
//        Text("Find the \nBest ")
//            .font(.custom("PlayfairDisplay-Regular", size: 28))
//            .foregroundColor(Color("Primary"))
//            + Text("Furniture!")
//            .font(.custom("PlayfairDisplay-Bold", size: 28))
//            .fontWeight(.bold)
//            .foregroundColor(Color("Primary"))
//    }
//}
//
//struct SearchAndScanView: View {
//
//    @Binding var search: String
//
//    var body: some View {
//
//        HStack {
//            HStack {
//                Image("Search")
//                    .padding(.trailing, 8)
//                TextField("Search Furniture", text: $search)
//            }
//            .padding(.all, 20)
//            .background(Color.white)
//            .cornerRadius(10.0)
//            .padding(.trailing, 8)
//
//            Button(action: {}) {
//                Image("Scan")
//                    .padding()
//                    .background(Color("Primary"))
//                    .cornerRadius(10.0)
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//struct CategoryView: View {
//    let isActive: Bool
//    let text: String
//    var body: some View {
//        VStack (alignment: .leading, spacing: 0) {
//            Text(text)
//                .font(.system(size: 18))
//                .fontWeight(.medium)
//                .foregroundColor(isActive ? Color("Primary") : Color.black.opacity(0.5))
//            if (isActive) { Color("Primary")
//                .frame(width: 15, height: 2)
//                .clipShape(Capsule())
//            }
//        }
//        .padding(.trailing)
//    }
//}
//
//struct ProductCardView: View {
//    let image: Image
//    let size: CGFloat
//
//    var body: some View {
//        VStack {
//            image
//                .resizable()
//                .frame(width: size, height: 200 * (size/210))
//                .cornerRadius(20.0)
//            Text("Luxury Swedian chair").font(.title3).fontWeight(.bold)
//
//            HStack (spacing: 2) {
//                ForEach(0 ..< 5) { item in
//                    Image("star")
//                }
//                Spacer()
//                Text("$1299")
//                    .font(.title3)
//                    .fontWeight(.bold)
//            }
//        }
//        .frame(width: size)
//        .padding()
//        .background(Color.white)
//        .cornerRadius(20.0)
//
//    }
//}
//
//
//struct BottomNavBarView: View {
//    var body: some View {
//        HStack {
//            BottomNavBarItem(image: Image("Home"), action: {})
//            BottomNavBarItem(image: Image("fav"), action: {})
//            BottomNavBarItem(image: Image("shop"), action: {})
//            BottomNavBarItem(image: Image("User"), action: {})
//        }
//        .padding()
//        .background(Color.white)
//        .clipShape(Capsule())
//        .padding(.horizontal)
//        .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
//    }
//}
//
//struct BottomNavBarItem: View {
//    let image: Image
//    let action: () -> Void
//    var body: some View {
//        Button(action: action) {
//            image
//                .frame(maxWidth: .infinity)
//        }
//    }
//}
