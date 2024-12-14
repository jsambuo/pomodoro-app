//
//  WorkoutModule.swift
//  PomodoroApp
//
//  Created by Jimmy on 12/14/24.
//

import Foundation
import ModuleKit

final class WorkoutModule: Module {
    var routes: [Route] {
        [
            Route(path: "/workout/history", handler: { _ in HistoryScreen() }),
            Route(path: "/workout/record", handler: { parameters in
                if let workout = parameters["workout"] as? Workout {
                    return RecordWorkoutScreen(workout: workout) {_ in }
                } else {
                    return RecordWorkoutScreen(workout: Workout(startTime: Date())) {_ in }
                }
            })
        ]
    }
    
    var actions: [Action] {
        []
    }
}
