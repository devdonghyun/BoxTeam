//
//  ContentView.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    
    @Environment(AppModel.self) private var appModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("안녕하세요")
                .font(.extraLargeTitle)
                .fontWeight(.bold)
            
            Text("앱 설명 텍스트")
                .font(.title)
                .foregroundColor(.secondary)
            
            Button {
                Task {
                    await createBoxAndOpenImmersiveSpace()
                }
            } label : {
                Text("박스 생성하기")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
            }
        }
        .frame(width: 1280, height: 720)
        .padding(60)
        .glassBackgroundEffect()
    }
    
    private func createBoxAndOpenImmersiveSpace() async {
            appModel.createProjectBox()
            
            guard appModel.immersiveSpaceState == .closed else {
                dismissWindow(id: appModel.mainWindowID)
                return
            }
            
            appModel.immersiveSpaceState = .inTransition
            
            let result = await openImmersiveSpace(id: appModel.immersiveSpaceID)
            
            switch result {
            case .opened:
                appModel.immersiveSpaceState = .open
                dismissWindow(id: appModel.mainWindowID)
                
            case .userCancelled, .error:
                appModel.immersiveSpaceState = .closed
                
            @unknown default:
                appModel.immersiveSpaceState = .closed
            }
        }
    
}


#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
