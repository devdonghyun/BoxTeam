//
//  ContentView.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI
import RealityKit
import RealityKitContent
import SwiftData

struct ContentView: View {
    
    // Immersive Space를 열기 위해 SwiftUI 환경에서 가져오는 기능
    // 예: openImmersiveSpace(id: "ImmersiveSpace")
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    // 특정 WindowGroup 창을 닫기 위해 SwiftUI 환경에서 가져오는 기능
    // 예: dismissWindow(id: "MainWindow")
    @Environment(\.dismissWindow) private var dismissWindow
    
    // 앱 전체에서 공유하는 상태값
    // AppModel 안에는 immersiveSpaceID, mainWindowID, 박스 데이터 등이 들어있음
    @Environment(AppModel.self) private var appModel
    
    //swift데이타 저장 도구 - BK
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 앱 시작 화면에 보여줄 메인 문구
            Text("안녕하세요")
                .font(.extraLargeTitle)
                .fontWeight(.bold)
            
            // 앱 설명 문구
            Text("앱 설명 텍스트")
                .font(.title)
                .foregroundColor(.secondary)
            
            // 박스 생성 버튼
            Button {
                // 버튼 action 안에서는 바로 await를 쓸 수 없기 때문에
                // Task로 비동기 작업을 감싸서 실행함
                Task {
                    await createBoxAndOpenImmersiveSpace()
                }
            } label: {
                Text("박스 생성하기")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
            }
        }
        // ContentView 창의 크기 설정
        .frame(width: 1280, height: 720)
        
        // 창 안쪽 여백
        .padding(60)
        
        // visionOS의 유리 느낌 배경 효과
        .glassBackgroundEffect()
    }
    
    // 박스를 만들고 Immersive Space를 여는 함수
    // openImmersiveSpace는 비동기 함수이기 때문에 async가 필요함
    private func createBoxAndOpenImmersiveSpace() async {
        let dataStore = AppDataStore(modelContext: modelContext)
        
        do {
                try dataStore.createBox()
                appModel.createProjectBox()
            } catch {
                print("박스 저장 실패:", error)
                return
            }
        
        // Immersive Space가 이미 열려 있지 않은 경우에만 새로 열기 위해 검사함
        // 이미 열려 있다면 다시 열 필요가 없으므로 MainWindow만 닫고 종료
        guard appModel.immersiveSpaceState == .closed else {
            dismissWindow(id: appModel.mainWindowID)
            return
        }
        
        // 지금 Immersive Space를 여는 중이라는 상태로 변경
        // 중복으로 여는 것을 막기 위한 중간 상태
        appModel.immersiveSpaceState = .inTransition
        
        // AppModel에 저장된 immersiveSpaceID를 사용해서 Immersive Space 열기
        let result = await openImmersiveSpace(id: appModel.immersiveSpaceID)
        
        // Immersive Space를 열려고 시도한 결과에 따라 상태 처리
        switch result {
            
        case .opened:
            // Immersive Space가 정상적으로 열렸을 때
            appModel.immersiveSpaceState = .open
            
            // 이제 시작 창은 필요 없으므로 MainWindow 닫기
            dismissWindow(id: appModel.mainWindowID)
            
        case .userCancelled, .error:
            // 사용자가 열기를 취소했거나, 에러가 발생한 경우
            // 다시 닫힌 상태로 되돌림
            appModel.immersiveSpaceState = .closed
            
        @unknown default:
            // 나중에 Apple이 새로운 결과 케이스를 추가할 수도 있으므로
            // 알 수 없는 경우에도 안전하게 closed 상태로 처리
            appModel.immersiveSpaceState = .closed
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
