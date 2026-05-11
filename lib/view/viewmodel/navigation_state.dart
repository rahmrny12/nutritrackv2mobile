class NavigationState {
  final int selectedIndex;
  final List<NavigationItem> items;

  NavigationState({
    this.selectedIndex = 0,
    this.items = const [
      NavigationItem(icon: 'home', label: 'Beranda'),
      NavigationItem(icon: 'diary', label: 'Diary'),
      NavigationItem(icon: 'progress', label: 'Progres'),
      NavigationItem(icon: 'profile', label: 'Profil'),
    ],
  });

  NavigationState copyWith({
    int? selectedIndex,
    List<NavigationItem>? items,
  }) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      items: items ?? this.items,
    );
  }
}

class NavigationItem {
  final String icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}
