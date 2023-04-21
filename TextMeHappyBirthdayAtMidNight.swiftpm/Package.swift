// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "TextMeHappyBirthdayAtMidNight",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "TextMeHappyBirthdayAtMidNight",
            targets: ["AppModule"],
            bundleIdentifier: "kjs.test418-TimeDevelopmenet",
            teamIdentifier: "B5PRRNR42T",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .box),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)