//
//  MemoListView.swift
//  BoxTeam
//
//  Created by 김상훈 on 5/31/26.
//

import SwiftUI
import SwiftData

// Memo List Widow를 위한 SwiftUI 기반의 View
struct MemoListView: View {
    // Grid 구조
    let colums = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
    ]
    
    // appModel 접근을 위한 Envijronment
    @Environment(AppModel.self) private var appModel
    // SwiftData 관리를 위한 modelContext
    @Environment(\.modelContext) private var modelContext
    // 추가적인 Window를 띄우기 위해 필요한 Environment
    @Environment(\.openWindow) var openWindow
    // 모든 메모 정보가 담겨있는 MemoItems를 Query
    @Query var MemoItems: [MemoItem]
    
    
    //선택버튼으로 삭제 모드 전환
    @State private var isSelectionMode = false
    @State private var selectedMemoIDs: Set<UUID> = []
    @State private var isMemoAddingStart: Bool = false
    
    // Adding 테스트용 메모
    @State var AddingTestMemo: MemoItem = MemoItem(
        name: "Test",
        text: "This is a adding memo test data.",
        color: Color.green,
    )
    
    var body: some View {
        VStack{
            // 상단 편집 버튼 목록
            HStack{
                if isSelectionMode {
                    Button(action: {
                        isSelectionMode = false
                        selectedMemoIDs.removeAll()
                        print("취소 액션")
                    }) {
                        Text("취소")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        for memo in MemoItems where selectedMemoIDs.contains(memo.id) {
                            modelContext.delete(memo)
                        }
                        selectedMemoIDs.removeAll()
                        isSelectionMode = false
                        print("삭제 액션")
                    }) {
                        Text("삭제")
                    }
                    .buttonStyle(.borderedProminent)
                    .glassBackgroundEffect()
                } else {
                    // 닫기 버튼
                    Button(action: {
                        print("닫기 액션")
                    }){
                        Text("닫기")
                    }
                    .buttonStyle(.borderedProminent)
                    .glassBackgroundEffect()
                    
                    Spacer()
                    
                    //선택 버튼
                    Button(action: {
                        isSelectionMode = true
                        print("선택 액션")
                    }) {
                        Text("선택")
                    }
                    
                    // 메모 추가 버튼(추가 버튼 클릭시 테스트 메모 하나 추가. 다시 한번 클릭시 추가된 메모가 삭제됨)
                    Button(action: {
                        print(appModel.isMemoAddingViewShown)
                        if !appModel.isMemoAddingViewShown {
                            openWindow(id: appModel.memoaddingID)
                            appModel.isMemoAddingViewShown = true
                        }
                        if MemoItems.isEmpty{
                            modelContext.insert(AddingTestMemo)
                            print("메모가 추가되었습니다. 메모 추가 버튼을 다시 한번 눌러 메모를 삭제할 수 있습니다.")
                        }else{
                            modelContext.delete(AddingTestMemo)
                            print("메모가 삭제되었습니다.")
                        }
                    }){
                        Text("메모 추가")
                    }
                    .buttonStyle(.borderedProminent)
                    .glassBackgroundEffect()
                }
            }.padding()
            Spacer()
            if MemoItems.isEmpty {
                // 빈 메모 리스트 표시
                Text("작성된 메모가 없습니다.")
                Spacer()
            }else{
                // 메모 표시 구역, 스크롤뷰
                ScrollView{
                    // 메모 표시 구역, 그리드 뷰
                    LazyVGrid(columns: colums, spacing: 24){
                        ForEach(MemoItems) { nowMemo in
                            MemoIconView(NowMemo: nowMemo)
                                .onTapGesture {
                                    guard isSelectionMode else { return }

                                    if selectedMemoIDs.contains(nowMemo.id) {
                                        selectedMemoIDs.remove(nowMemo.id)
                                    } else {
                                        selectedMemoIDs.insert(nowMemo.id)
                                    }
                                }
                        }
                    }.padding(.horizontal)
                }
            }
        }
        .frame(width: 920, height: 537)
        .glassBackgroundEffect()
        .padding()
    }
}

struct MemoIconView: View {
    let NowMemo: MemoItem
    
    var body: some View{
        VStack{
            ZStack{
                Rectangle()
                    .frame(width: 190, height: 190)
                    .foregroundStyle(NowMemo.color)
                    .cornerRadius(25)
                VStack{
                    Spacer()
                    Text(NowMemo.text)
                        .frame(width: 170, height: 170)
                        .foregroundStyle(Color.white)
                    Spacer()
                }
            }
            Text(NowMemo.name)
                .foregroundStyle(Color.white)
                .font(.headline)
        }
    }
}
