import 'package:flutter/material.dart';
import 'package:planvisitas_grupohbf/bloc/shared/bloc-provider.dart';

class BlocProviderState extends State<BlocProvider> {
  // 4
  @override
  Widget build(BuildContext context) => widget.child;

  // 5
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
