import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

enum CategoryType { restaurant, cafe, salonDeThe }

String categoryTitle(CategoryType type) {
  switch (type) {
    case CategoryType.restaurant:
      return 'Restaurants';
    case CategoryType.cafe:
      return 'Cafés';
    case CategoryType.salonDeThe:
      return 'Salons de thé';
  }
}

IconData categoryIcon(CategoryType type) {
  switch (type) {
    case CategoryType.restaurant:
      return Icons.restaurant_menu;
    case CategoryType.cafe:
      return Icons.local_cafe;
    case CategoryType.salonDeThe:
      return Icons.emoji_food_beverage;
  }
}

final Map<CategoryType, List<Map<String, String>>> sampleData = {
  CategoryType.restaurant: [
    {
      'name': 'Le Gourmet',
      'phone': '+216 71 123 456',
      'address': 'Ave. Habib Bourguiba, Tunis',
    },
    {
      'name': 'Dar El Jeld',
      'phone': '+216 71 987 654',
      'address': 'Medina, Tunis',
    },
  ],
  CategoryType.cafe: [
    {
      'name': 'Café des Arts',
      'phone': '+216 22 111 222',
      'address': 'Lac 1, Tunis',
    },
    {
      'name': 'Café de Paris',
      'phone': '+216 22 333 444',
      'address': 'Sfax Centre',
    },
  ],
  CategoryType.salonDeThe: [
    {
      'name': 'Thé Oriental',
      'phone': '+216 50 777 888',
      'address': 'La Marsa',
    },
    {
      'name': 'Maison du Thé',
      'phone': '+216 50 999 000',
      'address': 'Sousse Khezama',
    },
  ],
};

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with TickerProviderStateMixin {
  late final AnimationController _gridController;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catégories',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Choisissez un type pour explorer',
                      style: TextStyle(color: Colors.white.withOpacity(0.85)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildCategoryCard(CategoryType.restaurant, 0),
                      _buildCategoryCard(CategoryType.cafe, 1),
                      _buildCategoryCard(CategoryType.salonDeThe, 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryType type, int index) {
    final animation = CurvedAnimation(
      parent: _gridController,
      curve: Interval(0.1 * index, 0.6 + 0.1 * index, curve: Curves.easeOutBack),
    );

    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animation),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, a1, a2) => CategoryDetailPage(type: type),
                transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(categoryIcon(type), color: Colors.white, size: 30),
                ),
                const SizedBox(height: 14),
                Text(
                  categoryTitle(type),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  '${sampleData[type]?.length ?? 0} lieux',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final CategoryType type;
  const CategoryDetailPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final items = sampleData[type] ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF667eea),
        elevation: 0,
        title: Text(categoryTitle(type)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return _PlaceTile(
                name: item['name'] ?? '',
                address: item['address'] ?? '',
                phone: item['phone'] ?? '',
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length,
          ),
        ),
      ),
    );
  }
}

class _PlaceTile extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  const _PlaceTile({required this.name, required this.address, required this.phone});

  Future<void> _call(String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container
    (
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.place, color: Color(0xFF667eea)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(address),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(phone, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Appeler',
              onPressed: () => _call(phone),
              icon: const Icon(Icons.call, color: Color(0xFF12B981)),
            ),
            IconButton(
              tooltip: 'Copier',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phone));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Numéro copié')),
                );
              },
              icon: const Icon(Icons.copy, color: Color(0xFF6366F1)),
            ),
          ],
        ),
      ),
    );
  }
}


