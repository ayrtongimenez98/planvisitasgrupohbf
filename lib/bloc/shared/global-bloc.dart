import 'package:planvisitas_grupohbf/bloc/clientes-bloc/clientes.bloc.dart';
import 'package:planvisitas_grupohbf/bloc/datos-menores-bloc/estado-motivo.bloc.dart';
import 'package:planvisitas_grupohbf/bloc/hoja-de-ruta-bloc/hoja-de-ruta-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/session-bloc/session-bloc.dart';

import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';
import 'package:planvisitas_grupohbf/bloc/visitas-bloc/visitas.bloc.dart';
import 'package:planvisitas_grupohbf/bloc/visitas-offline-bloc/visitas-offline.bloc.dart';

class GlobalBloc implements Bloc {
  SessionBloc sessionBloc;
  PlanSemanalBloc planSemanalBloc;
  ClientesBloc clientesBloc;
  EstadoMotivoBloc estadoMotivoBloc;
  VisitasOfflineBloc visitasOfflineBloc;
  VisitasBloc visitasBloc;

  GlobalBloc() {
    visitasOfflineBloc = VisitasOfflineBloc();
    estadoMotivoBloc = EstadoMotivoBloc();
    clientesBloc = ClientesBloc();
    sessionBloc = SessionBloc();
    planSemanalBloc = PlanSemanalBloc();
    visitasBloc = VisitasBloc();
  }

  void dispose() {
    visitasOfflineBloc.dispose();
    estadoMotivoBloc.dispose();
    clientesBloc.dispose();
    sessionBloc.dispose();
    planSemanalBloc.dispose();
    visitasBloc.dispose();
  }
}
