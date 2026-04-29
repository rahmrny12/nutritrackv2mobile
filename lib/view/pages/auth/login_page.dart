import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1ABC9C),
        ),
        child: Column(
          children: [
            // Header dengan logo dan gambar
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo Text
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(
                          text: 'NUTRI',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'TRACK+',
                          style: TextStyle(color: Color(0xFF006D5B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Gambar buah-buahan berbentuk hati
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        '[images.unsplash.com](https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=400)',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 80,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form Login
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sign In Text
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1ABC9C),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Username Field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey[600],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5F3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey[600],
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey[600],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Terms Checkbox
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(color: Colors.grey[400]!),
                              activeColor: const Color(0xFF1ABC9C),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'I accept the policy and terms',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle sign in
                            if (_acceptTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Signing in...'),
                                  backgroundColor: Color(0xFF1ABC9C),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please accept terms first'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1ABC9C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Social Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google Button
                          _socialButton(
                            onTap: () {
                              // Handle Google login
                            },
                            child: Image.network(
                              '[google.com](https://www.google.com/favicon.ico)',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          // X (Twitter) Button
                          _socialButton(
                            onTap: () {
                              // Handle X login
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '𝕏',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
