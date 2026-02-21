import Combine
import Foundation

@MainActor
final class ClipboardHistoryStore: ObservableObject {
    @Published private(set) var items: [ClipboardItem] = []

    private let storageURL: URL?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(storageURL: URL? = ClipboardHistoryStore.defaultStorageURL()) {
        self.storageURL = storageURL
        load()
    }

    func capture(text: String, maxItems: Int) {
        let normalized = text.trimmingCharacters(in: .newlines)
        guard normalized.isEmpty == false else { return }

        if let existingIndex = items.firstIndex(where: { $0.text == text }) {
            items.remove(at: existingIndex)
        }

        items.insert(ClipboardItem(text: text), at: 0)
        enforceLimit(maxItems)
        persist()
    }

    func delete(id: UUID) {
        items.removeAll { $0.id == id }
        persist()
    }

    func clear() {
        items.removeAll()
        persist()
    }

    func enforceLimit(_ limit: Int) {
        guard limit > 0 else {
            items.removeAll()
            persist()
            return
        }

        if items.count > limit {
            items = Array(items.prefix(limit))
            persist()
        }
    }

    func filtered(by query: String) -> [ClipboardItem] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else {
            return items
        }

        return items.filter {
            $0.text.localizedCaseInsensitiveContains(trimmed)
        }
    }

    private func load() {
        guard let storageURL else { return }

        do {
            let data = try Data(contentsOf: storageURL)
            items = try decoder.decode([ClipboardItem].self, from: data)
        } catch {
            items = []
        }
    }

    private func persist() {
        guard let storageURL else { return }

        do {
            try FileManager.default.createDirectory(
                at: storageURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try encoder.encode(items)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            // 로컬 영속화 실패는 런타임 동작에 영향을 주지 않도록 무시한다.
        }
    }

    private static func defaultStorageURL() -> URL? {
        guard let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }

        return baseURL
            .appendingPathComponent("ClipboardApp", isDirectory: true)
            .appendingPathComponent("history.json")
    }
}
