//
//  HomeView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("FocusFlow")
                    .font(.largeTitle.bold())
                    .padding(.top, 40)
                    .foregroundColor(.paletteNavy)

                Spacer()

                NavigationLink(destination: ContentView()) {
                    HomeButtonView(title: "Tasks", systemImage: "list.bullet", color: .paletteSoftBlue)
                }
                
                NavigationLink(destination: PomodoroTimerView()) {
                    HomeButtonView(title: "Pomodoro Timer", systemImage: "clock.fill", color: .paletteVibrantRed)
                }
                
                NavigationLink(destination: CalendarView()) {
                    HomeButtonView(title: "Calendar", systemImage: "calendar", color: .paletteDeepRed)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
