//
//  SignUpView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-13.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var isSignedUp = false

    @Binding var isUserLoggedIn: Bool

    var body: some View {
        VStack(spacing: 24) {
            Text("Create Account")
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

                SecureField("Confirm Password", text: $confirmPassword)
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
                    signUpUser()
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                NavigationLink(destination: LoginView(isUserLoggedIn: $isUserLoggedIn)) {
                    Text("Already have an account? Log in")
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

    func signUpUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                guard let userId = result?.user.uid else { return }
                let db = Firestore.firestore()
                
                db.collection("users").document(userId).setData([
                    "email": email,
                    "createdAt": Timestamp()
                ], merge: true)

                isUserLoggedIn = true
                errorMessage = ""
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isUserLoggedIn: .constant(false))
    }
}
