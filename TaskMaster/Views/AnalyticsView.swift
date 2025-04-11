import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Weekly Progress")
                .font(.title.bold())

            Image(systemName: "chart.bar.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            Text("You completed 12 tasks this week!")
                .font(.headline)

            Spacer()
        }
        .padding()
        .navigationTitle("Analytics")
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}
