import 'package:flutter/material.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider-state.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  final Widget child;
  final T bloc;
  const BlocProvider({Key key, this.bloc, this.child}) : super(key: key);
  // 2
  static T of<T extends Bloc>(BuildContext context) {
    final BlocProvider<T> provider = context.findAncestorWidgetOfExactType();
    return provider.bloc;
  }

  @override
  State createState() => BlocProviderState();
}
