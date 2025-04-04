import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                TaskRowView(title: "Finish Assignment", dueDate: Date(), isCompleted: false)
                TaskRowView(title: "Buy Groceries", dueDate: Date().addingTimeInterval(3600 * 5), isCompleted: true)
                TaskRowView(title: "Prepare Presentation", dueDate: Date().addingTimeInterval(86400), isCompleted: false)
            }
            .navigationTitle("TaskMaster")
            .toolbar {
                NavigationLink(destination: AddTaskView()) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct TaskRowView: View {
    let title: String
    let dueDate: Date
    let isCompleted: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text("Due: \(dueDate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? .green : .gray)
        }
        .padding(.vertical, 6)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
