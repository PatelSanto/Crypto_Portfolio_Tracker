import 'package:crypto_portfolio_tracker/widgets/portfolio_screen/add_asset_dialog.dart';
import 'package:crypto_portfolio_tracker/widgets/portfolio_screen/portfolio_header.dart';
import 'package:crypto_portfolio_tracker/widgets/portfolio_screen/portfolio_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/portfolio_controller.dart';

class PortfolioScreen extends GetView<PortfolioController> {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          'My Portfolio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isTablet ? 22 : 20,
          ),
        ),
        backgroundColor: const Color(0xFFA31C44),
        elevation: 0,
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort, color: Colors.white),
            color: const Color(0xFF2A2A3E),
            onSelected: (SortOption option) {
              controller.sortPortfolio(option);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.value,
                child: Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sort by Value',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.name,
                child: Row(
                  children: [
                    Icon(Icons.text_fields, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text('Sort by Name', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.quantity,
                child: Row(
                  children: [
                    Icon(Icons.numbers, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sort by Quantity',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.symbol,
                child: Row(
                  children: [
                    Icon(Icons.abc, color: Colors.white70, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sort by Symbol',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshPrices(),
            tooltip: 'Refresh Prices',
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFA31C44)),
          );
        }

        if (controller.portfolioItems.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 48 : 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(178),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: isTablet ? 80 : 64,
                      color: const Color(0xFFA31C44).withAlpha(127),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your Portfolio is Empty',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Start Building Your Crypto Portfolio by Adding Your First Asset',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.white.withAlpha(153),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => _showAddAssetDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Your First Asset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA31C44),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32 : 24,
                        vertical: isTablet ? 16 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshPrices,
          color: const Color(0xFFA31C44),
          child: Column(
            children: [
              PortfolioHeader(totalValue: controller.totalPortfolioValue.value),
              // Portfolio Items List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: 16,
                  ),
                  itemCount: controller.portfolioItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.portfolioItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PortfolioItemCard(
                        item: item,
                        index: index,
                        onDelete: () => _confirmDelete(context, index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.portfolioItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () => _showAddAssetDialog(context),
          backgroundColor: const Color(0xFFA31C44),
          elevation: 4,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Add Asset',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
        );
      }),
    );
  }

  void _showAddAssetDialog(BuildContext context) {
    AddAssetDialog.show(context);
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Asset',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove this asset from your portfolio?',
          style: TextStyle(color: Colors.white.withAlpha(204)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withAlpha(178)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.removeAsset(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
