import 'package:crypto_portfolio_tracker/models/portfolio_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class PortfolioItemCard extends StatelessWidget {
  final PortfolioItem item;
  final int index;
  final VoidCallback onDelete;

  const PortfolioItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final quantityFormatter = NumberFormat('#,##0.########');

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Slidable(
        key: ValueKey(item.coinId),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFA31C44).withAlpha(26),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(52),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Coin Icon Placeholder
                    Container(
                      width: isTablet ? 56 : 48,
                      height: isTablet ? 56 : 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFA31C44).withAlpha(76),
                            const Color(0xFFD91F5A).withAlpha(52),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
                      ),
                      child: Center(
                        child: Text(
                          item.coinSymbol.toUpperCase().substring(0, 1),
                          style: TextStyle(
                            fontSize: isTablet ? 26 : 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFA31C44),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 16 : 12),

                    // Coin Name and Symbol
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.coinName,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.coinSymbol.toUpperCase(),
                            style: TextStyle(
                              fontSize: isTablet ? 15 : 14,
                              color: Colors.white.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Total Value
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormatter.format(item.totalValue),
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${quantityFormatter.format(item.quantity)} ${item.coinSymbol.toUpperCase()}',
                          style: TextStyle(
                            fontSize: isTablet ? 13 : 12,
                            color: Colors.white.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 16 : 12),

                // Divider
                Divider(
                  color: const Color(0xFFA31C44).withAlpha(52),
                  thickness: 1,
                ),

                SizedBox(height: isTablet ? 16 : 12),

                // Price Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Price',
                            style: TextStyle(
                              fontSize: isTablet ? 13 : 12,
                              color: Colors.white.withAlpha(153),
                            ),
                          ),
                          if (item.priceChange != null) ...[
                            const SizedBox(width: 4),
                            Icon(
                              item.isPriceUp
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 12,
                              color: item.isPriceUp ? Colors.green : Colors.red,
                            ),
                          ],
                          SizedBox(height: isTablet ? 6 : 4),
                          Text(
                            currencyFormatter.format(item.currentPrice),
                            style: TextStyle(
                              fontSize: isTablet ? 17 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (item.priceChange != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (item.isPriceUp ? Colors.green : Colors.red)
                                        .withAlpha(52),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${item.isPriceUp ? '+' : ''}${item.priceChange!.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: item.isPriceUp
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Holdings',
                            style: TextStyle(
                              fontSize: isTablet ? 13 : 12,
                              color: Colors.white.withAlpha(153),
                            ),
                          ),
                          SizedBox(height: isTablet ? 6 : 4),
                          Text(
                            quantityFormatter.format(item.quantity),
                            style: TextStyle(
                              fontSize: isTablet ? 17 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
