//
//  MemoListView.swift
//  BoxTeam
//
//  Created by 안동현 on 5/30/26.
//

import SwiftUI

struct MemoListView: View {
    let isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모 리스트")
                .font(.title2)
                .fontWeight(.bold)
            
            Divider()
            
            Text("아직 메모가 없습니다")
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(20)
        .frame(width: 1280, height: 720)
        .glassBackgroundEffect()
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.3)
        .animation(.spring, value: isVisible)
    }
    
    
}
