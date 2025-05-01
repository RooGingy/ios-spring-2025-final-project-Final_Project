import SwiftUI

struct Navbar: View {
    @Binding var selectedTab: MainTabView.Tab

    var body: some View {
        HStack {
            navButton(systemName: "house.fill", label: "Home", tab: .home)
            Spacer()
            navButton(systemName: "cart.fill", label: "Cart", tab: .cart)
            Spacer()
            navButton(systemName: "heart.text.square.fill", label: "Wishlist", tab: .wishlist)
            Spacer()
            navButton(systemName: "clock.arrow.circlepath", label: "Orders", tab: .orders)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .shadow(radius: 5)
    }

    private func navButton(systemName: String, label: String, tab: MainTabView.Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 20, weight: .semibold))
                Text(label)
                    .font(.caption2)
            }
            .foregroundColor(selectedTab == tab ? .blue : .primary)
        }
    }
}
