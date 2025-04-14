//
//  LoginView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-13.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var isUserLoggedIn: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Sign In")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Button(action: {
                        loginUser()
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: SignUpView(isUserLoggedIn: $isUserLoggedIn)) {
                        Text("Don't have an account? Sign up")
                            .foregroundColor(.blue)
                            .font(.footnote)
                    }
                    .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                guard let userId = result?.user.uid else { return }
                let db = Firestore.firestore()
                
                db.collection("users").document(userId).setData([
                    "email": email,
                    "lastLogin": Timestamp()
                ], merge: true)

                isUserLoggedIn = true
                errorMessage = ""
            }
        }
    }

}
