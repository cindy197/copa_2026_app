import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/jogo.dart';
import '../theme/app_theme.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/card_jogo.dart';
import 'tela_cadastro_jogo.dart';
import 'tela_resultados.dart';
import 'tela_editar_placar.dart';

class TelaListaJogos extends StatefulWidget {
  const TelaListaJogos({super.key});

  @override
  State<TelaListaJogos> createState() => _TelaListaJogosState();
}

class _TelaListaJogosState extends State<TelaListaJogos> {
  List<Jogo> _jogos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarJogos();
  }

  Future<void> _carregarJogos() async {
    setState(() => _carregando = true);
    try {
      final jogos = await DatabaseHelper.instance.getAllJogos();
      setState(() {
        _jogos = jogos;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  List<Jogo> get _jogosAoVivo =>
      _jogos.where((j) => j.status == 'ao_vivo').toList();

  List<Jogo> get _proximosJogos =>
      _jogos.where((j) => j.status == 'agendado').toList();

  List<Jogo> get _jogosFinalizados =>
      _jogos.where((j) => j.status == 'finalizado').toList();

  Future<void> _deletarJogo(Jogo jogo) async {
    if (jogo.id == null) return;
    await DatabaseHelper.instance.deleteJogo(jogo.id!);
    _carregarJogos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const TopAppBar(title: 'COPA DO MUNDO 2026'),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarJogos,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100, top: 16),
                children: [
                  if (_jogosAoVivo.isNotEmpty) ...[
                    _buildSecaoAoVivo(),
                    const SizedBox(height: 24),
                  ],
                  if (_proximosJogos.isNotEmpty) ...[
                    _buildSecaoProximos(),
                    const SizedBox(height: 24),
                  ],
                  if (_jogosFinalizados.isNotEmpty) ...[
                    _buildSecaoResultados(),
                  ],
                  if (_jogos.isEmpty)
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
          _carregarJogos();
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
            ).then((_) => _carregarJogos());
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

  Widget _buildSecaoAoVivo() {
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
                      '${_jogosAoVivo.length} Ativos',
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
            itemCount: _jogosAoVivo.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 300,
                child: CardJogo(
                  jogo: _jogosAoVivo[index],
                  onTap: () => _editarJogo(_jogosAoVivo[index]),
                  onDelete: () => _deletarJogo(_jogosAoVivo[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecaoProximos() {
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
        ..._proximosJogos.map((jogo) => CardJogo(
          jogo: jogo,
          onTap: () => _editarJogo(jogo),
          onDelete: () => _deletarJogo(jogo),
        )),
      ],
    );
  }

  Widget _buildSecaoResultados() {
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
        ..._jogosFinalizados.map((jogo) => CardJogo(
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
    _carregarJogos();
  }
}
