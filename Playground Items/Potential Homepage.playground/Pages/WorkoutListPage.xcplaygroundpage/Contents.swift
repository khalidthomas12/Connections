//: [Previous](@previous)

struct WorkoutListView: View {
    
    @ObservedObject var workoutData: WorkoutData
    
    var body: some View {
        NavigationView {
            List {
                ForEach(workoutData.workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        HStack {
                            Text(workout.name)
                            Spacer()
                            Text(workout.date)
                        }
                    }
                }
                .onDelete { indexSet in
                    self.workoutData.deleteWorkout(at: indexSet.first!)
                }
            }
            .navigationBarTitle("Workouts")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.workoutData.addWorkout()
                }) {
                    Image(systemName: "plus")
                }
            )
        }
    }
}

struct WorkoutDetailView: View {
    var workout: Workout
    var body: some View {
        VStack {
            Image(uiImage: workout.image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(workout.name)
                .font(.largeTitle)
            Text(workout.notes)
        }
    }
}

class WorkoutData: ObservableObject {
    @Published var workouts: [Workout]
    init() {
        // Your code to fetch workouts from Firebase goes here
    }
    func addWorkout() {
        // Your code to add a new workout to Firebase goes here
    }
    func deleteWorkout(at index: Int) {
        // Your code to delete a workout from Firebase goes here
    }
}

struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let date: String
    let image: UIImage?
    let notes: String
}
