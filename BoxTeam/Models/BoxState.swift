//
//  BoxState.swift
//  BrownEaredBulBul
//
//  Created by BK on 5/30/26.
//

import Foundation
import SwiftData

//박스 데이타 값 저장소: 박스의 위치, 앵커가 되었는지 저장 -> 박스의 마지막 위치만 받으면 됨
@Model
final class BoxState {
    @Attribute(.unique) var id: String
    var posX: Float
    var posY: Float
    var posZ: Float
    var isAnchored: Bool
    var worldAnchorIdentifier: String?
    
    var position: SIMD3<Float> {
        get {
            SIMD3<Float>(posX, posY, posZ)
        }
        set {
            posX = newValue.x
            posY = newValue.y
            posZ = newValue.z
        }
    }
    
    init(
        id: String = "main-box",
        posX: Float = 0,
        posY: Float = 1.2,
        posZ: Float = -1.5,
        isAnchored: Bool = false,
        worldAnchorIdentifier: String? = nil
        ){
            self.id = id
            self.posX = posX
            self.posY = posY
            self.posZ = posZ
            self.isAnchored = isAnchored
            self.worldAnchorIdentifier = worldAnchorIdentifier
        }
}

