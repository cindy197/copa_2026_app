import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/copa_data.dart';
import '../models/jogo.dart';
import '../theme/app_theme.dart';
import '../providers/jogos_provider.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class TelaCadastroJogo extends ConsumerStatefulWidget {
  const TelaCadastroJogo({super.key});

  @override
  ConsumerState<TelaCadastroJogo> createState() => _TelaCadastroJogoState();
}

class _TelaCadastroJogoState extends ConsumerState<TelaCadastroJogo> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();

  String? _timeASelecionado;
  String? _timeBSelecionado;
  String? _dataSelecionada;
  String? _estadioSelecionado;
  int _golsA = 0;
  int _golsB = 0;
  String? _grupoSelecionado;

  Future<void> _salvarJogo() async {
    if (_timeASelecionado == null || _timeBSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ambos os times')),
      );
      return;
    }
    if (_timeASelecionado == _timeBSelecionado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os times devem ser diferentes')),
      );
      return;
    }

    final jogo = Jogo(
      timeA: _timeASelecionado!,
      timeB: _timeBSelecionado!,
      golsA: _golsA,
      golsB: _golsB,
      data: _dataSelecionada,
      estadio: _estadioSelecionado,
      grupo: _grupoSelecionado,
      status: _golsA > 0 || _golsB > 0 ? 'finalizado' : 'agendado',
    );

    final sucesso = await ref.read(jogosProvider.notifier).adicionarJogo(jogo);

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jogo cadastrado com sucesso!'),
          backgroundColor: AppTheme.secondaryContainer,
        ),
      );
      Navigator.pop(context, true);
    } else if (!sucesso && mounted) {
      final erro = ref.read(jogosProvider).erro ?? 'Erro desconhecido ao cadastrar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _limparFormulario() {
    _dataController.clear();
    setState(() {
      _timeASelecionado = null;
      _timeBSelecionado = null;
      _dataSelecionada = null;
      _estadioSelecionado = null;
      _grupoSelecionado = null;
      _golsA = 0;
      _golsB = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: TopAppBar(
        title: 'COPA DO MUNDO 2026',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 120 + MediaQuery.of(context).padding.bottom),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(),
              const SizedBox(height: 24),
              _buildTeamsSection(),
              const SizedBox(height: 16),
              _buildLogisticsSection(),
              const SizedBox(height: 16),
              _buildScoreSection(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) Navigator.pop(context, true);
        },
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 196,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x33111415),
            Color(0xE6111415),
          ],
        ),
        image: const DecorationImage(
          image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCzOjDiuPdvurKMX1NGPqXJ3NUoZvNN43CL9fzVImYNbdRW6t3vtUSusPdiXWkC3p-qtcORaQWP5IX9n3jG__dLFy7AwKeDs2EgSCOA0V7WnlchZy0Xfz6kkGnoEqF6wMGEN8mt1tBWbspZDtboQFuYId90AO9hSsZ4xABmgUejKARfwWXGYuKaZwr4g-dGaS1XQe_iUsqFo_RTRHjF90Ax9RKoql6ky8zsxqie3u7VdC8bP0TYzy_nu1dt2hgRUgwZxVRrze2Cp0Nu'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'ADMINISTRAÇÃO DE PARTIDA',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                letterSpacing: 3,
                color: AppTheme.secondary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cadastrar Nova Partida',
              style: TextStyle(
                fontFamily: 'Archivo Narrow',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsSection() {
    final timesDoGrupo = CopaData.timesDoGrupo(_grupoSelecionado);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDropdown(
            label: 'GRUPO',
            icon: Icons.emoji_events,
            value: _grupoSelecionado,
            items: CopaData.grupos,
            onChanged: (v) => setState(() {
              _grupoSelecionado = v;
              _timeASelecionado = null;
              _timeBSelecionado = null;
            }),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'TIME DA CASA',
            icon: Icons.home,
            value: _timeASelecionado,
            items: timesDoGrupo.where((t) => t != _timeBSelecionado).toList(),
            onChanged: (v) => setState(() => _timeASelecionado = v),
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'TIME VISITANTE',
            icon: Icons.flight,
            value: _timeBSelecionado,
            items: timesDoGrupo.where((t) => t != _timeASelecionado).toList(),
            onChanged: (v) => setState(() => _timeBSelecionado = v),
          ),
        ],
      ),
    );
  }

  Widget _buildLogisticsSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_month, size: 18, color: AppTheme.onSurfaceVariant),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'DATA DA PARTIDA',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          letterSpacing: 0.05,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dataController,
                  style: const TextStyle(color: AppTheme.onSurface),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.surfaceContainerHigh,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.outlineVariant),
                    ),
                    hintText: 'Selecione a data',
                    hintStyle: const TextStyle(color: AppTheme.onSurfaceVariant),
                    suffixIcon: const Icon(Icons.date_range, color: AppTheme.primaryContainer),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2027),
                    );
                    if (date != null) {
                      final formatted = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                      _dataController.text = formatted;
                      setState(() {
                        _dataSelecionada = formatted;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _buildDropdown(
              label: 'ESTÁDIO',
              icon: Icons.stadium,
              value: _estadioSelecionado,
              items: CopaData.estadios,
              onChanged: (v) => setState(() => _estadioSelecionado = v),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PLACAR INICIAL (OPCIONAL)',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              letterSpacing: 0.05,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildScoreStepper('CASA', _golsA, AppTheme.primaryContainer, (v) => setState(() => _golsA = v))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  ':',
                  style: TextStyle(fontSize: 28, color: AppTheme.outlineVariant),
                ),
              ),
              Expanded(child: _buildScoreStepper('VISITANTE', _golsB, AppTheme.secondaryContainer, (v) => setState(() => _golsB = v))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreStepper(String label, int value, Color accentColor, ValueChanged<int> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => onChanged((value - 1).clamp(0, 99)),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.remove, color: AppTheme.primary, size: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 24,
                    color: accentColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onChanged((value + 1).clamp(0, 99)),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add, color: AppTheme.primary, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _salvarJogo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryContainer,
              foregroundColor: AppTheme.onPrimaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 8,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'CADASTRAR PARTIDA',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Archivo Narrow',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: _limparFormulario,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.secondary,
              side: const BorderSide(color: AppTheme.secondary, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'LIMPAR RASCUNHO',
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 14,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  letterSpacing: 0.05,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerHigh,
            border: Border.all(color: AppTheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppTheme.surfaceContainerHigh,
              hint: const Text('Selecionar', style: TextStyle(color: AppTheme.onSurfaceVariant)),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: AppTheme.onSurface)),
              )).toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.expand_more, color: AppTheme.onSurfaceVariant),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }
}
