import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/loading_bar.dart';
import '../auth/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const RegisterScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 0.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "assets/images/SmartExpenseLogo.png",
                width: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: LoadingBar(),
          )
        ],
      ),
    );
  }
}
