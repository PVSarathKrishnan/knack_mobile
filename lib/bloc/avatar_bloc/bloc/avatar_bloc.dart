import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'avatar_event.dart';
part 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  AvatarBloc() : super(AvatarPickerInitial()) {
    on<AvatarUpdateEvent>(uploadImage);
    on<AvatarPickerInitialEvent>(initialImage);
  }

  FutureOr<void> uploadImage(AvatarUpdateEvent event, Emitter<AvatarState> emit) async {
    try {
      
    } catch (e) {
      
    }
  }

  FutureOr<void> initialImage(AvatarPickerInitialEvent event, Emitter<AvatarState> emit) async {
  }
}
