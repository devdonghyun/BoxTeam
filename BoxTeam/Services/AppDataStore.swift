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

    func fetchBox() throws -> BoxState? {
        let descriptor = FetchDescriptor<BoxState>()
        return try modelContext.fetch(descriptor).first
    }

    func createBoxIfNeeded() throws -> BoxState {
        if let box = try fetchBox() {
            return box
        }

        let box = BoxState()
        modelContext.insert(box)
        try modelContext.save()
        return box
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

}
