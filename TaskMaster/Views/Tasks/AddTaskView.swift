import SwiftUI
import FirebaseAuth

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var priority = 1

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Task Title", text: $title)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                Picker("Priority", selection: $priority) {
                    Text("Low").tag(0)
                    Text("Medium").tag(1)
                    Text("High").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Button("Save Task") {
                    if let userId = Auth.auth().currentUser?.uid {
                        let newTask = Task(title: title, dueDate: dueDate, isCompleted: false, priority: priority, userId: userId)
                        viewModel.addTask(newTask)
                        dismiss()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Add New Task")
        .navigationBarBackButtonHidden(true)
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddTaskView(viewModel: TaskViewModel())
        }
    }
}
