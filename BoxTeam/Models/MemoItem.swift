//
//  MemoItem.swift
//  BrownEaredBulBul
//
//  Created by BK on 5/30/26.
//

import Foundation
import SwiftData

@Model
final class MemoItem {
    @Attribute(.unique) var id: UUID
    var text: String
    var colorIndex: Int
    
    var isSpatiallyPresented: Bool
    var spatialPosX: Float
    var spatialPosY: Float
    var spatialPosZ: Float

    var isSpatiallyAnchored: Bool
    var spatialWorldAnchorIdentifier: String?

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
        text: String,
        colorIndex: Int = 0,
        isSpatiallyPresented: Bool = false,
        spatialPosition: SIMD3<Float> = .zero,
        isSpatiallyAnchored: Bool = false,
        spatialWorldAnchorIdentifier: String? = nil
    ) {
        self.id = id
        self.text = text
        self.colorIndex = colorIndex
        self.isSpatiallyPresented = isSpatiallyPresented
        self.spatialPosX = spatialPosition.x
        self.spatialPosY = spatialPosition.y
        self.spatialPosZ = spatialPosition.z
        self.isSpatiallyAnchored = isSpatiallyAnchored
        self.spatialWorldAnchorIdentifier = spatialWorldAnchorIdentifier
    }
    
}
