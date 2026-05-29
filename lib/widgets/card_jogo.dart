import 'package:flutter/material.dart';
import '../models/jogo.dart';

class CardJogo extends StatelessWidget {
  final Jogo jogo;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const CardJogo({
    super.key,
    required this.jogo,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  ),

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  ),

  child: Padding(
    padding: const EdgeInsets.all(16),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                jogo.timeA,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                jogo.timeB,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

Row(
  children: const [
    Icon(
      Icons.calendar_month,
      size: 16,
      color: Colors.grey,
    ),

    SizedBox(width: 6),

    Text(
      'Junho 2026',
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
  ],
),

const SizedBox(height: 6),

Row(
  children: const [
    Icon(
      Icons.stadium,
      size: 16,
      color: Colors.grey,
    ),

    SizedBox(width: 6),

    Text(
      'MetLife Stadium',
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
  ],
),
        const Text(
          'VS',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ],
    ),
  ),
);
}
} 