import SwiftUI

struct RecordWorkoutScreen: View {
    @State var workout: Workout
    @State private var newExerciseName: String = ""
    @State private var setInputs: [Int: (weight: String, reps: String)] = [:]
    @State private var elapsedTime: TimeInterval = 0
    @State private var editingExerciseIndex: Int? = nil
    @State private var editingExerciseName: String = ""
    @State private var editingSet: (exerciseIndex: Int, setIndex: Int)? = nil
    @State private var showAlert: Bool = false // Changed to alert
    let onComplete: (Workout) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Workout Duration: \(formattedElapsedTime)")
                .font(.headline)
                .padding()

            workoutList

            HStack {
                TextField("Exercise Name", text: $newExerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add Exercise") {
                    if !newExerciseName.isEmpty {
                        addExercise(name: newExerciseName)
                        newExerciseName = ""
                    }
                }
            }
            .padding()

            Button("Complete Workout") {
                showAlert = true // Trigger the alert
            }
            .padding()
            .alert("Complete Workout?", isPresented: $showAlert) {
                Button("Yes, Complete") {
                    completeWorkout()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to complete this workout?")
            }
        }
        .navigationTitle("Record Workout")
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    // MARK: - Workout List
    private var workoutList: some View {
        List {
            ForEach(workout.exercises.indices, id: \.self) { exerciseIndex in
                Section(header: exerciseHeader(for: exerciseIndex)) {
                    ForEach(workout.exercises[exerciseIndex].sets.indices, id: \.self) { setIndex in
                        setRow(for: exerciseIndex, setIndex: setIndex)
                    }
                    addSetInput(for: exerciseIndex)
                }
            }
        }
    }

    // MARK: - Exercise Header
    @ViewBuilder
    private func exerciseHeader(for exerciseIndex: Int) -> some View {
        HStack {
            if editingExerciseIndex == exerciseIndex {
                TextField("Exercise Name", text: $editingExerciseName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Save") {
                    saveEditedExercise(exerciseIndex: exerciseIndex)
                }
                .padding(.leading, 8)
            } else {
                Text(workout.exercises[exerciseIndex].name)
                    .font(.headline)

                Spacer()

                Button("Edit") {
                    beginEditingExercise(exerciseIndex: exerciseIndex)
                }
                .buttonStyle(.bordered)

                Button("Delete") {
                    removeExercise(at: exerciseIndex)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
        }
    }

    // MARK: - Set Row
    private func setRow(for exerciseIndex: Int, setIndex: Int) -> some View {
        HStack {
            if editingSet?.exerciseIndex == exerciseIndex && editingSet?.setIndex == setIndex {
                TextField(
                    "Weight (kg)",
                    text: Binding(
                        get: { "\(workout.exercises[exerciseIndex].sets[setIndex].weightLifted)" },
                        set: { value in
                            if let weight = Double(value) {
                                updateSetWeight(weight, exerciseIndex: exerciseIndex, setIndex: setIndex)
                            }
                        }
                    )
                )
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField(
                    "Reps",
                    text: Binding(
                        get: { "\(workout.exercises[exerciseIndex].sets[setIndex].repsCompleted)" },
                        set: { value in
                            if let reps = Int(value) {
                                updateSetReps(reps, exerciseIndex: exerciseIndex, setIndex: setIndex)
                            }
                        }
                    )
                )
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Save") {
                    editingSet = nil
                }
                .padding(.leading, 8)
            } else {
                Text("Weight: \(workout.exercises[exerciseIndex].sets[setIndex].weightLifted, specifier: "%.1f") kg")
                Spacer()
                Text("Reps: \(workout.exercises[exerciseIndex].sets[setIndex].repsCompleted)")
            }
        }
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive) {
                removeSet(at: setIndex, for: exerciseIndex)
            }
            .tint(.red)
            Button("Edit") {
                editingSet = (exerciseIndex, setIndex)
            }
            .tint(.blue)
        }
    }

    // MARK: - Add Set Input
    private func addSetInput(for exerciseIndex: Int) -> some View {
        HStack {
            TextField("Weight (kg)", text: Binding(
                get: { setInputs[exerciseIndex]?.weight ?? "" },
                set: { setInputs[exerciseIndex, default: ("", "")].weight = $0 }
            ))
            .keyboardType(.decimalPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Reps", text: Binding(
                get: { setInputs[exerciseIndex]?.reps ?? "" },
                set: { setInputs[exerciseIndex, default: ("", "")].reps = $0 }
            ))
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Add") {
                let weight = Double(setInputs[exerciseIndex]?.weight ?? "") ?? 0
                if let reps = Int(setInputs[exerciseIndex]?.reps ?? "") {
                    addSet(to: exerciseIndex, weight: weight, reps: reps)
                    setInputs[exerciseIndex] = nil // Clear input after adding
                }
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Helper Methods
    private func completeWorkout() {
        workout.endTime = Date()
        onComplete(workout)
        stopTimer()
        dismiss()
    }

    private func addExercise(name: String) {
        let newExercise = Exercise(name: name, sets: [])
        workout.exercises.append(newExercise)
    }

    private func beginEditingExercise(exerciseIndex: Int) {
        editingExerciseIndex = exerciseIndex
        editingExerciseName = workout.exercises[exerciseIndex].name
    }

    private func saveEditedExercise(exerciseIndex: Int) {
        guard editingExerciseIndex == exerciseIndex else { return }
        updateExerciseName(editingExerciseName, at: exerciseIndex)
        editingExerciseIndex = nil
    }

    private func updateExerciseName(_ name: String, at index: Int) {
        var updatedExercise = workout.exercises[index]
        updatedExercise = Exercise(name: name, sets: updatedExercise.sets)
        workout.exercises[index] = updatedExercise
    }

    private func removeExercise(at exerciseIndex: Int) {
        workout.exercises.remove(at: exerciseIndex)
    }

    private func updateSetWeight(_ weight: Double, exerciseIndex: Int, setIndex: Int) {
        var updatedExercise = workout.exercises[exerciseIndex]
        var updatedSet = updatedExercise.sets[setIndex]
        updatedSet = WorkoutSet(weightLifted: weight, repsCompleted: updatedSet.repsCompleted)
        updatedExercise.sets[setIndex] = updatedSet
        workout.exercises[exerciseIndex] = updatedExercise
    }

    private func updateSetReps(_ reps: Int, exerciseIndex: Int, setIndex: Int) {
        var updatedExercise = workout.exercises[exerciseIndex]
        var updatedSet = updatedExercise.sets[setIndex]
        updatedSet = WorkoutSet(weightLifted: updatedSet.weightLifted, repsCompleted: reps)
        updatedExercise.sets[setIndex] = updatedSet
        workout.exercises[exerciseIndex] = updatedExercise
    }

    private func addSet(to exerciseIndex: Int, weight: Double, reps: Int) {
        var updatedExercise = workout.exercises[exerciseIndex]
        updatedExercise.sets.append(WorkoutSet(weightLifted: weight, repsCompleted: reps))
        workout.exercises[exerciseIndex] = updatedExercise
    }

    private func removeSet(at setIndex: Int, for exerciseIndex: Int) {
        var updatedExercise = workout.exercises[exerciseIndex]
        updatedExercise.sets.remove(at: setIndex)
        workout.exercises[exerciseIndex] = updatedExercise
    }

    // MARK: - Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(workout.startTime)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private var formattedElapsedTime: String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
