import 'package:flutter/material.dart';
import 'screens/tela_lista_jogos.dart';

void main() {
  runApp(const CopaApp());
}

class CopaApp extends StatelessWidget {
  const CopaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha Copa 2026!',
      theme: ThemeData.dark(),
      home: const TelaListaJogos(),
    );
  }
}