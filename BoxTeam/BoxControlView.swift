//
//  BoxControlView.swift
//  BoxTeam
//
//  Created by 안동현 on 5/30/26.
//

import SwiftUI

struct BoxControlView: View {
    var body: some View {
        HStack(spacing: 16) {
            Button {
                print("고정 버튼 눌림")
            } label: {
                Image(systemName: "pin")
            }
            
            Button {
                print("홈 버튼 눌림")
            } label: {
                Image(systemName: "house")
            }
            
            Button {
                print("삭제 버튼 눌림")
            } label: {
                Image(systemName: "trash")
            }
        }
        .font(.title3)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .glassBackgroundEffect()
    }
}

#Preview {
    BoxControlView()
}
