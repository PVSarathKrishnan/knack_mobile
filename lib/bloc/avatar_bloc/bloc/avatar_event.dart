part of 'avatar_bloc.dart';

sealed class AvatarEvent extends Equatable {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class AvatarPickerInitialEvent extends AvatarEvent{}

class AvatarUpdateEvent extends AvatarEvent{}