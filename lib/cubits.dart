import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_states.dart';

class GetDataCubit extends Cubit<BlocState> {
  GetDataCubit(InitialState initializeState) : super(initializeState);

  emitDataState<T>(
      {required Future<T> Function() fetchData,
      required String errorMessage,
      required String dataNotFoundMessage}) async {
    try {
      emit(LoadingState());
      final data = await fetchData();
      if (data != null) {
        if (!super.isClosed) {
          emit(DataFoundState<T>(data: data));
        }
      } else {
        if (!super.isClosed) {
          emit(DataNotFoundState(
            message: dataNotFoundMessage,
          ));
        }
      }
    } catch (e) {
      if (!super.isClosed) {
        emit(ErrorState(
          message: errorMessage,
        ));
      }
    }
  }
}

class GetPaginatedDataCubit<T> extends Cubit<BlocState> {
  List<T> _data = [];
  int _page = 1;
  bool _loading = false, _hasMore = true;
  late Future<List<T>> Function(int page) dataFetchFunction;
  final int _limit = 10;
  final String errorMessage, dataNotFoundMessage;


  GetPaginatedDataCubit.initialize({
    required BlocState initialState,
    required this.dataFetchFunction,
    required this.errorMessage,
    required this.dataNotFoundMessage,
  }) : super(initialState);
int getDataLength()=>_data.length;

T getListItem(int index)=>_data[index];

  getData({bool refreshPagination = false}) async {
    try {
      if (refreshPagination) {
        _data.clear();
        _page = 1;
        _hasMore = true;  
      }
      emit(UpdatePageState(hasMoreData: _hasMore));
      if (!_loading) {
        _loading = true;
        final response = await this.dataFetchFunction(_page);
        if (response.isEmpty || response.length < _limit) {
          _hasMore = false;
        } else {
          _page++;
        }
        _data.addAll(response);
        _loading = false;

        emit(UpdatePageState(hasMoreData: _hasMore));
      }

      if (this._data.isEmpty&&!_hasMore) {
        emit(DataNotFoundState(message: dataNotFoundMessage));
      }
    } catch (e) {
      emit(ErrorState(message: errorMessage));
    }
  }
}
