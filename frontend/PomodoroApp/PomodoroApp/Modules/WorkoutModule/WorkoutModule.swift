import SwiftData
import Foundation
import ModuleKit

final class WorkoutModule: Module {
    // Define the ModelContainer here
    private let modelContainer: ModelContainer = {
        try! ModelContainer(for: Workout.self, Exercise.self, WorkoutSet.self)
    }()

    var routes: [Route] {
        [
            Route(path: "/workout/history", handler: { _ in
                HistoryScreen()
                    .modelContainer(self.modelContainer)
            }),
            Route(path: "/workout/record", handler: { parameters in
                let workout = parameters["workout"] as? Workout ?? Workout(startTime: Date())
                return RecordWorkoutScreen(workout: workout) { _ in }
                    .modelContainer(self.modelContainer)
            })
        ]
    }

    var actions: [Action] {
        []
    }
}
