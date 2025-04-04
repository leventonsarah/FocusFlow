//
//  HomeButtonView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-04.
//

import Foundation
import SwiftUI

struct HomeButtonView: View {
    let title: String
    let systemImage: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .bold))
            Text(title)
                .font(.title2.bold())
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
