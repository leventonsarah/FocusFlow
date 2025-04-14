//
//  PriorityBreakdownView.swift
//  TaskMaster
//
//  Created by sarah leventon on 2025-04-11.
//

import Foundation
import SwiftUI

struct PriorityBreakdownView: View {
    var tasks: [Task]

    private var lowPriorityCount: Int {
        tasks.filter { $0.priority == 0 }.count
    }
    
    private var mediumPriorityCount: Int {
        tasks.filter { $0.priority == 1 }.count
    }
    
    private var highPriorityCount: Int {
        tasks.filter { $0.priority == 2 }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Task Priority Breakdown")
                .font(.title2)
                .bold()
            
            HStack {
                VStack {
                    Text("Low")
                        .font(.subheadline)
                    Text("\(lowPriorityCount)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(12)

                VStack {
                    Text("Medium")
                        .font(.subheadline)
                    Text("\(mediumPriorityCount)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.yellow)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(12)

                VStack {
                    Text("High")
                        .font(.subheadline)
                    Text("\(highPriorityCount)")
                        .font(.title)
                        .bold()
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.2))
                .cornerRadius(12)
            }
            .padding(.top)
        }
        .padding()
    }
}

