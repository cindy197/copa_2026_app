import 'package:flutter/material.dart';
import '../models/jogo.dart';
import '../widgets/card_jogo.dart';

class TelaListaJogos extends StatefulWidget {
  const TelaListaJogos({super.key});

  @override
  State<TelaListaJogos> createState() => _TelaListaJogosState();
}

class _TelaListaJogosState extends State<TelaListaJogos> {
  final List<Jogo> jogos = [
    Jogo(timeA: 'Brasil', timeB: 'Argentina'),
    Jogo(timeA: 'França', timeB: 'Alemanha'),
    Jogo(timeA: 'Espanha', timeB: 'Itália'),
    
    Jogo(timeA: 'Austrália', timeB: 'Nova Zelândia'),
  ];

  final TextEditingController timeAController = TextEditingController();  
  final TextEditingController timeBController = TextEditingController();

  int? IndexEditando;

  void adicionarJogo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastre um novo jogo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timeAController,
                decoration: const InputDecoration(
                  labelText: 'Time A',
                ),
              ),
              TextField(
                controller: timeBController,
                decoration: const InputDecoration(
                  labelText: 'Time B',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String timeA = timeAController.text.trim();
                String timeB = timeBController.text.trim();

                if (timeA.isEmpty || timeB.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, preencha ambos os campos.')),
                  );
                  return;
                }

                setState(() {
                  if (IndexEditando != null) {
                    jogos[IndexEditando!] = Jogo(timeA: timeA, timeB: timeB);
                  } else {
                    jogos.add(
                      Jogo(timeA: timeA, timeB: timeB),
                    );
                  }
                });

                timeAController.clear();
                timeBController.clear();

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),            
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Minha Copa 2026!'),
    ),

    body: ListView.builder(
      itemCount: jogos.length,

      itemBuilder: (context, index) {
        return CardJogo(
          jogo: jogos[index],

          onTap: () {
            IndexEditando = index;

            timeAController.text = jogos[index].timeA;
            timeBController.text = jogos[index].timeB;

            adicionarJogo();
          },

          onDelete: () {
            setState(() {
              jogos.removeAt(index);
            });
          },
        );
      },
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: adicionarJogo,
      child: const Icon(Icons.add),
    ),
  );
}
}