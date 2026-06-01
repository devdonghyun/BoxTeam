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
    
    // 앱 전체에서 공유하는 상태값
    // 여기서는 appModel.projectBox가 있는지 확인해서
    // 박스를 실제 공간에 보여줄지 결정함
    @Environment(AppModel.self) private var appModel
    
    // 생성된 박스를 나중에 다시 접근하기 위해 저장하는 변수
    // 예: 드래그할 때 boxEntity의 위치를 바꾸기 위해 필요
    @State private var boxEntity: Entity?
    @State private var isMemoListVisible: Bool = false
    
    var body: some View {
        
        // visionOS 공간 안에 RealityKit 3D 콘텐츠를 배치하는 View
        RealityView { content, attachments in
            
            // projectBox가 nil이면 아직 박스 데이터가 생성되지 않은 상태
            // 따라서 realbox를 불러오지 않고 종료
            guard appModel.projectBox != nil else { return }
            
            do {
                // RealityKitContent 번들 안에 있는 "realbox" Entity를 불러옴
                // Reality Composer Pro에서 만든 오브젝트 이름과 같아야 함
                let boxEntity = try await Entity(
                    named: "realbox",
                    in: realityKitContentBundle
                )
                
                // 코드에서 이 Entity를 찾거나 구분할 때 사용할 이름
                boxEntity.name = "realbox"
                
                // 박스의 위치 설정
                // x: 좌우, y: 위아래, z: 앞뒤
                // z가 음수이면 사용자 앞쪽 방향
                boxEntity.position = [0, 1.2, -1]
                
                boxEntity.generateCollisionShapes(recursive: true)
                boxEntity.components.set(InputTargetComponent())
                
                // Immersive Space 안에 박스 Entity 추가
                // 이 순간부터 공간 안에 realbox가 보이게 됨
                content.add(boxEntity)
                
                if let memoListEntity = attachments.entity(for: "memoList") {
                    memoListEntity.position = [0, 0.4, 0]
                    boxEntity.addChild(memoListEntity)
                }
                
                if let boxControlEntity = attachments.entity(for: "boxControl") {
                    boxControlEntity.position = [0, -0.1, 0.1]
                    boxEntity.addChild(boxControlEntity)
                }
                
                self.boxEntity = boxEntity
                
            } catch {
                // realbox 이름이 틀렸거나,
                // RealityKitContent에 해당 Entity가 없으면 여기로 들어옴
                print("realbox 불러오기 실패:", error)
            }
        } attachments: {
            Attachment(id: "memoList") {
                MemoListView(isVisible: isMemoListVisible)
            }
            Attachment(id: "boxControl") {
                BoxControlView()
            }
        }
        .gesture(
            TapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    guard let boxEntity else { return }
                    
                    guard let animation = boxEntity.availableAnimations.first else {
                        return
                    }
                    
                    boxEntity.playAnimation(animation)
                    isMemoListVisible = true
                }
        )
        .gesture(
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    guard let boxEntity else { return }
                    
                    guard let parent = boxEntity.parent else {
                        return
                    }
                    
                    boxEntity.position = value.convert(
                        value.location3D,
                        from: .local,
                        to: parent
                    )
                }
        )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
