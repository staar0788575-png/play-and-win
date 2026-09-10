class GiftItem {
  final String id;
  final String name;
  final int cost;
  final String iconName; // تعبير عن أيقونة الهدية

  GiftItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.iconName,
  });
}

// قائمة افتراضية للهدايا المتاحة في المتجر
List<GiftItem> availableGifts = [
  GiftItem(id: '1', name: 'وردة', cost: 50, iconName: 'local_florist'),
  GiftItem(id: '2', name: 'تاج', cost: 500, iconName: 'workspace_premium'),
  GiftItem(id: '3', name: 'طائرة', cost: 2000, iconName: 'flight'),
  GiftItem(id: '4', name: 'طرد', cost: 100, iconName: 'card_giftcard'),
];
