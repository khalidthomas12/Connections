import SwiftUI
import Firebase

struct HomePage: View {
    @State private var selection = 0
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
            WorkoutForumView().tabItem {
                Image(systemName: "message")
                Text("Workout Forum")
            }.tag(2)
        }
    }
}

struct InputWorkoutView: View {
    var body: some View {
        // Your code to input a workout and upload a photo goes here
    }
}

struct WorkoutsListView: View {
    var body: some View {
        // Your code to retrieve and display workout data and images from Firebase goes here
    }
}

struct WorkoutForumView: View {
    var body: some View {
        // Your code to display a workout forum goes here
    }
}
