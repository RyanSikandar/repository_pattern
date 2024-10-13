import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repo_pattern/bloc/user_event.dart';
import 'package:repo_pattern/bloc/user_state.dart';
import 'package:repo_pattern/data/repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitialState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        final users = await userRepository.getUsers();
        emit(UserSuccessState(users));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
