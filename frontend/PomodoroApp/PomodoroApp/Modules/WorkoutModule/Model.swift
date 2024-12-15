import Foundation
import SwiftData

@Model
final class Workout {
    @Attribute(.unique) var id: UUID = UUID()
    var startTime: Date
    var endTime: Date?
    var exercises: [Exercise] = []

    init(startTime: Date, endTime: Date? = nil, exercises: [Exercise] = []) {
        self.startTime = startTime
        self.endTime = endTime
        self.exercises = exercises
    }
}

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var sets: [WorkoutSet] = []

    init(name: String, sets: [WorkoutSet] = []) {
        self.name = name
        self.sets = sets
    }
}

@Model
final class WorkoutSet {
    @Attribute(.unique) var id: UUID = UUID()
    var weightLifted: Double
    var repsCompleted: Int

    init(weightLifted: Double, repsCompleted: Int) {
        self.weightLifted = weightLifted
        self.repsCompleted = repsCompleted
    }
}
