import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../theme/app_theme.dart';

class CardJogo extends StatelessWidget {
  final Jogo jogo;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CardJogo({
    super.key,
    required this.jogo,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return switch (jogo.status) {
      'ao_vivo' => _buildLiveCard(),
      'finalizado' => _buildResultCard(),
      _ => _buildUpcomingCard(),
    };
  }

  String _textValue(String? value, [String fallback = '--']) {
    final trimmed = value?.trim();
    return (trimmed != null && trimmed.isNotEmpty) ? trimmed : fallback;
  }

  String _formattedTime(String? isoDate) {
    if (isoDate == null || isoDate.length < 16) return '--:--';
    try {
      return isoDate.substring(11, 16);
    } catch (_) {
      return '--:--';
    }
  }

  Widget _buildLiveCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D2021), Color(0xFF111415)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            left: BorderSide(color: AppTheme.surfaceTint, width: 4),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _textValue(jogo.grupo, 'Grupo'),
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 12,
                        color: AppTheme.primaryContainer,
                      ),
                    ),
                  ),
                  Row(
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
                      const Text(
                        'AO VIVO',
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          color: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.surfaceContainerHigh,
                            border: Border.all(color: AppTheme.outlineVariant),
                          ),
                          child: const Icon(Icons.flag, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _textValue(jogo.timeA, 'Time A'),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Archivo Narrow',
                            fontSize: 24,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        "68'",
                        style: TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 12,
                          color: AppTheme.secondaryContainer,
                        ),
                      ),
                      Text(
                        '${jogo.golsA} - ${jogo.golsB}',
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryContainer,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.surfaceContainerHigh,
                            border: Border.all(color: AppTheme.outlineVariant),
                          ),
                          child: const Icon(Icons.flag, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _textValue(jogo.timeB, 'Time B'),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Archivo Narrow',
                            fontSize: 24,
                            color: AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 18, color: AppTheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    _textValue(jogo.estadio, 'Estádio não informado'),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flag, size: 24),
                    const SizedBox(width: 8),
                    Text(_textValue(jogo.timeA, 'Time A'), style: const TextStyle(fontSize: 18, color: AppTheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.flag, size: 24),
                    const SizedBox(width: 8),
                    Text(_textValue(jogo.timeB, 'Time B'), style: const TextStyle(fontSize: 18, color: AppTheme.onSurface)),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Text(
              '${jogo.golsA} - ${jogo.golsB}',
              style: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Row(
              children: [
                const Icon(Icons.flag, size: 28),
                const SizedBox(width: 8),
                Text(_textValue(jogo.timeA, 'Time A'), style: const TextStyle(fontSize: 18, color: AppTheme.onSurface)),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  _formattedTime(jogo.data),
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 14,
                    color: AppTheme.primaryContainer,
                  ),
                ),
                Text(
                  _formatDate(jogo.data),
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 10,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(_textValue(jogo.timeB, 'Time B'), style: const TextStyle(fontSize: 18, color: AppTheme.onSurface)),
                const SizedBox(width: 8),
                const Icon(Icons.flag, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.length < 10) return '--';
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    final parts = isoDate.split('-');
    if (parts.length < 3) return '--';
    final month = int.tryParse(parts[1]) ?? 0;
    final dayPart = parts[2].split(RegExp(r'[T ]')).first;
    final day = int.tryParse(dayPart) ?? 0;
    if (month < 1 || month > 12 || day < 1 || day > 31) return '--';
    return '${months[month - 1]} $day';
  }
}
