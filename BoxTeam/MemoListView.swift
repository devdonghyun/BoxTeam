//
//  MemoListView.swift
//  BoxTeam
//
//  Created by 김상훈 on 5/31/26.
//

import SwiftUI
import SwiftData

// Test용 메모 데이터 클래스
class Memo: Identifiable{
    var name: String
    var color: Color
    var contents: String
    var anchor: Anchor<CGPoint>?
    
    init(name: String, contents: String, color: Color, anchor: Anchor<CGPoint>?){
        self.name = name
        self.color = color
        self.contents = contents
        self.anchor = anchor
    }
}

// Memo List Widow를 위한 SwiftUI 기반의 View
struct MemoListView: View {
    // Grid 구조
    let colums = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
    ]
    // Test용 메모 데이터
    /*@State var TestMemos: [Memo] = [
        Memo(
            name: "Test",
            contents: "This is a Test Memo",
            color: Color.red,
            anchor: nil
        ),
        Memo(
            name: "Test2",
            contents: "This is a Test Memo2",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test3",
            contents: "Hello, Nice to meet you! How are you today? I am vary happy to show you this memo. now I hope his Memo will appear as good!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test4",
            contents: "This is a TestMemo4",
            color: Color.green,
            anchor: nil
        ),
        Memo(
            name: "Test5",
            contents: "This is a TestMemo5",
            color: Color.orange,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.accentColor,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.cyan,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.brown,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.blue,
            anchor: nil
        ),
        Memo(
            name: "Test More",
            contents: "This is more Test Memo",
            color: Color.blue,
            anchor: nil
        )]*/
    @State var TestMemos: [Memo] = []
    
    var body: some View {
        VStack{
            // 상단 편집 버튼 목록
            HStack{
                // 닫기 버튼
                Button(action: {
                    print("닫기 액션")
                }){
                    Text("닫기")
                }
                .buttonStyle(.borderedProminent)
                .glassBackgroundEffect()
                
                Spacer()
                
                // 메모 추가 버튼
                Button(action: {
                    print("메모추가 액션")
                }){
                    Text("메모 추가")
                }
                .buttonStyle(.borderedProminent)
                .glassBackgroundEffect()
            }.padding()
            Spacer()
            if TestMemos.isEmpty {
                // 빈 메모 리스트 표시
                Text("작성된 메모가 없습니다.")
                Spacer()
            }else{
                // 메모 표시 구역, 스크롤뷰
                ScrollView{
                    // 메모 표시 구역, 그리드 뷰
                    LazyVGrid(columns: colums, spacing: 24){
                        ForEach(TestMemos){
                            NowMemo in MemoIconView(NowMemo: NowMemo)
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
    let NowMemo: Memo
    
    var body: some View{
        VStack{
            ZStack{
                Rectangle()
                    .frame(width: 190, height: 190)
                    .foregroundStyle(NowMemo.color)
                    .cornerRadius(25)
                VStack{
                    Spacer()
                    Text(NowMemo.contents)
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
