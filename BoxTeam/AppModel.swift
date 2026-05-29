//
//  AppModel.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI


import SwiftUI

struct ProjectBoxData: Identifiable {
    let id = UUID()
}

@MainActor
@Observable
final class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    let mainWindowID = "MainWindow"
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    var projectBox: ProjectBoxData?
    
    func createProjectBox() {
        guard projectBox == nil else { return }
        projectBox = ProjectBoxData()
    }
}
