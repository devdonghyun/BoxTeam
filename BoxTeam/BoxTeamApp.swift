//
//  BoxTeamApp.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI
import SwiftData

// 앱의 시작 지점
// @main이 붙은 App 구조체가 앱 실행 시 가장 먼저 실행됨
@main
struct BoxTeamApp: App {

    // 앱 전체에서 공유할 상태 객체
    // ContentView와 ImmersiveView가 같은 appModel을 바라보도록 여기서 한 번 생성함
    @State private var appModel = AppModel()

    var body: some Scene {
        
        // 일반 2D 창을 만드는 Scene
        // 앱을 실행했을 때 처음 보이는 ContentView 창
        WindowGroup(id: appModel.mainWindowID) {
            ContentView()
                // ContentView 안에서도 appModel을 사용할 수 있도록 전달
                .environment(appModel)
        }
        // 처음 열리는 창의 기본 크기 설정
        .defaultSize(width: 1280, height: 720)
        
        // 창 크기를 ContentView의 크기에 맞춤
        // 사용자가 마음대로 창 크기를 바꾸는 것을 제한하는 용도로 사용
        .windowResizability(.contentSize)
        
        // visionOS 기본 창 테두리/배경 스타일을 제거하고
        // ContentView에서 직접 만든 glassBackgroundEffect 등이 더 잘 보이게 함
        .windowStyle(.plain)

        //DataModel과 연결 - BK
        .modelContainer(for: [BoxState.self, MemoItem.self])

        // 3D 콘텐츠가 표시될 Immersive Space
        // openImmersiveSpace(id:)로 열 때 이 id와 일치해야 함
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                // ImmersiveView에서도 같은 appModel을 사용할 수 있도록 전달
                .environment(appModel)
                
                // ImmersiveView가 화면에 나타났을 때 실행
                // 즉, Immersive Space가 열린 상태로 기록
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                
                // ImmersiveView가 사라졌을 때 실행
                // 즉, Immersive Space가 닫힌 상태로 기록
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        // Immersive Space의 스타일 설정
        // .mixed는 현실 공간 passthrough 위에 3D 콘텐츠를 함께 보여주는 방식
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        //DataModel과 연결 - BK
        .modelContainer(for: [BoxState.self, MemoItem.self])

     }
}
