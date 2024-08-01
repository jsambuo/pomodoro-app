//
//  User.swift
//  PomodoroApp
//
//  Created by Jason Wang on 8/1/24.
//

import Foundation

struct User: Identifiable, Codable {
	var id: UUID
	var name: String
	var email: String
	var avatar: String
}
