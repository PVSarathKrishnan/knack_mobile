import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:knack/data/models/user_model.dart';
import 'package:knack/data/repositories/user_repo.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  User? user = FirebaseAuth.instance.currentUser;

  UserRepo userRepo = UserRepo();

  UserBloc(this.userRepo) : super(UserInitialState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoadingState());

      await Future.delayed(Duration(seconds: 1));

      try {
        final data = await userRepo.getUser();
        emit (UserLoadedState(userList:data));
      }  on FirebaseException catch(e){
      emit(UserErroState(errorMessage: "error loading user data ${e.message}"));
    }

     });


    
  }
}