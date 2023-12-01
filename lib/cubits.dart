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
  List<T> data = [];
  int page = 1;
  bool loading = false, hasMore = true;
  late Future<List<T>> Function(int page) fetchData;
  final int limit = 10;

  GetPaginatedDataCubit(BlocState initialState) : super(initialState);

  getData({bool refreshPagination = false}) async {
    if (refreshPagination) {
      data.clear();
      page = 1;
      hasMore = true;

      emit(UpdatePageBlocState(hasMoreData: hasMore));
    }
    if (!loading) {
      loading = true;
      final response = await this.fetchData(page);
      if (response.isEmpty || response.length < limit) {
        hasMore = false;
      } else {
        page++;
      }
      data.addAll(response);
      loading = false;

      emit(UpdatePageBlocState(hasMoreData: hasMore));
    }

    if (this.data.isEmpty) {
      emit(DataNotFoundState(message: 'No data found'));
    }
  }
}
