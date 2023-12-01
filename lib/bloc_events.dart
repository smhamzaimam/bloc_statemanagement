
/* *****************************  Bloc Events Start ***************************** */
abstract class BlocEvent {}

class InitialBlocEvent<T> extends BlocEvent {
  T data;
  InitialBlocEvent({
    required this.data,
  }) : super();
}

class LoadingBlocEvent<T> extends BlocEvent {
  LoadingBlocEvent() : super();
}

class RefreshBlocEvent extends BlocEvent {
  RefreshBlocEvent() : super();
}

class DisposeBlocEvent<T> extends BlocEvent {
  DisposeBlocEvent() : super();
}

/* *****************************  Bloc Events Ends ***************************** */