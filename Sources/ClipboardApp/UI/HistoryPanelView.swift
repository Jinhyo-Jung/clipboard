import SwiftUI

struct HistoryPanelView: View {
    @ObservedObject var controller: ClipboardAppController
    let sessionID: UUID
    let onClose: () -> Void

    @State private var query = ""
    @State private var selectedID: UUID?
    @FocusState private var isSearchFocused: Bool

    private var filteredItems: [ClipboardItem] {
        controller.filteredItems(for: query)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("클립보드 검색", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .focused($isSearchFocused)
                    .onSubmit {
                        pasteSelectedItem()
                    }
            }

            List(selection: $selectedID) {
                ForEach(filteredItems) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.preview)
                            .lineLimit(2)
                        Text(item.copiedAt, style: .time)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tag(item.id)
                }
            }
            .listStyle(.plain)

            HStack {
                Text("저장 \(controller.items.count)개 / 최대 \(controller.settings.maxItems)개")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                if controller.settings.isCapturePaused {
                    Label("기록 일시 중지", systemImage: "pause.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(16)
        .frame(minWidth: 620, minHeight: 420)
        .background(
            KeyboardEventMonitorView(onKeyDown: handleKeyDown)
                .frame(width: 0, height: 0)
        )
        .onAppear {
            selectFirstIfNeeded()
            focusSearchFieldSoon()
        }
        .onChange(of: sessionID) { _ in
            query = ""
            selectedID = nil
            selectFirstIfNeeded()
            focusSearchFieldSoon()
        }
        .onChange(of: query) { _ in
            selectFirstIfNeeded()
        }
        .onChange(of: filteredItems.map(\.id)) { _ in
            selectFirstIfNeeded()
        }
    }

    private func handleKeyDown(_ event: NSEvent) -> Bool {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        if event.keyCode == 53 { // Esc
            onClose()
            return true
        }

        if event.keyCode == 125 { // Down
            moveSelection(direction: 1)
            return true
        }

        if event.keyCode == 126 { // Up
            moveSelection(direction: -1)
            return true
        }

        if event.keyCode == 36 { // Enter
            pasteSelectedItem()
            return true
        }

        if event.keyCode == 51, flags.contains(.command), flags.contains(.shift) {
            controller.clearAll()
            selectedID = nil
            return true
        }

        if event.keyCode == 51, flags.contains(.command) {
            guard let selectedID else { return true }
            controller.delete(itemID: selectedID)
            selectFirstIfNeeded()
            return true
        }

        if flags.contains(.command), let index = commandNumberIndex(for: event.keyCode) {
            guard filteredItems.indices.contains(index) else { return true }
            let item = filteredItems[index]
            selectedID = item.id
            controller.paste(item: item)
            return true
        }

        return false
    }

    private func commandNumberIndex(for keyCode: UInt16) -> Int? {
        let mapping: [UInt16: Int] = [
            18: 0, // 1
            19: 1, // 2
            20: 2, // 3
            21: 3, // 4
            23: 4, // 5
            22: 5, // 6
            26: 6, // 7
            28: 7, // 8
            25: 8  // 9
        ]

        return mapping[keyCode]
    }

    private func pasteSelectedItem() {
        guard let item = selectedItem() else { return }
        controller.paste(item: item)
    }

    private func selectedItem() -> ClipboardItem? {
        if let selectedID, let selected = filteredItems.first(where: { $0.id == selectedID }) {
            return selected
        }

        return filteredItems.first
    }

    private func selectFirstIfNeeded() {
        guard filteredItems.isEmpty == false else {
            selectedID = nil
            return
        }

        if let selectedID, filteredItems.contains(where: { $0.id == selectedID }) {
            return
        }

        selectedID = filteredItems[0].id
    }

    private func focusSearchFieldSoon() {
        DispatchQueue.main.async {
            isSearchFocused = true
        }
    }

    private func moveSelection(direction: Int) {
        guard filteredItems.isEmpty == false else {
            selectedID = nil
            return
        }

        guard let currentSelectedID = selectedID, let currentIndex = filteredItems.firstIndex(where: { $0.id == currentSelectedID }) else {
            selectedID = filteredItems[0].id
            return
        }

        let nextIndex = max(0, min(filteredItems.count - 1, currentIndex + direction))
        selectedID = filteredItems[nextIndex].id
    }
}
