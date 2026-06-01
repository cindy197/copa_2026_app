import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/tela_lista_jogos.dart';

class CopaApp extends StatelessWidget {
  const CopaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Copa do Mundo 2026',
      theme: AppTheme.darkTheme,
      home: const TelaListaJogos(),
    );
  }
}
