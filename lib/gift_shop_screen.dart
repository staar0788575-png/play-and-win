import 'package:flutter/material.dart';
import 'gift_model.dart';

class GiftShopScreen extends StatelessWidget {
  final int userCoins;
  final Function(GiftItem) onSendGift;

  const GiftShopScreen({
    super.key,
    required this.userCoins,
    required this.onSendGift,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_florist':
        return Icons.local_florist;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'flight':
        return Icons.flight;
      case 'card_giftcard':
      default:
        return Icons.card_giftcard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متجر الهدايا'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // عرض رصيد المستخدم الحالي
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.amber[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Text(
                  'رصيدك: $userCoins عملة',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: availableGifts.length,
              itemBuilder: (context, index) {
                final gift = availableGifts[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconData(gift.iconName),
                          size: 48,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          gift.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${gift.cost} عملة',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 36),
                          ),
                          onPressed: () {
                            onSendGift(gift);
                            Navigator.pop(context);
                          },
                          child: const Text('إرسال الهدية'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
