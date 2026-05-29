//
//  ImmersiveView.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        RealityView { content in
            guard appModel.projectBox != nil else { return }
            
            do {
                let boxEntity = try await Entity(
                    named: "realbox",
                    in: realityKitContentBundle
                )
                
                boxEntity.name = "realbox"
                boxEntity.position = [0, 1.2, -1]
                
                content.add(boxEntity)
                
            } catch {
                print("realbox 불러오기 실패:", error)
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
