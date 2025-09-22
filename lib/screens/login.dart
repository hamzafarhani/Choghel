import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:choghel/screens/mainscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/d.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text('Go to Login'),
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  //late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/d.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3), // Adjust opacity here
                Colors.black.withOpacity(0.6), // Adjust opacity here
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "Welcome!",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 47, 238, 255)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign up or Login to your Account",
                    style: TextStyle(fontSize: 20, color: Colors.blue[100]),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.blue[100],
                      ),
                      tabs: const [
                        Tab(text: "Login"),
                        Tab(text: "Sign in"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 500.0,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        _LoginTab(),
                        _SignUpTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpTab extends StatelessWidget {
  const _SignUpTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Full Name",
              hintText: "Eg. Jared White",
              labelStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              hintStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter email",
              labelStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              hintStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255,  47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter password",
              labelStyle: const TextStyle(color: Color.fromARGB(255,  47, 238, 255)),
              hintStyle: const TextStyle(color: Color.fromARGB(255,  47, 238, 255)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255,  47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255,  47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Confirm Password",
              hintText: "Enter password again",
              labelStyle: const TextStyle(color: Color.fromARGB(255,  47, 238, 255)),
              hintStyle: const TextStyle(color: Color.fromARGB(255,  47, 238, 255)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255,  47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              // Handle login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100], // Change button color to amber
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              "Register",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Change text color to black
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTab extends StatelessWidget {
  const _LoginTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              labelStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              hintStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16.0),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              labelStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              hintStyle: const TextStyle(color: Color.fromARGB(255, 47, 238, 255)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 47, 238, 255)),
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 8.0),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: const Text("Forgot password?",
                  style: TextStyle(color: Color.fromARGB(255, 47, 238, 255))),
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: ((context) => WeworkHomePage()),
                ),
              );
              // Handle login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[100], // Change button color to amber
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black, // Change text color to black
              ),
            ),
          ),
          const SizedBox(height: 45.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(color: Colors.blue.withOpacity(0.16)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Or login with"),
              ),
              Expanded(
                child: Divider(color: Color.fromARGB(255, 47, 238, 255).withOpacity(0.16)),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {
              // Handle Google sign in
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/google.png',
                  height: 26.0,
                  width: 26.0,
                ),
                const SizedBox(width: 8.0),
                const Text("Google",
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
