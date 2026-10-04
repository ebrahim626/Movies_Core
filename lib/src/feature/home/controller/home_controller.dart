import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/feature/home/repository/home_repository.dart';
import '../../../core/network/api_client.export.dart';

final homeProvider = AsyncNotifierProvider<HomeProvider, void>(
  HomeProvider.new,
);

class HomeProvider extends AsyncNotifier <void> {
  @override
  FutureOr<void> build() async {
    final repository = ref.read(homeRepository);
    final response = await repository.topRatedMovies();

  }


}