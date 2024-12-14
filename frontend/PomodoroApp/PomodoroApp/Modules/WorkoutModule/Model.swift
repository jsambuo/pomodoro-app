//
//  Model.swift
//  PomodoroApp
//
//  Created by Jimmy on 12/14/24.
//

import Foundation

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    var sets: [WorkoutSet] = []
}

struct WorkoutSet: Identifiable {
    let id = UUID()
    let weightLifted: Double
    let repsCompleted: Int
}

struct Workout: Identifiable {
    let id = UUID()
    let startTime: Date
    var endTime: Date? = nil
    var exercises: [Exercise] = []
}
