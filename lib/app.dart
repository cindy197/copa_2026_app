import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'providers/jogos_provider.dart';
import 'screens/tela_lista_jogos.dart';

class CopaApp extends ConsumerWidget {
  const CopaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() => ref.read(jogosProvider.notifier).carregarJogos());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Copa do Mundo 2026',
      theme: AppTheme.darkTheme,
      home: const TelaListaJogos(),
    );
  }
}
