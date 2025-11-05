import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  AuthBloc({required UserSignUp userSignUp, required UserSignIn userSignIn})
    : _userSignUp = userSignUp,
      _userSignIn = userSignIn,
      super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignup);
    on<AuthSignIn>(_onAuthSignIn);
  }

  void _onAuthSignup(AuthSignUp event, Emitter<AuthState> emit) async {
    (event, emit) async {
      emit(AuthLoading());
      final response = await _userSignUp(
        UserSignUpParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      response.fold(
        (l) => emit(AuthFailure(l.message)),
        (userId) => emit(AuthSuccess(userId)),
      );
    };
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    (event, emit) async {
      emit(AuthLoading());
      final response = await _userSignIn(
        UserLoginParams(email: event.email, password: event.password),
      );
      response.fold(
        (l) => emit(AuthFailure(l.message)),
        (userId) => emit(AuthSuccess(userId)),
      );
    };
  }
}
