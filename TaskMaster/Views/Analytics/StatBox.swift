//
//  StatBox.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-11.
//

import Foundation
import SwiftUI

struct StatBox: View {
    var title: String
    var value: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("\(value)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct StatBox_Previews: PreviewProvider {
    static var previews: some View {
        StatBox(title: "Completed Tasks", value: 10)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
