import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mainscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choghel - Workspace Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _logoController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Interval(0.0, 0.8, curve: Curves.easeIn),
    ));

    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

  
    _startAnimations();
  }

  void _startAnimations() async {
    
    _logoController.forward();
    
    
    await Future.delayed(Duration(milliseconds: 500));
    _textController.forward();
    
    
    await Future.delayed(Duration(milliseconds: 300));
    _progressController.forward();
    
    
    await Future.delayed(Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => WeworkHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            
            _buildAnimatedBackground(),
            
          
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  _buildAnimatedLogo(),
                  
                  const SizedBox(height: 40),
                  
                
                  _buildAnimatedText(),
                  
                  const SizedBox(height: 60),
                  
                  
                  _buildProgressIndicator(),
                  
                  const SizedBox(height: 20),
                  
                
                  _buildLoadingText(),
                ],
              ),
            ),
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
            Positioned(
              top: 300,
              left: 50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoFadeAnimation,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Transform.rotate(
              angle: _logoRotationAnimation.value * 0.1,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: Offset(0, 15),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.work_outline,
                    size: 90,
                    color: Color(0xFF667eea),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _textSlideAnimation.value),
            child: Column(
              children: [
                Text(
                  'CHOGHEL',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Votre espace de travail idéal',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Réservez, travaillez, réussissez',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              Container(
                width: 200 * _progressAnimation.value,
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: Text(
            'Chargement...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      },
    );
  }
}
