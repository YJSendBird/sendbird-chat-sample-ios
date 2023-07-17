//
//  Dependencies.swift
//  Config
//
//  Created by Ernest Hong on 2022/03/15.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/sendbird/sendbird-chat-sdk-ios", requirement: .upToNextMinor(from: "4.9.5")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMinor(from: "7.8.1")),
    ],
    platforms: [.iOS]
)
