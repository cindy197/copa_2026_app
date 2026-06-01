import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jogo.dart';
import '../data/database_helper.dart';

final jogosProvider = ChangeNotifierProvider<JogosProvider>((ref) {
  return JogosProvider();
});

class JogosProvider extends ChangeNotifier {
  List<Jogo> _jogos = [];
  bool _carregando = false;
  String? _erro;

  List<Jogo> get jogos => _jogos;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarJogos() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      _jogos = await DatabaseHelper.instance.getAllJogos();
    } catch (e) {
      _erro = 'Erro ao carregar jogos: $e';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> adicionarJogo(Jogo jogo) async {
    try {
      await DatabaseHelper.instance.insertJogo(jogo);
      await carregarJogos();
      return true;
    } catch (e) {
      _erro = 'Erro ao cadastrar jogo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizarJogo(Jogo jogo) async {
    try {
      await DatabaseHelper.instance.updateJogo(jogo);
      await carregarJogos();
      return true;
    } catch (e) {
      _erro = 'Erro ao atualizar jogo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removerJogo(int id) async {
    try {
      await DatabaseHelper.instance.deleteJogo(id);
      await carregarJogos();
      return true;
    } catch (e) {
      _erro = 'Erro ao remover jogo: $e';
      notifyListeners();
      return false;
    }
  }

  List<Jogo> get jogosAoVivo =>
      _jogos.where((j) => j.status == 'ao_vivo').toList();

  List<Jogo> get jogosAgendados =>
      _jogos.where((j) => j.status == 'agendado').toList();

  List<Jogo> get jogosFinalizados =>
      _jogos.where((j) => j.status == 'finalizado').toList();
}
