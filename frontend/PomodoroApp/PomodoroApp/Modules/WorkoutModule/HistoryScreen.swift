import SwiftUI
import SwiftData

struct HistoryScreen: View {
    @Query private var workouts: [Workout]
    @Environment(\.modelContext) private var modelContext
    @State private var isPresentingWorkoutSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                if workouts.isEmpty {
                    Text("No Workouts Yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(workouts) { workout in
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
                            }
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                }

                Button("Start New Workout") {
                    isPresentingWorkoutSheet = true
                }
                .padding()
            }
            .navigationTitle("Workout History")
            .sheet(isPresented: $isPresentingWorkoutSheet) {
                recordWorkoutScreen()
            }
        }
    }

    // MARK: - Delete Workout
    private func deleteWorkout(at offsets: IndexSet) {
        for index in offsets {
            let workoutToDelete = workouts[index]
            modelContext.delete(workoutToDelete)
        }
    }

    private func recordWorkoutScreen() -> some View {
        let workout = Workout(startTime: Date())
        return RecordWorkoutScreen(workout: workout) { completedWorkout in
            saveWorkout(completedWorkout)
        }
    }

    private func saveWorkout(_ completedWorkout: Workout) {
        modelContext.insert(completedWorkout)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct HistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
            .modelContainer(try! ModelContainer(for: Workout.self, Exercise.self, WorkoutSet.self))
    }
}
