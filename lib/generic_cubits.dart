import 'package:flutter_bloc/flutter_bloc.dart';

import 'generic_states.dart';

class GetDataCubit extends Cubit<BlocState> {
  GetDataCubit(InitialState initializeState) : super(initializeState);

  _emitState(BlocState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  emitDataState<T>(
      {required Future<T> Function() fetchData,
      required String errorMessage,
      required String dataNotFoundMessage}) async {
    try {
      _emitState(LoadingState());
      final data = await fetchData();
      if (data != null) {
        if (!super.isClosed) {
          _emitState(DataFoundState<T>(data: data));
        }
      } else {
        if (!super.isClosed) {
          _emitState(DataNotFoundState(
            message: dataNotFoundMessage,
          ));
        }
      }
    } catch (e) {
      if (!super.isClosed) {
        _emitState(ErrorState(
          message: errorMessage,
        ));
      }
    }
  }
}

class GetPaginatedDataCubit<T> extends Cubit<BlocState> {
  final List<T> _data = [];
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

  ///Use to get length of list
  int getDataLength() => _data.length;

  ///Use to get item by index from list
  T getListItem(int index) => _data[index];

  _emitState(BlocState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  ///Refresh bool is to refresh all data can be used with refreshindicator widget
  getData({bool refreshPagination = false}) async {
    try {
// reseting cubit data in case of referesh indicator is pulled
      if (refreshPagination) {
        _data.clear();
        _page = 1;
        _hasMore = true;
      }
      _emitState(UpdatePageState(hasMoreData: _hasMore));
// Stoping api call to hit again during async call
      if (!_loading) {
        _loading = true;
        final response = await this.dataFetchFunction(_page);
// handing to stop pagination
        if (response.isEmpty || response.length < _limit) {
          _hasMore = false;
        } else {
// increamenting the page in case of more data available
          _page++;
        }
        _data.addAll(response);
        _loading = false;
// emiting state to update UI with new data and has more to show loading until pagination is stopped
        _emitState(UpdatePageState(hasMoreData: _hasMore));
      }

      if (this._data.isEmpty && !_hasMore) {
        _emitState(DataNotFoundState(message: dataNotFoundMessage));
      }
    } catch (e) {
//emiting error state in case of any failure in api call
      _emitState(ErrorState(message: errorMessage));
    }
  }
}
