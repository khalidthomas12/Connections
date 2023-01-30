//
//  ContentView.swift
//  Connection
//
//  Created by Khalid Thomas on 1/29/23.
//
import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @ObservedObject var workoutData: WorkoutData
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == "" {
            AuthView()
        } else {
            VStack{
                HomeScreen(workoutData: workoutData) 
                
                Button(action: {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        withAnimation {
                            userID = ""
                        }
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }) {
                    Text("Sign Out")
                }
                
            }
            
        }
    }
    
}
