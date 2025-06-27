// 🎯 Dart imports:
import 'dart:async';

import 'package:appcore/utils/utils.dart';

class Synchronizer {
  static Future<T> fetchData<T>({
    required Future<T> Function() fetchOnline, // Fungsi untuk fetch data online
    required Future<T> Function()
        fetchOffline, // Fungsi untuk fetch data dari local database
    required Future<void> Function(T data)
        updateLocalDatabase, // Fungsi untuk update local database
    int timeoutMs =
        300, // Waktu tunggu dalam milidetik sebelum mengembalikan data lokal
  }) async {
    final completer = Completer<
        T>(); // Digunakan untuk menyelesaikan Future pertama yang selesai
    bool isCompleted =
        false; // Flag untuk melacak apakah data sudah dikembalikan
    final start = DateTime.now();
    // Jalankan fetch online dan offline secara paralel
    fetchOnline().then((onlineData) {
      Log.w({
        "operation": "Online - Dio",
        "response-time":
            "${DateTime.now().difference(start).inMilliseconds} ms",
      });
      if (!isCompleted) {
        Log.i("returned online source");
        // Kembalikan data online jika selesai dalam 200ms
        completer.complete(onlineData);
        isCompleted = true;
      }
      // Tetap update local database setelah online fetch selesai
      return updateLocalDatabase(onlineData);
    });

    fetchOffline.call().then((offlineData) {
      Log.w({
        "operation": "Local - Isar",
        "response-time":
            "${DateTime.now().difference(start).inMilliseconds} ms",
      });
      if (!isCompleted) {
        // Jika fetch online belum selesai dalam 200ms, kembalikan data offline
        final elapsedTimeMs = DateTime.now().difference(start).inMilliseconds;
        final delay = elapsedTimeMs < timeoutMs ? timeoutMs - elapsedTimeMs : 0;
        Future.delayed(
          Duration(milliseconds: delay),
          () {
            if (!isCompleted) {
              Log.i("returned offline source");
              completer.complete(offlineData);
              isCompleted = true;
            }
          },
        );
      }
    });

    // Tunggu hingga salah satu fetch selesai, dengan timeout 200ms untuk online
    // await Future.any([onlineFetch, Future.delayed(Duration(milliseconds: timeoutMs))]);

    return completer.future;
  }

  static Future<T> mutator<T>({
    required Future<T> Function()
        mutateOnline, // Fungsi untuk fetch data online
    required Future<T> Function()
        mutateOffline, // Fungsi untuk fetch data dari local database
    required Future<void> Function(T data)
        updateLocalDatabase, // Fungsi untuk update local database
    int timeoutMs =
        200, // Waktu tunggu dalam milidetik sebelum mengembalikan data lokal
  }) async {
    final completer = Completer<
        T>(); // Digunakan untuk menyelesaikan Future pertama yang selesai
    bool isCompleted =
        false; // Flag untuk melacak apakah data sudah dikembalikan

    // Jalankan fetch online dan offline secara paralel
    mutateOnline().then((onlineData) {
      if (!isCompleted) {
        completer.complete(
            onlineData); // Kembalikan data online jika selesai dalam 200ms
        isCompleted = true;
      }
      // Tetap update local database setelah online fetch selesai
      return updateLocalDatabase(onlineData);
    }).catchError((_) {
      // Handle error jika diperlukan
    });

    mutateOffline().then((offlineData) {
      if (!isCompleted) {
        // Jika fetch online belum selesai dalam 200ms, kembalikan data offline
        completer.complete(offlineData);
        isCompleted = true;
      }
    }).catchError((_) {
      // Handle error jika diperlukan
    });

    // Tunggu hingga salah satu fetch selesai, dengan timeout 200ms untuk online
    // await Future.any([onlineFetch, Future.delayed(Duration(milliseconds: timeoutMs))]);

    return completer.future;
  }
}
