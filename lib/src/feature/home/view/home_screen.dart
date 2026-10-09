import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movies_core/src/core/service/helper/tmdb_helper.dart';
import 'package:movies_core/src/core/utils/theme/app_tokens.dart';
import 'package:movies_core/src/feature/common/widgets/button/app_button.dart';
import 'package:movies_core/src/feature/home/controller/home_controller.dart';
import 'package:movies_core/src/feature/home/view/components/popular_carousel.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String name = "home-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeProvider);
    final upcomingMovies = home.value?.upcoming;
    final popularMovies = home.value?.popular;
    final topRatedMovies = home.value?.topRated;
    final notifier = ref.read(homeProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.slate600,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.red),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aktaruzzaman"),
                        Text("Let's watch a movie"),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.search),
                    SizedBox(width: 6),
                    Icon(Icons.notifications_none_outlined),
                  ],
                ),
                SizedBox(height: 20),
                PopularCarousel(movies: popularMovies ?? const []),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                //   height: 180,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(15),
                //     // color: Colors.grey,
                //     image: DecorationImage(
                //       image: NetworkImage(
                //         TmdbImage.poster(popularMovies?[2].posterPath),
                //       ),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text("Watch popular movies : ${popularMovies?[2].title}"),
                //       SizedBox(height: 10),
                //       Text("Lyrics are the words that make up a song."),
                //       Spacer(),
                //       AppButton(
                //         onPressed: () {},
                //         width: 133,
                //         child: Text("Clicked Here"),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 16),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                //     SizedBox(width: 3),
                //     CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                //     SizedBox(width: 3),
                //     CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                //     SizedBox(width: 3),
                //     CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                //   ],
                // ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Upcoming Movies"),
                    Spacer(),
                    Text("See all", style: TextStyle(color: Colors.blueAccent)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height:
                            195, // enough for image (135) + gap (6) + 2 lines of text
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingMovies?.length,
                          itemBuilder: (context, index) {
                            final upcomingMovie = upcomingMovies?[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12,
                                    ),
                                    height: 135,
                                    width: 111,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      // color: Colors.grey,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          TmdbImage.poster(
                                            upcomingMovie?.posterPath,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  SizedBox(
                                    width: 111,
                                    child: Center(
                                      child: Text(
                                        "${upcomingMovie?.title}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text("Top Rated"),
                    Spacer(),
                    Text("See all", style: TextStyle(color: Colors.blueAccent)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height:
                            195, // enough for image (135) + gap (6) + 2 lines of text
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topRatedMovies?.length,
                          itemBuilder: (context, index) {
                            final topRatedMovie = topRatedMovies?[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12,
                                    ),
                                    height: 135,
                                    width: 111,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      // color: Colors.grey,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          TmdbImage.poster(
                                            topRatedMovie?.posterPath,
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  SizedBox(
                                    width: 111,
                                    child: Center(
                                      child: Text(
                                        "${topRatedMovie?.title}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
