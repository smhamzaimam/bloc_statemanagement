

/* *****************************  Bloc State Start ***************************** */
abstract class BlocState {
  BlocState();
}

class InitialState extends BlocState {
  dynamic data;
  InitialState(this.data) : super();
}

class LoadingState extends BlocState {
  LoadingState() : super();
}

class DataFoundState<T> extends BlocState {
  T data;
  DataFoundState({required this.data})
      : super();
}

class DataNotFoundState extends BlocState {
  String message;
  DataNotFoundState({required this.message})
      : super();
}

class ErrorState extends BlocState {
  String message;
  ErrorState({required this.message})
      : super();
}

class UpdatePageBlocState extends BlocState {
  bool hasMoreData = false;
  UpdatePageBlocState({required this.hasMoreData})
      : super();
}

/* *****************************  Bloc State End ***************************** */
