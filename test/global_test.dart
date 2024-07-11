import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:merger/src/list_merger.dart';
import 'package:merger/src/map_merger.dart';
import 'package:merger/src/settings.dart';
import 'package:test/test.dart';

import 'test_data.dart';

Future<void> main() async {
  group('Global test', () {
    void generateTests({
      MergeStrategy? strategy,
      NullBehavior? nullBehavior,
      MapBehavior? mapBehavior,
      ListBehavior? listBehavior,
      ResultBehavior? resultBehavior,
    }) {
      final String key = [
        strategy?.value,
        nullBehavior?.value,
        mapBehavior?.value,
        listBehavior?.value,
        resultBehavior?.value,
      ].where((it) => it != null).map((it) => it?.replaceAll(':', '.')).join('.');

      if (nullBehavior == NullBehavior.doNothing) {
        debugger();
      }

      final Map<String, Object?> mapResult = mergeMaps(map1, map2);
      final Map<String, Object?> mapResult2 = mergeMaps(map1, map3);
      final List<Object?> listResult = mergeLists(list1, list2);

      test('Checking Map: $key', () async {
        final File file = File([Directory.current.path, 'test', 'results', 'Map.$key.json'].join('/'));
        final String rawContent = await file.readAsString();
        final Map<String, Object?> validResult = (jsonDecode(rawContent) as Map).cast<String, Object?>();
        expect(mapResult, validResult);
      });

      test('Checking Map2: $key', () async {
        final File file = File([Directory.current.path, 'test', 'results', 'Map2.$key.json'].join('/'));
        final String rawContent = await file.readAsString();
        final Map<String, Object?> validResult = (jsonDecode(rawContent) as Map).cast<String, Object?>();
        expect(mapResult2, validResult);
      });

      test('Checking List: $key', () async {
        final File file = File([Directory.current.path, 'test', 'results', 'List.$key.json'].join('/'));
        final String rawContent = await file.readAsString();
        final List<Object?> validResult = (jsonDecode(rawContent) as List).cast<Object?>();
        expect(listResult, validResult);
      });
    }

    test(
      'Collect results',
      skip: false,
      () async {
        Future<void> generateGoldenData({
          MergeStrategy? strategy,
          NullBehavior? nullBehavior,
          MapBehavior? mapBehavior,
          ListBehavior? listBehavior,
          ResultBehavior? resultBehavior,
        }) async {
          final String key = [
            strategy?.value,
            nullBehavior?.value,
            mapBehavior?.value,
            listBehavior?.value,
            resultBehavior?.value,
          ].where((it) => it != null).map((it) => it?.replaceAll(':', '.')).join('.');

          final Map<String, Object?> mapResult = mergeMaps(map1, map2);
          final Map<String, Object?> mapResult2 = mergeMaps(map1, map3);
          final List<Object?> listResult = mergeLists(list1, list2);

          await File([Directory.current.path, 'test', 'results', 'Map.$key.json'].join('/')).writeAsString(jsonEncode(mapResult));
          await File([Directory.current.path, 'test', 'results', 'Map2.$key.json'].join('/')).writeAsString(jsonEncode(mapResult2));
          await File([Directory.current.path, 'test', 'results', 'List.$key.json'].join('/')).writeAsString(jsonEncode(listResult));
        }

        for (final strategy in MergeStrategy.values) {
          await generateGoldenData(strategy: strategy);
        }

        for (final nullBehavior in NullBehavior.values) {
          await generateGoldenData(nullBehavior: nullBehavior);
        }

        for (final mapBehavior in MapBehavior.values) {
          await generateGoldenData(mapBehavior: mapBehavior);
        }

        for (final listBehavior in ListBehavior.values) {
          await generateGoldenData(listBehavior: listBehavior);
        }

        for (final resultBehavior in ResultBehavior.values) {
          await generateGoldenData(resultBehavior: resultBehavior);
        }
      },
    );

    for (final strategy in MergeStrategy.values) {
      generateTests(strategy: strategy);
    }

    for (final nullBehavior in NullBehavior.values) {
      generateTests(nullBehavior: nullBehavior);
    }

    for (final mapBehavior in MapBehavior.values) {
      generateTests(mapBehavior: mapBehavior);
    }

    for (final listBehavior in ListBehavior.values) {
      generateTests(listBehavior: listBehavior);
    }

    for (final resultBehavior in ResultBehavior.values) {
      generateTests(resultBehavior: resultBehavior);
    }
  });
}
