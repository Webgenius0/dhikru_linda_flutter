import 'dart:developer';
import 'package:dhikru_linda_flutter/features/home/model/get_profile_model.dart';
import 'package:dhikru_linda_flutter/networks/rx_base.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

final class GetProfileRx extends RxResponseInt<GetProfileModel> {
  final api = GetProfileApi.instance;

  GetProfileRx({required super.empty, required super.dataFetcher});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  ValueStream<GetProfileModel> get getProfileData => dataFetcher.stream;

  Future<GetProfileModel?> getProfileInfo() async {
    isLoading.value = true;
    try {
      final data = await api.getProfileApi();
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      handleErrorWithReturn(error);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
    return null;
  }
}
