import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jogo.dart';
import '../models/classificacao_time.dart';
import '../data/database_helper.dart';

class JogosState {
  final List<Jogo> jogos;
  final bool carregando;
  final String? erro;
  final String grupoSelecionado;
  final List<ClassificacaoTime> classificacao;

  const JogosState({
    this.jogos = const [],
    this.carregando = false,
    this.erro,
    this.grupoSelecionado = 'Grupo A',
    this.classificacao = const [],
  });

  JogosState copyWith({
    List<Jogo>? jogos,
    bool? carregando,
    bool clearErro = false,
    String? erro,
    String? grupoSelecionado,
    List<ClassificacaoTime>? classificacao,
  }) {
    return JogosState(
      jogos: jogos ?? this.jogos,
      carregando: carregando ?? this.carregando,
      erro: clearErro ? null : (erro ?? this.erro),
      grupoSelecionado: grupoSelecionado ?? this.grupoSelecionado,
      classificacao: classificacao ?? this.classificacao,
    );
  }

  List<Jogo> get jogosAoVivo =>
      jogos.where((j) => j.status == 'ao_vivo').toList();

  List<Jogo> get jogosAgendados =>
      jogos.where((j) => j.status == 'agendado').toList();

  List<Jogo> get jogosFinalizados =>
      jogos.where((j) => j.status == 'finalizado').toList();
}

final jogosProvider =
    NotifierProvider<JogosNotifier, JogosState>(JogosNotifier.new);

class JogosNotifier extends Notifier<JogosState> {
  @override
  JogosState build() => const JogosState();

  Future<void> carregarJogos() async {
    state = state.copyWith(carregando: true, clearErro: true);

    try {
      final jogos = await DatabaseHelper.instance.getAllJogos();
      final classif = DatabaseHelper.calcularClassificacao(
        jogos, state.grupoSelecionado,
      );
      state = state.copyWith(
        jogos: jogos,
        classificacao: classif,
        carregando: false,
      );
    } catch (e) {
      state = state.copyWith(
        carregando: false,
        erro: 'Erro ao carregar jogos: $e',
      );
    }
  }

  void selecionarGrupo(String grupo) {
    final classif = DatabaseHelper.calcularClassificacao(state.jogos, grupo);
    state = state.copyWith(grupoSelecionado: grupo, classificacao: classif);
  }

  Future<bool> adicionarJogo(Jogo jogo) async {
    try {
      await DatabaseHelper.instance.insertJogo(jogo);
      await carregarJogos();
      return true;
    } catch (e) {
      state = state.copyWith(erro: 'Erro ao cadastrar jogo: $e');
      return false;
    }
  }

  Future<bool> atualizarJogo(Jogo jogo) async {
    try {
      await DatabaseHelper.instance.updateJogo(jogo);
      await carregarJogos();
      return true;
    } catch (e) {
      state = state.copyWith(erro: 'Erro ao atualizar jogo: $e');
      return false;
    }
  }

  Future<bool> removerJogo(int id) async {
    try {
      await DatabaseHelper.instance.deleteJogo(id);
      await carregarJogos();
      return true;
    } catch (e) {
      state = state.copyWith(erro: 'Erro ao remover jogo: $e');
      return false;
    }
  }
}
