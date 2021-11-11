import 'package:planvisitas_grupohbf/bloc/hoja-de-ruta-bloc/hoja-de-ruta-bloc.dart';
import 'package:planvisitas_grupohbf/bloc/session-bloc/session-bloc.dart';

import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';

class GlobalBloc implements Bloc {
  SessionBloc sessionBloc;
  PlanSemanalBloc planSemanalBloc;

  GlobalBloc() {
    sessionBloc = SessionBloc();
    planSemanalBloc = PlanSemanalBloc();
  }

  void dispose() {
    sessionBloc.dispose();
    planSemanalBloc.dispose();
  }
}
