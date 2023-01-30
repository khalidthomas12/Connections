//: [Previous](@previous)

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
