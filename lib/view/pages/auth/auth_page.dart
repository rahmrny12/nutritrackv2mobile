import 'package:flutter/material.dart';
import 'package:nutritrack/core/api_service.dart';
import 'package:nutritrack/core/route_generator.dart';
import 'package:nutritrack/data/repository/auth_repository.dart';
import 'package:nutritrack/view/viewmodel/auth_viewmodel.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late AuthViewModel viewModel;

  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  late AnimationController _animController;
  late Animation<double> _animation;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    viewModel = AuthViewModel(AuthRepository(ApiService()));

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutExpo,
    );

    _animController.value = 0.0;

    // 🔥 LISTEN DRAG SHEET
    _sheetController.addListener(() {
      if (!_sheetController.isAttached) return;

      double size = _sheetController.size; // 0.0 → 0.9
      double progress = (size / 0.85).clamp(0.0, 1.0);

      _animController.value = progress;

      // update state open/close
      if (progress < 0.05) {
        isOpen = false;
      } else {
        isOpen = true;
      }
    });
  }

  void openLogin() {
    _sheetController.animateTo(
      0.85,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutExpo,
    );
  }

  void closeLogin() {
    _sheetController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double progress = _animation.value;

          return Stack(
            children: [
              // 🔹 Background
              Image.asset(
                "assets/images/bg_authenticate.png",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // 🔥 LOGO + TEXT
              SafeArea(
                child: Align(
                  alignment: Alignment(0, -0.1 - (progress * 0.9)),
                  child: Transform.scale(
                    scale: 1 - (progress * 0.25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🔥 Animated Logo Switch
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                            );
                          },
                          child: progress < 0.6
                              ? Image.asset(
                                  "assets/images/logo_nutritrack.png",
                                  key: const ValueKey("logo_vertical"),
                                  height: 200,
                                )
                              : Image.asset(
                                  "assets/images/logo_nutritrack_horizontal.png",
                                  key: const ValueKey("logo_horizontal"),
                                  height: 80,
                                ),
                        ),

                        const SizedBox(height: 24),

                        // 🔥 Tagline fade
                        Padding(
                          padding: const EdgeInsets.only(bottom: 128),
                          child: Opacity(
                            opacity: 1 - progress,
                            child: const Text(
                              "Hidup Sehat\nMulai dari —\nGizi yang Tepat",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔹 BUTTON
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40,
                    left: 24,
                    right: 24,
                  ),
                  child: Opacity(
                    opacity: 1 - progress,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: openLogin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Masuk"),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, Routes.register),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Daftar",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔥 SLIDING PANEL
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: 0.0,
                minChildSize: 0.0,
                maxChildSize: 0.8,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 12),

                        // 🔥 handle + close
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 40),
                            Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            IconButton(
                              onPressed: closeLogin,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text("Email/Username"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: viewModel.emailController,
                          decoration: InputDecoration(
                            hintText: "Masukkan Email/Username",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text("Kata Sandi"),
                        const SizedBox(height: 8),
                        TextField(
                          controller: viewModel.passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Masukkan Password",
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: const Icon(Icons.visibility),
                          ),
                        ),

                        const SizedBox(height: 24),

                        ListenableBuilder(
                          listenable: viewModel,
                          builder: (context, _) {
                            final state = viewModel.value;

                            return Column(
                              children: [
                                if (state.error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: Text(
                                      state.error!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),

                                ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () async {
                                          await viewModel.login();

                                          if (viewModel.value.user != null) {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.dashboard,
                                            );
                                          }
                                        },
                                  child: const Text("Masuk"),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Lupa Password?"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
