import 'dart:convert';
import 'dart:io';

import 'package:merger/src/list_merger.dart';
import 'package:merger/src/map_merger.dart';
import 'package:merger/src/settings.dart';
import 'package:test/test.dart';

import 'test_data.dart';

bool get generateData => false;

bool get skipMerge => false;

bool get skipNull => false;

bool get skipMap => false;

bool get skipList => false;

bool get skipResult => false;

Future<void> main() async {
  group('Global test', () {
    void doTest({
      MergeStrategy? strategy,
      NullBehavior? nullBehavior,
      MapBehavior? mapBehavior,
      ListBehavior? listBehavior,
      ResultBehavior? resultBehavior,
      bool skip = false,
      bool withSecondMap = false,
      bool withList = false,
    }) {
      final String key = [
        strategy?.value,
        nullBehavior?.value,
        mapBehavior?.value,
        listBehavior?.value,
        resultBehavior?.value,
      ].where((it) => it != null).map((it) => it?.replaceAll(':', '.')).join('.');

      final Map<String, Object?> map1Copy = map1;
      final List<Object?> list1Copy = list1;

      final Map<String, Object?> mapResult = mergeMaps(
        map1Copy,
        map2,
        strategy: strategy ?? MergeStrategy.addAndOverride,
        nullBehavior: nullBehavior ?? NullBehavior.replace,
        mapBehavior: mapBehavior ?? MapBehavior.keyByKey,
        listBehavior: listBehavior ?? ListBehavior.valueByValue,
        resultBehavior: resultBehavior ?? ResultBehavior.returnNew,
      );
      final Map<String, Object?> mapResult2 = mergeMaps(
        map1,
        map3,
        strategy: strategy ?? MergeStrategy.addAndOverride,
        nullBehavior: nullBehavior ?? NullBehavior.replace,
        mapBehavior: mapBehavior ?? MapBehavior.keyByKey,
        listBehavior: listBehavior ?? ListBehavior.valueByValue,
        resultBehavior: resultBehavior ?? ResultBehavior.returnNew,
      );
      final List<Object?> listResult = mergeLists(
        list1Copy,
        list2,
        strategy: strategy ?? MergeStrategy.addAndOverride,
        nullBehavior: nullBehavior ?? NullBehavior.doNothing,
        mapBehavior: mapBehavior ?? MapBehavior.keyByKey,
        listBehavior: listBehavior ?? ListBehavior.valueByValue,
        resultBehavior: resultBehavior ?? ResultBehavior.returnNew,
      );

      if (withSecondMap == false && withList == false) {
        test('Checking Map: $key', skip: skip, () async {
          final File file = File([Directory.current.path, 'test', 'results', 'Map.$key.Golden.json'].join('/'));
          final String rawContent = await file.readAsString();
          final Map<String, Object?> validResult = (jsonDecode(rawContent) as Map).cast<String, Object?>();
          expect(mapResult, validResult);

          final _ = switch (resultBehavior) {
            ResultBehavior.mergeWithOld => expect(identical(mapResult, map1Copy), true),
            ResultBehavior.returnNew => expect(identical(mapResult, map1Copy), false),
            null => null,
          };
        });
      }

      if (withSecondMap && withList == false) {
        test('Checking Map2: $key', skip: skip, () async {
          final File file = File([Directory.current.path, 'test', 'results', 'Map2.$key.Golden.json'].join('/'));
          final String rawContent = await file.readAsString();
          final Map<String, Object?> validResult = (jsonDecode(rawContent) as Map).cast<String, Object?>();
          expect(mapResult2, validResult);
        });
      }

      if (withSecondMap == false && withList) {
        test('Checking List: $key', skip: skip, () async {
          final File file = File([Directory.current.path, 'test', 'results', 'List.$key.Golden.json'].join('/'));
          final String rawContent = await file.readAsString();
          final List<Object?> validResult = (jsonDecode(rawContent) as List).cast<Object?>();
          expect(listResult, validResult);

          final _ = switch (resultBehavior) {
            ResultBehavior.mergeWithOld => expect(identical(listResult, list1Copy), true),
            ResultBehavior.returnNew => expect(identical(listResult, list1Copy), false),
            null => null,
          };
        });
      }
    }

    test(
      'Generate golden data',
      skip: generateData == false,
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

          final Map<String, Object?> mapResult = mergeMaps(
            map1,
            map2,
            strategy: strategy ?? MergeStrategy.addAndOverride,
            nullBehavior: nullBehavior ?? NullBehavior.replace,
            mapBehavior: mapBehavior ?? MapBehavior.keyByKey,
            listBehavior: listBehavior ?? ListBehavior.valueByValue,
            resultBehavior: resultBehavior ?? ResultBehavior.returnNew,
          );
          final Map<String, Object?> mapResult2 = mergeMaps(
            map1,
            map3,
            strategy: strategy ?? MergeStrategy.addAndOverride,
            nullBehavior: nullBehavior ?? NullBehavior.replace,
            mapBehavior: mapBehavior ?? MapBehavior.keyByKey,
            listBehavior: listBehavior ?? ListBehavior.valueByValue,
            resultBehavior: resultBehavior ?? ResultBehavior.returnNew,
          );
          final List<Object?> listResult = mergeLists(
            list1,
            list2,
            strategy: strategy ?? MergeStrategy.addAndOverride,
            nullBehavior: nullBehavior ?? NullBehavior.doNothing,
            mapBehavior: mapBehavior ?? MapBehavior.keyByKey,
            listBehavior: listBehavior ?? ListBehavior.valueByValue,
            resultBehavior: resultBehavior ?? ResultBehavior.returnNew,
          );

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

    doTest(strategy: MergeStrategy.addOnly, skip: skipMerge);
    doTest(strategy: MergeStrategy.addAndOverride, skip: skipMerge);
    doTest(strategy: MergeStrategy.overrideOnly, skip: skipMerge);

    // TODO(alphamikle): Second map + List

    doTest(nullBehavior: NullBehavior.doNothing, skip: skipNull);
    doTest(nullBehavior: NullBehavior.remove, skip: skipNull);
    doTest(nullBehavior: NullBehavior.replace, skip: skipNull);

    // TODO(alphamikle): Second map + List

    doTest(mapBehavior: MapBehavior.keyByKey, skip: skipMap);
    doTest(mapBehavior: MapBehavior.replaceWithNew, skip: skipMap);

    // TODO(alphamikle): Second map + List

    doTest(listBehavior: ListBehavior.valueByValue, skip: skipList);
    doTest(listBehavior: ListBehavior.replaceWithNew, skip: skipList);

    // TODO(alphamikle): Second map + List

    doTest(resultBehavior: ResultBehavior.returnNew, skip: skipResult);
    doTest(resultBehavior: ResultBehavior.mergeWithOld, skip: skipResult);

    // TODO(alphamikle): Second map + List
  });
}
