//
//  ContentView.swift
//  Connection
//
//  Created by Khalid Thomas on 1/29/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        
        if userID == "" {
            AuthView()
        } else {
            VStack{
                HomeScreen()
                
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

