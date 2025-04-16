//
//  SplashScreen.swift
//  TaskMaster
//
//  Created by YunXian Xu on 2025-04-15.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var isSplashFinished: Bool
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.8
    @State private var textOffset: CGFloat = 30

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.6, green: 0.4, blue: 0.8),
                Color(red: 0.8, green: 0.6, blue: 1.0),
                Color(red: 0.5, green: 0.3, blue: 0.7)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)

            ForEach(0..<5) { _ in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 50...200), height: CGFloat.random(in: 50...200))
                    .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -150...150))
            }

            VStack(spacing: 20) {
                Image("HomeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .shadow(color: Color(red: 0.3, green: 0.1, blue: 0.5, opacity: 0.5), radius: 20, x: 0, y: 10)
                    .opacity(opacity)
                    .scaleEffect(scale)

                VStack(spacing: 5) {
                    Text("Welcome")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                        .offset(y: textOffset)

                    Text("Focus Flow")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color(red: 0.3, green: 0.1, blue: 0.5), radius: 5, x: 0, y: 3)
                        .offset(y: textOffset)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4)) {
                opacity = 1.0
                scale = 1.05
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.0
                    textOffset = 0
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isSplashFinished = true
                }
            }
        }
    }
}


#Preview {
    SplashScreen(isSplashFinished:.constant(true))
}
