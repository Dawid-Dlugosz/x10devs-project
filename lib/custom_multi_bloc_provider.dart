import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:x10devs/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:x10devs/injectable_config.dart';

class CustomMultiBlocProvider extends StatelessWidget {
  const CustomMultiBlocProvider({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => getIt<AuthCubit>(),),
    ], child: child,);
  }
}