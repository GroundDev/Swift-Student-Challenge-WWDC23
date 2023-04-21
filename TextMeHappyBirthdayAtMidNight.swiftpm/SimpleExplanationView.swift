//
//  SimpleExplanationView.swift
//  TextMeHappyBirthdayAtMidNight
//
//  Created by KimJS on 2023/04/20.
//

import SwiftUI

struct SimpleExplanationView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment:.leading ,spacing: 50) {
                Text("Text Me Happy Birthday🥳\nAt Midnight🌙!")
                    .font(.largeTitle)
                Group {
                    Text("Send birthday message at midnight").font(.headline)
                    + Text("(not yours!)").italic()
                }
                Text("This is a game which you send a birthday celebration message to a friend abroad at midnight by rotating the Earth by your hand! Feel free to be the God who control the time of this universe.")
                    .font(.body)
                Text("Make sure that the Earth in this game is seen from the North Pole, causing rotating counter-clockwise direction leads to the forward flow of time.")
                    .font(.footnote)
            }
        }
        .padding([.leading, .trailing], 100)
    }
}
