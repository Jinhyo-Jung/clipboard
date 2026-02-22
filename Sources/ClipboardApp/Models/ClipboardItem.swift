import Foundation

enum ClipboardItemKind: String, Codable {
    case text
    case image
}

struct ClipboardItem: Identifiable, Codable, Hashable {
    let id: UUID
    let kind: ClipboardItemKind
    let text: String?
    let imagePNGData: Data?
    let imageSignature: String?
    let sourceLabel: String?
    let copiedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case kind
        case text
        case imagePNGData
        case imageSignature
        case sourceLabel
        case copiedAt
    }

    init(
        id: UUID = UUID(),
        kind: ClipboardItemKind,
        text: String?,
        imagePNGData: Data?,
        imageSignature: String?,
        sourceLabel: String?,
        copiedAt: Date = Date()
    ) {
        self.id = id
        self.kind = kind
        self.text = text
        self.imagePNGData = imagePNGData
        self.imageSignature = imageSignature
        self.sourceLabel = sourceLabel
        self.copiedAt = copiedAt
    }

    static func text(_ value: String, copiedAt: Date = Date()) -> ClipboardItem {
        ClipboardItem(
            kind: .text,
            text: value,
            imagePNGData: nil,
            imageSignature: nil,
            sourceLabel: nil,
            copiedAt: copiedAt
        )
    }

    static func image(
        pngData: Data,
        signature: String,
        sourceLabel: String?,
        copiedAt: Date = Date()
    ) -> ClipboardItem {
        ClipboardItem(
            kind: .image,
            text: nil,
            imagePNGData: pngData,
            imageSignature: signature,
            sourceLabel: sourceLabel,
            copiedAt: copiedAt
        )
    }

    var preview: String {
        switch kind {
        case .text:
            let trimmed = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? "(빈 텍스트)" : trimmed
        case .image:
            if let sourceLabel, sourceLabel.isEmpty == false {
                return "이미지 · \(sourceLabel)"
            }
            return "이미지 클립"
        }
    }

    func matches(query: String) -> Bool {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return true }

        switch kind {
        case .text:
            return (text ?? "").localizedCaseInsensitiveContains(trimmed)
        case .image:
            if "이미지".localizedCaseInsensitiveContains(trimmed) { return true }
            if let sourceLabel {
                return sourceLabel.localizedCaseInsensitiveContains(trimmed)
            }
            return false
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let kind = try container.decodeIfPresent(ClipboardItemKind.self, forKey: .kind) {
            self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
            self.kind = kind
            self.text = try container.decodeIfPresent(String.self, forKey: .text)
            self.imagePNGData = try container.decodeIfPresent(Data.self, forKey: .imagePNGData)
            self.imageSignature = try container.decodeIfPresent(String.self, forKey: .imageSignature)
            self.sourceLabel = try container.decodeIfPresent(String.self, forKey: .sourceLabel)
            self.copiedAt = try container.decodeIfPresent(Date.self, forKey: .copiedAt) ?? Date()
            return
        }

        // 구버전(텍스트 전용) 히스토리 포맷 호환
        let legacyID = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        let legacyText = try container.decode(String.self, forKey: .text)
        let legacyCopiedAt = try container.decodeIfPresent(Date.self, forKey: .copiedAt) ?? Date()

        self.id = legacyID
        self.kind = .text
        self.text = legacyText
        self.imagePNGData = nil
        self.imageSignature = nil
        self.sourceLabel = nil
        self.copiedAt = legacyCopiedAt
    }
}
