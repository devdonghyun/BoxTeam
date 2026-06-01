//
//  AppModel.swift
//  BoxTeam
//
//  Created by 안동현 on 5/29/26.
//

import SwiftUI

// 하나의 프로젝트 박스를 표현하는 데이터 구조체
// Identifiable을 채택하면 SwiftUI에서 이 데이터를 고유하게 구분할 수 있음
struct ProjectBoxData: Identifiable {
    
    // 각 박스를 구분하기 위한 고유 ID
    // UUID()는 매번 겹치지 않는 고유한 값을 만들어줌
    let id = UUID()
}

// 앱 전체에서 공유할 상태를 관리하는 클래스
// @MainActor: UI와 관련된 상태 변경이 메인 스레드에서 일어나도록 보장
// @Observable: SwiftUI View가 이 객체의 값 변화를 감지할 수 있게 해줌
@MainActor
@Observable
final class AppModel {
    
    // ImmersiveSpace를 열 때 사용할 ID
    // App 파일의 ImmersiveSpace(id:)와 같은 값이어야 함
    let immersiveSpaceID = "ImmersiveSpace"
    
    // Main Window를 닫을 때 사용할 ID
    // App 파일의 WindowGroup(id:)와 같은 값이어야 함
    let mainWindowID = "MainWindow"
    
    // MemoAddingView를 열고 닫을 때 사용할 ID
    let memoaddingID = "MemoAddingView"
    
    // ImmersiveSpace의 현재 상태를 표현하는 enum
    enum ImmersiveSpaceState {
        
        // 아직 ImmersiveSpace가 열리지 않은 상태
        case closed
        
        // ImmersiveSpace를 여는 중이거나 닫는 중인 상태
        case inTransition
        
        // ImmersiveSpace가 열린 상태
        case open
    }
    
    var isMemoAddingViewShown: Bool = false
    
    // 현재 ImmersiveSpace의 상태
    // 앱이 처음 시작될 때는 아직 열리지 않았으므로 closed
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    // 현재 생성된 프로젝트 박스 데이터
    // Optional(?)인 이유:
    // nil이면 아직 박스가 없음
    // 값이 있으면 박스가 하나 생성된 상태
    var projectBox: ProjectBoxData?
    
    // 프로젝트 박스를 생성하는 함수
    func createProjectBox() {
        
        // 이미 projectBox가 있으면 새로 만들지 않고 함수 종료
        // 지금은 박스를 하나만 만들 계획이기 때문
        guard projectBox == nil else { return }
        
        // 새로운 박스 데이터를 만들고 projectBox에 저장
        // 이 순간부터 projectBox는 nil이 아니게 됨
        projectBox = ProjectBoxData()
    }
    
    func deleteProjectBox() {
        projectBox = nil
    }
    
}
