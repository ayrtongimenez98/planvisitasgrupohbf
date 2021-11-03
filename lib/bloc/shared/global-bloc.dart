import 'package:planvisitas_grupohbf/bloc/session-bloc/session-bloc.dart';

import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';

class GlobalBloc implements Bloc {
  SessionBloc sessionBloc;

  GlobalBloc() {
    sessionBloc = SessionBloc();
  }

  void dispose() {
    sessionBloc.dispose();
  }
}
