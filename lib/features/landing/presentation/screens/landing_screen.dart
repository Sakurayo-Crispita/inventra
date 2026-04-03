import 'package:flutter/material.dart';

import '../widgets/landing_features.dart';
import '../widgets/landing_footer.dart';
import '../widgets/landing_hero.dart';
import '../widgets/landing_navbar.dart';
import '../widgets/landing_showcase.dart';

/// Pantalla raíz pública de Inventra.
///
/// Presenta el producto de forma comercial y profesional.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            LandingNavbar(),
            LandingHero(),
            LandingFeatures(),
            LandingShowcase(),
            LandingFooter(),
          ],
        ),
      ),
    );
  }
}
