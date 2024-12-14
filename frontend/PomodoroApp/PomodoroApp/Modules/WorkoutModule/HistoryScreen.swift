import SwiftUI
import ModuleKit

struct HistoryScreen: View {
    @State private var workouts: [Workout] = []  // Simulates a storage system.
    @State private var isPresentingWorkoutSheet = false
    @State private var currentWorkout: Workout?

    var body: some View {
        NavigationStack {
            NavigationView {
                VStack {
                    if workouts.isEmpty {
                        Text("No Workouts Yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(workouts) { workout in
                            NavigationLink(destination: WorkoutDetailScreen(workout: workout)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Workout on \(workout.startTime, style: .date)")
                                        .font(.headline)
                                    Text("Exercises: \(workout.exercises.count)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Total Sets: \(workout.exercises.reduce(0) { $0 + $1.sets.count })")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    if let endTime = workout.endTime {
                                        Text("Duration: \(formatDuration(endTime.timeIntervalSince(workout.startTime)))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    Button("Start New Workout") {
                        currentWorkout = Workout(startTime: Date())  // Create a new workout.
                        isPresentingWorkoutSheet = true
                    }
                    .padding()
                }
                .navigationTitle("Workout History")
                .sheet(isPresented: $isPresentingWorkoutSheet) {
                    if let workout = currentWorkout {
                        RecordWorkoutScreen(workout: workout) { completedWorkout in
                            workouts.append(completedWorkout)  // Save the completed workout.
                            currentWorkout = nil
                            isPresentingWorkoutSheet = false
                        }
                    }
                }
            }
        }
    }

    // Helper function to format workout duration
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
    }
}
