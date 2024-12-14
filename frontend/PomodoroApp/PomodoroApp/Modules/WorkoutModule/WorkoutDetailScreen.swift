import SwiftUI

struct WorkoutDetailScreen: View {
    let workout: Workout

    var body: some View {
        List {
            // Section for Workout Summary
            Section(header: Text("Summary")) {
                Text("Date: \(workout.startTime, style: .date)")
                    .font(.headline)

                if let endTime = workout.endTime {
                    Text("Duration: \(formatDuration(endTime.timeIntervalSince(workout.startTime)))")
                        .font(.headline)
                }
            }

            // Section for Exercises and Sets
            Section(header: Text("Exercises")) {
                ForEach(workout.exercises, id: \.name) { exercise in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(exercise.name)
                            .font(.headline)

                        ForEach(exercise.sets.indices, id: \.self) { setIndex in
                            HStack {
                                Text("Set \(setIndex + 1):")
                                Spacer()
                                Text("\(exercise.sets[setIndex].weightLifted, specifier: "%.1f") kg x \(exercise.sets[setIndex].repsCompleted) reps")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Workout Details")
        .listStyle(InsetGroupedListStyle()) // Use modern list styling
    }

    // Helper function to format workout duration
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct WorkoutDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        let exampleWorkout = Workout(
            startTime: Date(),
            endTime: Date().addingTimeInterval(3600),
            exercises: [
                Exercise(name: "Bench Press", sets: [WorkoutSet(weightLifted: 50, repsCompleted: 8), WorkoutSet(weightLifted: 55, repsCompleted: 6)]),
                Exercise(name: "Squats", sets: [WorkoutSet(weightLifted: 80, repsCompleted: 10)])
            ]
        )
        return WorkoutDetailScreen(workout: exampleWorkout)
    }
}
