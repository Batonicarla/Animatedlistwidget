import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimatedList – Shopping Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ShoppingCartScreen(),
    );
  }
}


class CartItem {
  final String name;
  final double price;

  const CartItem({
    required this.name,
    required this.price,
  });
}



const List<CartItem> _catalog = [
  CartItem(name: 'Wireless Headphones', price: 59.99),
  CartItem(name: 'Running Shoes', price: 89.99),
  CartItem(name: 'Coffee Maker', price: 45.00),
  CartItem(name: 'Yoga Mat', price: 29.99),
  CartItem(name: 'Backpack', price: 39.99),
  CartItem(name: 'Water Bottle', price: 19.99),
  CartItem(name: 'Sunglasses', price: 24.99),
  CartItem(name: 'Notebook', price: 9.99),
];


class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  
  final List<CartItem> _cartItems = [
    _catalog[0], 
    _catalog[1],
  ];

  static const Duration _insertDuration = Duration(milliseconds: 500);
  static const Duration _removeDuration = Duration(milliseconds: 400);

  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey<AnimatedListState>();

  
  final Set<int> _addedIndexes = {0, 1};

  
  void _addItem(CartItem item, int catalogIndex) {
    if (_addedIndexes.contains(catalogIndex)) return;

    setState(() => _addedIndexes.add(catalogIndex));

    final insertIndex = 0; 
    _cartItems.insert(insertIndex, item);

    
    _listKey.currentState?.insertItem(
      insertIndex,
      duration: _insertDuration,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.teal,
      ),
    );
  }

  
  void _removeItem(int index) {
    final removed = _cartItems[index];

    
    final catalogIndex =
        _catalog.indexWhere((c) => c.name == removed.name);
    if (catalogIndex != -1) {
      setState(() => _addedIndexes.remove(catalogIndex));
    }

    
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCartTile(removed, animation, index),
      duration: _removeDuration, 
    );

    _cartItems.removeAt(index);
  }

  
  Widget _buildCartTile(CartItem item, Animation<double> animation, int index) {
    
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Icon(Icons.shopping_bag_outlined,
                color: Theme.of(context).colorScheme.primary),
            title: Text(item.name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15)),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.teal)),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart_outlined,
                  color: Colors.redAccent),
              tooltip: 'Remove from cart',
              onPressed: () => _removeItem(index),
            ),
          ),
        ),
      ),
    );
  }

  
  double get _total =>
      _cartItems.fold(0.0, (sum, item) => sum + item.price);

  
  void _showCatalog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) => Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Add Items to Cart',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _catalog.length,
                  itemBuilder: (ctx, i) {
                    final alreadyAdded = _addedIndexes.contains(i);
                    return ListTile(
                      leading: Icon(Icons.inventory_2_outlined,
                          color: Theme.of(ctx).colorScheme.primary),
                      title: Text(_catalog[i].name),
                      subtitle: Text(
                          '\$${_catalog[i].price.toStringAsFixed(2)}'),
                      trailing: alreadyAdded
                          ? const Icon(Icons.check_circle,
                              color: Colors.teal)
                          : ElevatedButton(
                              onPressed: () {
                                _addItem(_catalog[i], i);
                                setModalState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white),
                              child: const Text('Add'),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.shopping_cart),
            const SizedBox(width: 8),
            const Text('My Cart'),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: Text(
                '${_cartItems.length}',
                style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Total: \$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),

      
      body: _cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_shopping_cart,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Your cart is empty.',
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('Tap + to add items.',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    key: _listKey,

                    initialItemCount: _cartItems.length,

                    scrollDirection: Axis.vertical,

                    padding: const EdgeInsets.symmetric(vertical: 12),

                    itemBuilder: (context, index, animation) {
                      return _buildCartTile(
                          _cartItems[index], animation, index);
                    },
                  ),
                ),

              
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border(
                        top: BorderSide(color: Colors.teal.shade200)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_cartItems.length} item(s)',
                          style: const TextStyle(fontSize: 15)),
                      Text(
                        'Total: \$${_total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),
                    ],
                  ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCatalog,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Add Items'),
      ),
    );
  }
}