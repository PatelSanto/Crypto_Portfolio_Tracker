import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PortfolioHeader extends StatelessWidget {
  final double totalValue;

  const PortfolioHeader({super.key, required this.totalValue});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Container(
      margin: EdgeInsets.all(isTablet ? 20 : 16),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 20,
        vertical: isTablet ? 20 : 16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA31C44), Color(0xFFD91F5A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA31C44).withAlpha(76),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white.withAlpha(230),
                size: isTablet ? 20 : 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Total Value',
                style: TextStyle(
                  fontSize: isTablet ? 15 : 13,
                  color: Colors.white.withAlpha(230),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: totalValue),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Text(
                formatter.format(value),
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ],
      ),
    );
  }
}
