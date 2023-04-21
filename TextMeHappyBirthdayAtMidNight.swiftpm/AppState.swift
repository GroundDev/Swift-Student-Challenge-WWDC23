//
//  AppState.swift
//  TextMeHappyBirthdayAtMidNight
//
//  Created by KimJS on 2023/04/20.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var thisAppID = UUID()
}
