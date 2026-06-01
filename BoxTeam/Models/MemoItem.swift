//
//  MemoItem.swift
//  BrownEaredBulBul
//
//  Created by BK on 5/30/26.
//

import Foundation
import SwiftUI
import SwiftData

// 메모 데이타값 저장소: 메모 내용, 색상인덱스(int), 공간에 존재 여부, 위치, 앵커여부, -> 위치가 SIMD3<Float> 가 아닐 경우 개별 처리 필요

@Model
final class MemoItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var text: String
    // Color를 Red, Green, Alpha로 나누어 저장
    var colorRed: Float
    var colorBlue: Float
    var colorGreen: Float
    var colorAlpha: Float
    
    var isSpatiallyPresented: Bool
    var spatialPosX: Float
    var spatialPosY: Float
    var spatialPosZ: Float

    var isSpatiallyAnchored: Bool
    var spatialWorldAnchorIdentifier: String?
    
    var color: Color {
        get {
            Color(
                red: Double(colorRed),
                green: Double(colorGreen),
                blue: Double(colorBlue),
                opacity: Double(colorAlpha)
            )
        }
        set {
            // UIColor/NSColor를 통해 컴포넌트 추출
            let uiColor = UIColor(newValue)
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        }
    }

    var spatialPosition: SIMD3<Float> {
            get {
                SIMD3<Float>(spatialPosX, spatialPosY, spatialPosZ)
            }
            set {
                spatialPosX = newValue.x
                spatialPosY = newValue.y
                spatialPosZ = newValue.z
            }
        }
    
    init(
        id: UUID = UUID(),
        name: String = "",
        text: String,
        color: Color,
        isSpatiallyPresented: Bool = false,
        spatialPosition: SIMD3<Float> = .zero,
        isSpatiallyAnchored: Bool = false,
        spatialWorldAnchorIdentifier: String? = nil
    ) {
        self.id = id
        self.name = name
        self.text = text
        
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.colorRed   = Float(r)
        self.colorGreen = Float(g)
        self.colorBlue  = Float(b)
        self.colorAlpha = Float(a)
        
        self.isSpatiallyPresented = isSpatiallyPresented
        self.spatialPosX = spatialPosition.x
        self.spatialPosY = spatialPosition.y
        self.spatialPosZ = spatialPosition.z
        self.isSpatiallyAnchored = isSpatiallyAnchored
        self.spatialWorldAnchorIdentifier = spatialWorldAnchorIdentifier
    }
    
}
