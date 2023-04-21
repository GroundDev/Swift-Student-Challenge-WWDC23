//
//  JessicaInformationView.swift
//  test418-TimeDevelopmenet
//
//  Created by KimJS on 2023/04/20.
//

import SwiftUI

struct JessicaInformationView : View {
    var body: some View {
        List {
            Section("Name") {
                Text("Jessica")
                    .padding()
            }
            Section("Location") {
                HStack(spacing: 400) {
                    Text("Kuwait City, Kuwait")
                    Image("imageOfKuwait")
                        .resizable()
                        .scaledToFit()
                }
                .padding()
            }
            Section("Birthday") {
                Text("Jun 5")
                    .padding()
            }
        }
    }
}
