//
//  BoxTeamApp.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI

@main
struct BoxTeamApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: appModel.mainWindowID) {
            ContentView()
                .environment(appModel)
        }
        .defaultSize(width: 1280, height: 720)
        .windowResizability(.contentSize)
        .windowStyle(.plain)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
