import 'package:crypto_portfolio_tracker/models/coin_model.dart';
import 'package:crypto_portfolio_tracker/repositories/coin_repository.dart';
import 'package:crypto_portfolio_tracker/services/coin_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/portfolio_controller.dart';

class AddAssetDialog extends StatefulWidget {
  const AddAssetDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const AddAssetDialog(),
    );
  }

  @override
  State<AddAssetDialog> createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final CoinSearchService _searchService = Get.find();
  final PortfolioController _portfolioController = Get.find();

  List<CoinModel> _searchResults = [];
  CoinModel? _selectedCoin;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _checkSearchServiceStatus();
  }

  void _checkSearchServiceStatus() {
    if (!_searchService.isInitialized) {
      Get.find<CoinRepository>().getCoins();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _searchService.searchCoins(query).take(50).toList();
    });
  }

  void _selectCoin(CoinModel coin) {
    setState(() {
      _selectedCoin = coin;
      _searchController.text = '${coin.name} (${coin.symbol.toUpperCase()})';
      _searchResults = [];
      _isSearching = false;
    });
  }

  Future<void> _addAsset() async {
    if (_selectedCoin == null) {
      Get.snackbar(
        'Error',
        'Please select a cryptocurrency',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final quantityText = _quantityController.text.trim();
    if (quantityText.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a quantity',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final quantity = double.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid positive number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Add asset to portfolio
    await _portfolioController.addAsset(
      _selectedCoin!.id,
      _selectedCoin!.name,
      _selectedCoin!.symbol,
      quantity,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth > 600 ? 40 : 16,
        vertical: 24,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth > 600 ? 500 : screenWidth - 32,
          maxHeight: screenHeight - keyboardHeight - 100,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardHeight > 0 ? 16 : 0),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 24 : 16,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Add Asset',
                        style: TextStyle(
                          fontSize: screenWidth > 600 ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                SizedBox(height: screenWidth > 600 ? 24 : 16),

                // Search Field
                Text(
                  'Search Cryptocurrency',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(178),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by name or symbol...',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E1E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFA31C44),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),

                // Search Results
                if (_isSearching && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    constraints: BoxConstraints(maxHeight: screenHeight * 0.25),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final coin = _searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple.withAlpha(51),
                            child: Text(
                              coin.symbol.toUpperCase().substring(0, 1),
                              style: const TextStyle(
                                color: Color(0xFFA31C44),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            coin.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            coin.symbol.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white.withAlpha(153),
                            ),
                          ),
                          onTap: () => _selectCoin(coin),
                        );
                      },
                    ),
                  ),

                if (_isSearching &&
                    _searchResults.isEmpty &&
                    _searchController.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'No cryptocurrencies found',
                        style: TextStyle(color: Colors.white.withAlpha(153)),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // Quantity Field
                Text(
                  'Quantity',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(178),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _quantityController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,8}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter quantity',
                    hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
                    prefixIcon: const Icon(
                      Icons.numbers,
                      color: Colors.white54,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFA31C44),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Add Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _addAsset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA31C44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add to Portfolio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
