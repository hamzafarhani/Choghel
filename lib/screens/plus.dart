import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlusPage extends StatefulWidget {
  const PlusPage({super.key});

  @override
  State<PlusPage> createState() => _PlusPageState();
}

class _PlusPageState extends State<PlusPage> {
  // User preferences state
  bool _is24HourFormat = true;
  String _selectedLanguage = 'Français';
  ThemeMode _selectedTheme = ThemeMode.system;
  bool _suggestNearbyLocation = true;
  String _userName = 'Utilisateur';
  String _userEmail = 'user@example.com';
  
  // Available options
  final List<String> _languages = ['Français', 'English', 'العربية', 'Español'];
  final List<ThemeMode> _themes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
  final List<String> _themeNames = ['Système', 'Clair', 'Sombre'];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _is24HourFormat = prefs.getBool('is24HourFormat') ?? true;
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'Français';
      _selectedTheme = ThemeMode.values[prefs.getInt('selectedTheme') ?? 0];
      _suggestNearbyLocation = prefs.getBool('suggestNearbyLocation') ?? true;
      _userName = prefs.getString('userName') ?? 'Utilisateur';
      _userEmail = prefs.getString('userEmail') ?? 'user@example.com';
    });
  }

  Future<void> _saveUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is24HourFormat', _is24HourFormat);
    await prefs.setString('selectedLanguage', _selectedLanguage);
    await prefs.setInt('selectedTheme', _selectedTheme.index);
    await prefs.setBool('suggestNearbyLocation', _suggestNearbyLocation);
    await prefs.setString('userName', _userName);
    await prefs.setString('userEmail', _userEmail);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionner la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) => ListTile(
            title: Text(language),
            leading: Radio<String>(
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                _saveUserPreferences();
                Navigator.pop(context);
              },
            ),
          )).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionner le thème'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.asMap().entries.map((entry) => ListTile(
            title: Text(_themeNames[entry.key]),
            leading: Radio<ThemeMode>(
              value: entry.value,
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() => _selectedTheme = value!);
                _saveUserPreferences();
                Navigator.pop(context);
              },
            ),
          )).toList(),
        ),
      ),
    );
  }

  void _showProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _userName = nameController.text;
                _userEmail = emailController.text;
              });
              _saveUserPreferences();
              Navigator.pop(context);
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Évaluer l\'application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Que pensez-vous de notre application ?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                icon: Icon(
                  Icons.star,
                  color: index < 4 ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  // Handle rating
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Merci pour votre évaluation !')),
                  );
                },
              )),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Plus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // User Profile Section
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.deepPurple),
                ),
                title: Text(
                  _userName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _userEmail,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: _showProfileDialog,
              ),
            ),
            const SizedBox(height: 20),

            // Settings Section
            const Text(
              'Paramètres',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Time Format
            SettingsTile(
              icon: Icons.access_time,
              title: 'Format heure',
              trailing: ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                isSelected: [!_is24HourFormat, _is24HourFormat],
                onPressed: (index) {
                  setState(() {
                    _is24HourFormat = index == 1;
                  });
                  _saveUserPreferences();
                },
                children: const [
                  Text('12H', style: TextStyle(color: Colors.white)),
                  Text('24H', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            // Language
            SettingsTile(
              icon: Icons.language,
              title: 'Langue',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedLanguage,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
              onTap: _showLanguageDialog,
            ),

            // Theme
            SettingsTile(
              icon: Icons.brightness_6,
              title: 'Thème',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _themeNames[_selectedTheme.index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
              onTap: _showThemeDialog,
            ),

            // Location Services
            SettingsTile(
              icon: Icons.location_on,
              title: 'Suggérer la location la plus proche',
              trailing: Switch(
                value: _suggestNearbyLocation,
                onChanged: (value) {
                  setState(() {
                    _suggestNearbyLocation = value;
                  });
                  _saveUserPreferences();
                },
                activeColor: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Application',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Rate App
            SettingsTile(
              icon: Icons.star,
              title: "Évaluer l'application",
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: _showRatingDialog,
            ),

            // About
            SettingsTile(
              icon: Icons.info,
              title: 'À propos',
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('À propos'),
                    content: const Text('Choghel v1.0.0\n\nApplication de réservation d\'espaces de travail'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Help & Support
            SettingsTile(
              icon: Icons.help,
              title: 'Aide et support',
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Aide et support'),
                    content: const Text('Pour toute question ou problème, contactez-nous à :\n\nsupport@choghel.com'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
