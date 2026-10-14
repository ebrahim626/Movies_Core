import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/feature/home/repository/home_repository.dart';
import '../model/movie_model.dart';

final homeProvider = AsyncNotifierProvider<HomeProvider, HomeData>(
  HomeProvider.new,
);

class HomeProvider extends AsyncNotifier <HomeData> {
  @override
  FutureOr<HomeData> build() async {
    final repository = ref.read(homeRepository);
    final topRatedResponse = await repository.topRatedMovies();
    final topRatedData = topRatedResponse.data["results"] as List;
    final topRated = topRatedData.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();

    final popularResponse = await repository.popularMovies();
    final popularData = popularResponse.data["results"] as List;
    final popular = popularData.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();

    final upcomingResponse = await repository.upcomingMovies();
    final upcomingData = upcomingResponse.data["results"] as List;
    final upcoming = upcomingData.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();

    final nowPlayingResponse = await repository.nowPlayingMovies();
    final nowPlayingData = nowPlayingResponse.data["results"] as List;
    final nowPlaying = nowPlayingData.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();

    // log("upcoming movies data : ${upcoming.map((movie) => movie.title).toList()}");

    return HomeData(popular: popular, upcoming: upcoming, topRated: topRated, nowPlaying: nowPlaying);


  }


}