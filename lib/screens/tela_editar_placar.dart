import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/jogo.dart';
import '../theme/app_theme.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';

class TelaEditarPlacar extends StatefulWidget {
  final Jogo jogo;

  const TelaEditarPlacar({super.key, required this.jogo});

  @override
  State<TelaEditarPlacar> createState() => _TelaEditarPlacarState();
}

class _TelaEditarPlacarState extends State<TelaEditarPlacar> {
  late int _golsA;
  late int _golsB;
  late String _status;

  @override
  void initState() {
    super.initState();
    _golsA = widget.jogo.golsA ?? 0;
    _golsB = widget.jogo.golsB ?? 0;
    _status = widget.jogo.status;
  }

  String _textValue(String? value, [String fallback = '---']) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : fallback;
  }

  String _safeGroupLabel(String? group) {
    final value = group?.trim();
    return value != null && value.isNotEmpty ? '$value • Partida 42' : 'Partida';
  }

  Future<void> _atualizarPlacar() async {
    widget.jogo.golsA = _golsA;
    widget.jogo.golsB = _golsB;
    widget.jogo.status = _status;

    await DatabaseHelper.instance.updateJogo(widget.jogo);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Placar atualizado!'),
          backgroundColor: AppTheme.secondaryContainer,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _deletarJogo() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainer,
        title: const Text('Deletar jogo?', style: TextStyle(color: AppTheme.onSurface)),
        content: const Text('Esta ação não pode ser desfeita.', style: TextStyle(color: AppTheme.onSurfaceVariant)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Deletar', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );

    if (confirm == true && widget.jogo.id != null) {
      await DatabaseHelper.instance.deleteJogo(widget.jogo.id!);
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: TopAppBar(
        title: 'EDITAR PLACAR',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Column(
          children: [
            _buildMatchContextCard(),
            const SizedBox(height: 24),
            _buildScoreSection(),
            const SizedBox(height: 24),
            _buildStatusSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildMatchContextCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            _safeGroupLabel(widget.jogo.grupo),
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: AppTheme.secondaryContainer,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceBright,
                      border: Border.all(color: AppTheme.outlineVariant),
                    ),
                    child: const Icon(Icons.flag, size: 32, color: AppTheme.primaryContainer),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _textValue(widget.jogo.timeA, 'Time A'),
                    style: const TextStyle(
                      fontFamily: 'Archivo Narrow',
                      fontSize: 24,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const Text(
                'X',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryContainer,
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceBright,
                      border: Border.all(color: AppTheme.outlineVariant),
                    ),
                    child: const Icon(Icons.flag, size: 32, color: AppTheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _textValue(widget.jogo.timeB, 'Time B'),
                    style: const TextStyle(
                      fontFamily: 'Archivo Narrow',
                      fontSize: 24,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.jogo.estadio ?? 'Estádio não informado',
              style: const TextStyle(
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

  Widget _buildScoreSection() {
    return Row(
      children: [
        Expanded(child: _buildScoreStepper(_textValue(widget.jogo.timeA, 'Time A'), _golsA, AppTheme.primaryContainer, (v) => setState(() => _golsA = v))),
        const SizedBox(width: 12),
        Expanded(child: _buildScoreStepper(_textValue(widget.jogo.timeB, 'Time B'), _golsB, AppTheme.secondaryContainer, (v) => setState(() => _golsB = v))),
      ],
    );
  }

  Widget _buildScoreStepper(String label, int value, Color accentColor, ValueChanged<int> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => onChanged((value - 1).clamp(0, 99)),
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.remove, color: AppTheme.primary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onChanged((value + 1).clamp(0, 99)),
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: AppTheme.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STATUS DA PARTIDA',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontSize: 12,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusChip('Finalizado', 'finalizado'),
              const SizedBox(width: 8),
              _buildStatusChip('Ao Vivo', 'ao_vivo'),
              const SizedBox(width: 8),
              _buildStatusChip('Agendado', 'agendado'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    final isActive = _status == value;
    return GestureDetector(
      onTap: () => setState(() => _status = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? AppTheme.primaryContainer : AppTheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 12,
            color: isActive ? AppTheme.onPrimaryContainer : AppTheme.onSurfaceVariant,
          ),
        ),
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
            onPressed: _atualizarPlacar,
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
                Text(
                  'ATUALIZAR PLACAR',
                  style: TextStyle(fontFamily: 'Archivo Narrow', fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _deletarJogo,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: const BorderSide(color: AppTheme.error, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever),
                SizedBox(width: 8),
                Text(
                  'DELETAR PARTIDA',
                  style: TextStyle(fontFamily: 'Archivo Narrow', fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
