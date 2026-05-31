//
//  AppDataStore.swift
//  BrownEaredBulBul
//
//  Created by BK on 5/30/26.
//

import Foundation
import SwiftData

@MainActor
final class AppDataStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    
    //박스
    
    func fetchBox() throws -> BoxState? {
        let descriptor = FetchDescriptor<BoxState>()
        return try modelContext.fetch(descriptor).first
    }

    func createBox() throws -> BoxState {
        if let box = try fetchBox() {
            return box
        }

        let box = BoxState()
        modelContext.insert(box)
        try modelContext.save()
        return box
    }

    func deleteBox() throws {
        guard let box = try fetchBox() else {
            return
        }

        modelContext.delete(box)
        try modelContext.save()
    }
    
    func saveBoxPosition(_ position: SIMD3<Float>) throws {
        guard let box = try fetchBox() else {
            return
        }

        box.position = position
        try modelContext.save()
    }

    func saveBoxAnchored(
        _ isAnchored: Bool,
        worldAnchorIdentifier: String? = nil
    ) throws {
        guard let box = try fetchBox() else {
            return
        }

        box.isAnchored = isAnchored
        box.worldAnchorIdentifier = worldAnchorIdentifier
        try modelContext.save()
    }
    
    
    //메모
    
    func fetchMemos() throws -> [MemoItem] {
        let descriptor = FetchDescriptor<MemoItem>()
        return try modelContext.fetch(descriptor)
    }
    
    func fetchMemo(id: UUID) throws -> MemoItem? {
        let descriptor = FetchDescriptor<MemoItem>(
            predicate: #Predicate { memo in
                memo.id == id
            }
        )

        return try modelContext.fetch(descriptor).first
    }

    func createMemo(
        text: String,
        colorIndex: Int = 0
    ) throws -> MemoItem {
        let memo = MemoItem(
            text: text,
            colorIndex: colorIndex
        )

        modelContext.insert(memo)
        try modelContext.save()

        return memo
    }

    func deleteMemo(id: UUID) throws {
        guard let memo = try fetchMemo(id: id) else {
            return
        }

        modelContext.delete(memo)
        try modelContext.save()
    }

    func presentMemo(
        id: UUID,
        at position: SIMD3<Float>
    ) throws {
        guard let memo = try fetchMemo(id: id) else {
            return
        }

        memo.isSpatiallyPresented = true
        memo.spatialPosition = position
        memo.isSpatiallyAnchored = false
        memo.spatialWorldAnchorIdentifier = nil

        try modelContext.save()
    }

    func saveMemoPosition(
        id: UUID,
        _ position: SIMD3<Float>
    ) throws {
        guard let memo = try fetchMemo(id: id) else {
            return
        }

        memo.spatialPosition = position
        try modelContext.save()
    }

    func closeMemo(id: UUID) throws {
        guard let memo = try fetchMemo(id: id) else {
            return
        }

        memo.isSpatiallyPresented = false
        memo.isSpatiallyAnchored = false
        memo.spatialWorldAnchorIdentifier = nil

        try modelContext.save()
    }

    func saveMemoAnchored(
        id: UUID,
        _ isAnchored: Bool,
        worldAnchorIdentifier: String? = nil
    ) throws {
        guard let memo = try fetchMemo(id: id) else {
            return
        }

        memo.isSpatiallyAnchored = isAnchored
        memo.spatialWorldAnchorIdentifier = worldAnchorIdentifier

        try modelContext.save()
    }
}

