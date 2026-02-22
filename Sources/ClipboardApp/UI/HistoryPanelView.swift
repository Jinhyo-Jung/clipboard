import AppKit
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
        ScrollViewReader { proxy in
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

                ScrollView {
                    LazyVStack(spacing: 6) {
                        ForEach(filteredItems) { item in
                            Button {
                                selectedID = item.id
                            } label: {
                                rowContent(for: item)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(rowBackground(for: item.id))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                            .id(item.id)
                        }
                    }
                    .padding(.vertical, 2)
                }
                .background(Color(nsColor: .textBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 8))

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
                KeyboardEventMonitorView(onKeyDown: { handleKeyDown($0, proxy: proxy) })
                    .frame(width: 0, height: 0)
            )
            .onAppear {
                selectFirstIfNeeded()
                scrollToSelection(proxy, anchor: .top)
                focusSearchFieldSoon()
            }
            .onChange(of: sessionID) { _ in
                query = ""
                selectedID = nil
                selectFirstIfNeeded()
                scrollToSelection(proxy, anchor: .top)
                focusSearchFieldSoon()
            }
            .onChange(of: query) { _ in
                selectFirstIfNeeded()
                scrollToSelection(proxy, anchor: .top)
            }
            .onChange(of: filteredItems.map(\.id)) { _ in
                selectFirstIfNeeded()
                scrollToSelection(proxy, anchor: .top)
            }
            .onChange(of: selectedID) { _ in
                scrollToSelection(proxy, anchor: .center)
            }
        }
    }

    private func handleKeyDown(_ event: NSEvent, proxy: ScrollViewProxy) -> Bool {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        if event.keyCode == 53 { // Esc
            onClose()
            return true
        }

        if event.keyCode == 125 { // Down
            moveSelection(direction: 1, proxy: proxy)
            return true
        }

        if event.keyCode == 126 { // Up
            moveSelection(direction: -1, proxy: proxy)
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
            scrollToSelection(proxy, anchor: .top)
            return true
        }

        if flags.contains(.command), let index = commandNumberIndex(for: event.keyCode) {
            guard filteredItems.indices.contains(index) else { return true }
            let item = filteredItems[index]
            selectedID = item.id
            scrollToSelection(proxy, anchor: .center)
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

    private func moveSelection(direction: Int, proxy: ScrollViewProxy) {
        guard filteredItems.isEmpty == false else {
            selectedID = nil
            return
        }

        guard let currentSelectedID = selectedID, let currentIndex = filteredItems.firstIndex(where: { $0.id == currentSelectedID }) else {
            selectedID = filteredItems[0].id
            scrollToSelection(proxy, anchor: .top)
            return
        }

        let nextIndex = max(0, min(filteredItems.count - 1, currentIndex + direction))
        selectedID = filteredItems[nextIndex].id
        scrollToSelection(proxy, anchor: .center)
    }

    private func scrollToSelection(_ proxy: ScrollViewProxy, anchor: UnitPoint) {
        guard let selectedID else { return }

        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.12)) {
                proxy.scrollTo(selectedID, anchor: anchor)
            }
        }
    }

    private func rowBackground(for id: UUID) -> Color {
        selectedID == id ? Color.accentColor.opacity(0.22) : Color(nsColor: .controlBackgroundColor)
    }

    @ViewBuilder
    private func rowContent(for item: ClipboardItem) -> some View {
        if item.kind == .image {
            HStack(spacing: 10) {
                if
                    let imageData = item.imagePNGData,
                    let image = NSImage(data: imageData)
                {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 68, height: 42)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    Image(systemName: "photo")
                        .frame(width: 68, height: 42)
                        .background(Color(nsColor: .windowBackgroundColor))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.preview)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.copiedAt, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.preview)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.copiedAt, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
