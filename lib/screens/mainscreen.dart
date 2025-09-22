import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'available_workspaces_screen.dart';
import '../widgets/categories_bottom_sheet.dart';
import 'signup_screen.dart';
import 'note.dart';
import 'plus.dart';
import 'chatbot.dart';
import 'advanced_search.dart';
import 'spalsh.dart';
//import 'splash.dart';

void main() => runApp(WeworkCloneApp());

class WeworkCloneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wework Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class WeworkHomePage extends StatefulWidget {
  @override
  _WeworkHomePageState createState() => _WeworkHomePageState();
}

class _WeworkHomePageState extends State<WeworkHomePage> with SingleTickerProviderStateMixin {
  String selectedCity = 'tunis';
  String selectedType = '';
  bool _isSidebarVisible = false;
  bool _isLoginVisible = true;
  int _currentIndex = 2; // Default to main page
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final List<String> cities = [
    'tunis',
    'ariana',
    'sousse',
    'sfax',
    'benzart',
    'zaghouan'
  ];

  final List<Map<String, dynamic>> workspaceTypes = [
    {
      'title': 'Espace de travail pour la journée',
      'description': 'Réservez un espace de travail pour une journée',
      'icon': Icons.work_outline,
    },
    {
      'title': 'Abonnement à un espace de travail partagé',
      'description': 'Espace de travail partagé avec d\'autres professionnels',
      'icon': Icons.people_outline,
    },
    {
      'title': 'Espace de bureau privé',
      'description': 'Bureau privé pour votre équipe',
      'icon': Icons.meeting_room_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
      if (_isSidebarVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoginVisible = false;
      });
    }
  }

  void _handleVisitorLogin() {
    setState(() {
      _isLoginVisible = false;
    });
  }

  void _navigateToAvailableWorkspaces() {
    if (selectedType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez sélectionner un type d\'espace de travail'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AvailableWorkspacesScreen(
          city: selectedCity,
          workspaceType: selectedType,
        ),
      ),
    );
  }

  Widget _buildLivePage() {
    return Center(
      child: Text('Live Page'),
    );
  }

  Widget _buildNotePage() {
    return NotePage();
  }

  Widget _buildMainPage() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildAnimatedBackground(),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Header with greeting
                      _buildHeader(),
                      const SizedBox(height: 30),
                      
                      // Quick action buttons
                      _buildQuickActions(),
                      const SizedBox(height: 30),
                      
                      // Hero section
                      _buildHeroSection(),
                      const SizedBox(height: 30),
                      
                      // City selection with improved design
                      _buildCitySelection(),
                      const SizedBox(height: 25),
                      
                      // Workspace types with modern cards
                      _buildWorkspaceTypes(),
                      const SizedBox(height: 30),
                      
                      // CTA Button with animation
                      _buildCTAButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            
            // Floating menu button
            _buildFloatingMenuButton(),
            
            // Sidebar
            if (_isSidebarVisible) _buildSidebar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: Container(
        child: Stack(
          children: [
            // Floating circles
            Positioned(
              top: 100,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Trouvez votre espace idéal',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              HapticFeedback.lightImpact();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.search,
            title: 'Recherche',
            subtitle: 'Trouvez rapidement',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvancedSearchScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionCard(
            icon: Icons.chat_bubble_outline,
            title: 'Assistant',
            subtitle: 'IA disponible',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.work_outline,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            'Nous sommes là pour chaque façon de travailler',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Explorez les solutions d\'espace de travail conçues pour les équipes de toutes tailles',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF667eea)),
              const SizedBox(width: 8),
              Text(
                'Sélectionnez votre ville',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map((city) => DropdownMenuItem(
                value: city,
                child: Text(
                  city.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              )).toList(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.location_city, color: Color(0xFF667eea)),
                labelText: 'Ville',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() => selectedCity = val!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.category, color: Color(0xFF667eea)),
            const SizedBox(width: 8),
            Text(
              'Choisissez votre type d\'espace',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...workspaceTypes.asMap().entries.map((entry) {
          final index = entry.key;
          final type = entry.value;
          final isSelected = selectedType == type['title'];
          
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => selectedType = type['title']);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF667eea).withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Color(0xFF667eea) : Colors.grey[200]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF667eea) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          type['icon'],
                          color: isSelected ? Colors.white : Color(0xFF667eea),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Color(0xFF667eea) : Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              type['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF667eea),
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCTAButton() {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _navigateToAvailableWorkspaces,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF667eea),
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Color(0xFF667eea).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 24),
            const SizedBox(width: 12),
            Text(
              'Voir les espaces disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingMenuButton() {
    return Positioned(
      top: 50,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            _isSidebarVisible ? Icons.close : Icons.menu,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            _toggleSidebar();
          },
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(-280 * (1 - _animation.value), 0),
            child: child,
          );
        },
        child: CategoriesBottomSheet(),
      ),
    );
  }

  Widget _buildCategoriesPage() {
    return Center(
      child: Text('Categories Page'),
    );
  }

  Widget _buildPlusPage() {
    return const PlusPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoginVisible
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[700]!, Colors.blue[900]!],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.work_outline,
                            size: 50,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: 40),

                        // Login Form
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text(
                                  'Bienvenue',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Email Field
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),

                                // Password Field
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre mot de passe';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),

                                // Remember Me & Forgot Password
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value!;
                                            });
                                          },
                                        ),
                                        Text('Se souvenir de moi'),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // TODO: Implement forgot password
                                      },
                                      child: Text('Mot de passe oublié?'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),

                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[900],
                                      padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                                      'Se connecter',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Visitor Login Button
                                TextButton(
                                  onPressed: _handleVisitorLogin,
                                  child: Text(
                                    'Entrer comme un visiteur',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),

                                // Register Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Pas encore de compte?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SignupScreen()),
                                        );
                                      },
                                      child: Text('S\'inscrire'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : IndexedStack(
              index: _currentIndex,
              children: [
                _buildLivePage(),
                _buildNotePage(),
                _buildMainPage(),
                _buildCategoriesPage(),
                _buildPlusPage(),
              ],
            ),
      bottomNavigationBar: !_isLoginVisible
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.live_tv, 'Live', 0),
                      _buildNavItem(Icons.note, 'Note', 1),
                      _buildNavItem(Icons.home, 'Accueil', 2),
                      _buildNavItem(Icons.category, 'Categories', 3),
                      _buildNavItem(Icons.add_circle, 'Plus', 4),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF667eea).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF667eea) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Color(0xFF667eea) : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
