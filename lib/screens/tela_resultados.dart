import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/copa_data.dart';
import '../models/jogo.dart';
import '../models/classificacao_time.dart';
import '../theme/app_theme.dart';
import '../providers/jogos_provider.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class TelaResultados extends ConsumerStatefulWidget {
  const TelaResultados({super.key});

  @override
  ConsumerState<TelaResultados> createState() => _TelaResultadosState();
}

class _TelaResultadosState extends ConsumerState<TelaResultados> {
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
    final jogosFinalizados = state.jogosFinalizados;
    final carregando = state.carregando;
    final classificacao = state.classificacao;
    final grupoSelecionado = state.grupoSelecionado;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const TopAppBar(title: 'COPA DO MUNDO 2026'),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(jogosProvider.notifier).carregarJogos(),
              child: ListView(
                padding: EdgeInsets.only(
                  bottom: 100 + MediaQuery.of(context).padding.bottom,
                  top: 16,
                ),
                children: [
                  _buildHeroSummary(),
                  const SizedBox(height: 24),
                  _buildRecentResults(jogosFinalizados),
                  const SizedBox(height: 24),
                  _buildBentoGrid(classificacao, grupoSelecionado),
                  const SizedBox(height: 24),
                  _buildCtaSection(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) Navigator.pop(context);
        },
      ),
    );
  }

  String _shortTeamLabel(String? team) {
    if (team == null || team.trim().isEmpty) return '---';
    final normalized = team.trim().toUpperCase();
    return normalized.length <= 3 ? normalized : normalized.substring(0, 3);
  }

  String _safeGroupLabel(String? grupo) {
    final value = grupo?.trim();
    return value != null && value.isNotEmpty ? '$value • Final' : 'Partida';
  }

  Widget _buildHeroSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 14,
                        color: AppTheme.secondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      const Flexible(
                        child: Text(
                          'FASE: MATA-MATA',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            color: AppTheme.secondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'JULHO 2026',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Resumo do Torneio',
              style: TextStyle(
                fontFamily: 'Archivo Narrow',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'O caminho até a final se afunila enquanto gigantes caem e lendas surgem.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResults(List<Jogo> jogosFinalizados) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Últimos Resultados',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Archivo Narrow',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Text(
                    'Ver Tudo',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: AppTheme.secondaryContainer,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppTheme.secondaryContainer,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: jogosFinalizados.length,
            itemBuilder: (context, index) {
              final jogo = jogosFinalizados[index];
              return _buildResultShelfCard(jogo);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultShelfCard(Jogo jogo) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D2021), Color(0xFF111415)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            _safeGroupLabel(jogo.grupo),
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceBright,
                      border: Border.all(
                        color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Icon(Icons.flag, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _shortTeamLabel(jogo.timeA),
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                '${jogo.golsA} - ${jogo.golsB}',
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryContainer,
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceBright,
                      border: Border.all(
                        color: AppTheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Icon(Icons.flag, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _shortTeamLabel(jogo.timeB),
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'PARTIDA ENCERRADA',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 10,
              color: AppTheme.secondaryContainer,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoGrid(
    List<ClassificacaoTime> classificacao,
    String grupoSelecionado,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildGroupStandings(classificacao, grupoSelecionado),
          const SizedBox(height: 16),
          _buildGoldenBoot(),
        ],
      ),
    );
  }

  Widget _buildGroupStandings(
    List<ClassificacaoTime> classificacao,
    String grupoSelecionado,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.format_list_numbered,
                color: AppTheme.primaryContainer,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Classificação',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Archivo Narrow',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              value: grupoSelecionado,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceContainer,
              style: const TextStyle(
                fontFamily: 'Archivo Narrow',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryContainer,
              ),
              underline: const SizedBox(),
              items: CopaData.grupos
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (g) {
                if (g != null) {
                  ref.read(jogosProvider.notifier).selecionarGrupo(g);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildTableHeader(),
          if (classificacao.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Nenhum jogo finalizado neste grupo',
                  style: TextStyle(color: AppTheme.onSurfaceVariant),
                ),
              ),
            )
          else
            ...classificacao.map(
              (c) => _buildTableRow(
                c.time,
                c.jogos,
                c.saldoGols >= 0 ? '+${c.saldoGols}' : '${c.saldoGols}',
                c.pontos,
                isActive: c == classificacao.first,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'TIME',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'J',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'SG',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'P',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    String team,
    int p,
    String gd,
    int pts, {
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: isActive
            ? const Border(
                left: BorderSide(color: AppTheme.surfaceTint, width: 3),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(
                  Icons.flag,
                  size: 16,
                  color: AppTheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  team,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '$p',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              gd,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                color: AppTheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$pts',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? AppTheme.primaryContainer
                    : AppTheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenBoot() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.military_tech, color: AppTheme.primaryContainer),
              SizedBox(width: 8),
              Text(
                'Artilharia',
                style: TextStyle(
                  fontFamily: 'Archivo Narrow',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildScorerRow(1, 'Kylian Mbappé', 'France', 5),
          const SizedBox(height: 12),
          _buildScorerRow(2, 'Vinícius Jr.', 'Brazil', 4),
        ],
      ),
    );
  }

  Widget _buildScorerRow(int position, String name, String country, int goals) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryContainer.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(Icons.person, color: AppTheme.onSurfaceVariant),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: position == 1
                      ? AppTheme.primaryContainer
                      : AppTheme.surfaceBright,
                ),
                child: Center(
                  child: Text(
                    '$position',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: position == 1
                          ? AppTheme.onPrimaryContainer
                          : AppTheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.onSurface,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.flag,
                    size: 12,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    country,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$goals',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryContainer,
              ),
            ),
            const Text(
              'GOLS',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 10,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCtaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.secondaryContainer.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.secondary.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.notifications_active,
              size: 40,
              color: AppTheme.secondaryContainer,
            ),
            const SizedBox(height: 12),
            const Text(
              'Não Perca a Final!',
              style: TextStyle(
                fontFamily: 'Archivo Narrow',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadastre-se para receber alertas em tempo real sobre ingressos e novidades da Final da Copa do Mundo 2026.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryContainer,
                  foregroundColor: AppTheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.how_to_reg),
                    SizedBox(width: 8),
                    Text(
                      'CADASTRE-SE',
                      style: TextStyle(
                        fontFamily: 'Archivo Narrow',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
