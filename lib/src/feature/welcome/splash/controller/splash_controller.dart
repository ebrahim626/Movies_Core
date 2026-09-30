import 'package:flutter_riverpod/flutter_riverpod.dart';

final splashNextRouteProvider = FutureProvider.autoDispose<String>((ref) async {
  await Future.delayed(const Duration(milliseconds: 2200));


});