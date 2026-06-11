import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jogo.dart';
import '../providers/jogos_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/card_jogo.dart';
import 'tela_cadastro_jogo.dart';
import 'tela_resultados.dart';
import 'tela_editar_placar.dart';

class TelaListaJogos extends ConsumerStatefulWidget {
  const TelaListaJogos({super.key});

  @override
  ConsumerState<TelaListaJogos> createState() => _TelaListaJogosState();
}

class _TelaListaJogosState extends ConsumerState<TelaListaJogos> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(jogosProvider.notifier).carregarJogos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jogosProvider);
    final jogos = state.jogos;
    final carregando = state.carregando;
    final jogosAoVivo = state.jogosAoVivo;
    final proximosJogos = state.jogosAgendados;
    final jogosFinalizados = state.jogosFinalizados;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const TopAppBar(title: 'COPA DO MUNDO 2026'),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(jogosProvider.notifier).carregarJogos(),
              child: ListView(
                padding: EdgeInsets.only(bottom: 100 + MediaQuery.of(context).padding.bottom, top: 16),
                children: [
                  if (jogosAoVivo.isNotEmpty) ...[
                    _buildSecaoAoVivo(jogosAoVivo),
                    const SizedBox(height: 24),
                  ],
                  if (proximosJogos.isNotEmpty) ...[
                    _buildSecaoProximos(proximosJogos),
                    const SizedBox(height: 24),
                  ],
                  if (jogosFinalizados.isNotEmpty) ...[
                    _buildSecaoResultados(jogosFinalizados),
                  ],
                  if (jogos.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'Nenhum jogo cadastrado.\nToque em + para adicionar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TelaCadastroJogo()),
          );
          ref.read(jogosProvider.notifier).carregarJogos();
        },
        backgroundColor: AppTheme.primaryContainer,
        foregroundColor: AppTheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TelaCadastroJogo()),
            ).then((_) => ref.read(jogosProvider.notifier).carregarJogos());
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TelaResultados()),
            );
          }
        },
      ),
    );
  }

  Widget _buildSecaoAoVivo(List jogos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ao Vivo',
                style: TextStyle(
                  fontFamily: 'Archivo Narrow',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  letterSpacing: -1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppTheme.secondaryContainer.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${jogos.length} Ativos',
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        color: AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: jogos.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 300,
                child: CardJogo(
                  jogo: jogos[index],
                  onTap: () => _editarJogo(jogos[index]),
                  onDelete: () => _deletarJogo(jogos[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecaoProximos(List jogos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Próximos',
            style: TextStyle(
              fontFamily: 'Archivo Narrow',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...jogos.map((jogo) => CardJogo(
          jogo: jogo,
          onTap: () => _editarJogo(jogo),
          onDelete: () => _deletarJogo(jogo),
        )),
      ],
    );
  }

  Widget _buildSecaoResultados(List jogos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Resultados',
            style: TextStyle(
              fontFamily: 'Archivo Narrow',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...jogos.map((jogo) => CardJogo(
          jogo: jogo,
          onTap: () => _editarJogo(jogo),
          onDelete: () => _deletarJogo(jogo),
        )),
      ],
    );
  }

  Future<void> _editarJogo(Jogo jogo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaEditarPlacar(jogo: jogo),
      ),
    );
    ref.read(jogosProvider.notifier).carregarJogos();
  }

  Future<void> _deletarJogo(Jogo jogo) async {
    if (jogo.id == null) return;
    await ref.read(jogosProvider.notifier).removerJogo(jogo.id!);
  }
}
