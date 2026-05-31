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
    
    // 드래그를 시작한 순간의 박스 위치를 저장하는 변수
    // 예: 박스가 갑자기 튀지 않게, 시작 위치를 기준으로 이동량을 계산하기 위해 필요
    @State private var initialPosition: SIMD3<Float>?
    
    // 현재 드래그 중인 realbox 저장
    @State private var draggedBox: Entity?
    
    
    
    var body: some View {
        
        // visionOS 공간 안에 RealityKit 3D 콘텐츠를 배치하는 View
        RealityView { content in
            
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
                
                
                // 박스 모델의 실제 형태를 기준으로 충돌 영역을 자동 생성
                // 이 영역이 있어야 사용자가 박스를 바라봤는지 RealityKit이 판단할 수 있음
                // 중요:
                // realbox 아래의 Cube, Sticker 같은 자식 Entity까지
                // 시선/핀치 감지를 가능하게 하기 위해 true 유지
                boxEntity.generateCollisionShapes(recursive: true)
                
                // 이 Entity가 사용자의 입력을 받을 수 있게 설정
                // 즉, 시선 + 핀치 + 드래그 제스처의 대상이 될 수 있게 함
                // realbox 전체를 입력 대상으로 등록
                boxEntity.components.set(
                    InputTargetComponent()
                )
                
                
                // Immersive Space 안에 박스 Entity 추가
                // 이 순간부터 공간 안에 realbox가 보이게 됨 // RealityView 공간 안에 박스를 실제로 추가
                content.add(boxEntity)
                
                // 방금 만든 박스를 @State 변수에 저장
                // 나중에 gesture 코드에서 이 박스를 다시 조작하기 위해 필요
                self.boxEntity = boxEntity
                
            } catch {
                // realbox 이름이 틀렸거나,
                // RealityKitContent에 해당 Entity가 없으면 여기로 들어옴
                print("realbox 불러오기 실패:", error)
            }
        }
        // RealityView에 제스처를 연결
        .gesture(
            // 사용자의 드래그 제스처를 감지
            DragGesture()
            // 아무 Entity가 아니라, 사용자가 바라보고 핀치한 Entity를 대상으로 드래그하게 함
                .targetedToAnyEntity()
            // 드래그 중일 때 계속 실행되는 코드
                .onChanged { value in

                    // 드래그 시작 시 realbox 찾기
                    if draggedBox == nil {
                        
                        var current: Entity? = value.entity
                        
                        while let entity = current {
                            
                            if entity.name == "realbox" {
                                
                                draggedBox = entity
                                initialPosition = entity.position
                                
                                break
                            }
                            current = entity.parent
                        }
                    }
                    guard let draggedBox else {return}
                    guard let parent = draggedBox.parent else {return}
                    let newPosition = value.convert(
                        value.location3D,
                        from: .local,
                        to: parent
                    )
                    draggedBox.position = newPosition
                }
                
                .onEnded { value in

                    initialPosition = nil
                    draggedBox = nil
                }
        )
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
