//
//  MemoAddingView.swift
//  BoxTeam
//
//  Created by 김상훈 on 5/31/26.
//

import Foundation
import SwiftUI

struct MemoAddingView: View {
    // appModel 접근을 위한 Environment
    @Environment(AppModel.self) private var appModel
    // Window를 닫기 위한 Environment
    @Environment(\.dismissWindow) var dismissWindow
    // Window가 X버튼으로 닫히는 것을 감지하기 위한 Environment
    @Environment(\.scenePhase) var scenePhase
    
    @State private var ColorSet: [Color] = [Color.black, Color.blue, Color.green, Color.red]
    @State private var ColorIndex: Int = 3
    @State private var InputText: String = ""
    
    var body: some View {
        VStack{
            // 상단 제어바
            HStack{
                // 창 닫기 버튼
                Button("닫기") {
                    appModel.isMemoAddingViewShown = false  // 상태 초기화
                    dismissWindow(id: appModel.memoaddingID)    // Window 닫기
                }
                .glassBackgroundEffect()
                Spacer()
                // Window title
                Text("메모 작성하기")
                    .font(.title)
                    .foregroundStyle(Color.white)
                    .bold()
                Spacer()
                // 메모 작성 완료 및 메모 추가 버튼
                Button("완료"){
                    print("완료 메시지")
                }
                .glassBackgroundEffect()
            }
            ZStack{
                Rectangle()
                    .frame(width: 400, height: 400)
                    .foregroundStyle(ColorSet[ColorIndex])
                    .cornerRadius(16)
                VStack{
                    TextField("내용을 입력해 주세요.", text: $InputText)
                        .frame(width: 380, height: 380)
                        .foregroundStyle(Color.white)
                }
            }
            HStack{
                ForEach(ColorSet.indices, id: \.self){ index in
                    let isSelected = (index == ColorIndex)
                    
                    Button{
                        ColorIndex = index
                    } label: {
                        ZStack{
                            if isSelected{
                                Circle()
                                    .foregroundStyle(ColorSet[index])
                                    .frame(height: 42)
                                Circle()
                                    .foregroundStyle(Color.white)
                                    .frame(height: 38)
                            }
                            Circle()
                                .foregroundStyle(ColorSet[index])
                                .frame(height: 34)
                        }
                    }
                    .buttonBorderShape(.circle)
                }
            }
            
        }
        .padding(.horizontal)
        // Window가 닫힌뒤 다시 열릴 수 있도록 중복 확인 변수 수정
        .onChange(of: scenePhase){ _, newPhase in
            if newPhase == .background {
                appModel.isMemoAddingViewShown = false
            }
        }
    }
}
