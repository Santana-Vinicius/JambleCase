import SwiftUI
import Combine

@MainActor
final class TabBarViewModel: ObservableObject {
    @Published var tabItems: [TabItemDTO]
    @Published private(set) var isForward: Bool = true

    private let tabSelection = PassthroughSubject<TabIdentifier, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(tabItems: [TabItemDTO]) {
        self.tabItems = tabItems
        bindSelection()
    }

    var selectedTab: TabIdentifier {
        tabItems.first(where: \.isSelected)?.id ?? tabItems[0].id
    }

    func selectTab(_ id: TabIdentifier) {
        tabSelection.send(id)
    }

    func selectNext() {
        let currentIndex = selectedIndex
        let next = currentIndex + 1
        guard tabItems.indices.contains(next) else { return }
        tabSelection.send(tabItems[next].id)
    }

    func selectPrevious() {
        let currentIndex = selectedIndex
        let previous = currentIndex - 1
        guard tabItems.indices.contains(previous) else { return }
        tabSelection.send(tabItems[previous].id)
    }

    private var selectedIndex: Int {
        tabItems.firstIndex(where: \.isSelected) ?? 0
    }

    private func bindSelection() {
        tabSelection
            .removeDuplicates()
            .sink { [weak self] tabId in
                self?.updateSelection(to: tabId)
            }
            .store(in: &cancellables)
    }

    private func updateSelection(to tabId: TabIdentifier) {
        guard let newIndex = tabItems.firstIndex(where: { $0.id == tabId }) else { return }
        isForward = newIndex > selectedIndex
        withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
            for i in tabItems.indices {
                tabItems[i].isSelected = (tabItems[i].id == tabId)
            }
        }
    }
}
