// // 🎯 Dart imports:
// import 'dart:convert';

// // 📦 Package imports:
// import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
// // 🌎 Project imports:
// import 'package:harmoni_pos/core/features/pos/models/order_model.dart';
// import 'package:harmoni_printer/harmoni_printer.dart';

// class PrinterService extends GetxService {
//   static PrinterService get i => Get.find<PrinterService>();
//   final printers = <PrinterModel>[].obs;
//   Map<String, List<PrinterModel>> printersMap = {};
//   BoxCollection? _hiveCollection;
//   CollectionBox? _printersBox;
//   List<String>? _printerKeys;

//   final _paperSizeMap = {
//     "58mm": PaperSize.mm58,
//     "72mm": PaperSize.mm72,
//     "80mm": PaperSize.mm80,
//   };

//   init() async {
//     // 1. Load from database
//     const FlutterSecureStorage secureStorage = FlutterSecureStorage();
//     var containsEncryptionKey =
//         await secureStorage.containsKey(key: 'printerEncryptionKey');
//     List<int> encryptionKey = [];
//     if (!containsEncryptionKey) {
//       encryptionKey = Hive.generateSecureKey();
//       await secureStorage.write(
//           key: 'printerEncryptionKey', value: base64UrlEncode(encryptionKey));
//     } else {
//       encryptionKey = base64Url.decode(
//           await secureStorage.read(key: 'printerEncryptionKey') ??
//               "defaultKey");
//     }
//     var appDir = await getApplicationDocumentsDirectory();

//     _hiveCollection = await BoxCollection.open(
//       'printersBox', // Name of your database
//       {'printers'}, // Names of your boxes
//       path:
//           '${appDir.path}/printers', // Path where to store your boxes (Only used in Flutter / Dart IO)
//       key: HiveAesCipher(
//           encryptionKey), // Key to encrypt your boxes (Only used in Flutter / Dart IO)
//     );
//     _printersBox = await _hiveCollection!.openBox<Map>('printers');
//     final data = await _printersBox!.getAllValues();
//     _printerKeys = await _printersBox!.getAllKeys();
//     List<PrinterModel> loadedPrinters =
//         (data.values.toList() as List<Map<dynamic, dynamic>>).map((e) {
//       final json = Map<String, dynamic>.from(e);
//       json["device"] = Map<String, dynamic>.from(json["device"]);
//       return PrinterModel.fromJson(json);
//     }).toList();
//     printers.addAll(loadedPrinters);

//     // 2. Connect to all bluetooth printer
//     for (var printer in printers) {
//       if (printer.connectivity == "bluetooth") {
//         await PrinterManager.instance
//             .connect(type: PrinterType.bluetooth, device: printer.device!);
//       }
//       // 3. Grouping printers based on it's categories
//       if (printer.enableReceipts ?? false) {
//         printersMap["receipts"] ??= [];
//         printersMap["receipts"]?.add(printer);
//       }
//       if (printer.enableKitchens ?? false) {
//         printersMap["kitchens"] ??= [];
//         printersMap["kitchens"]?.add(printer);
//       }
//       if (printer.enableCheckers ?? false) {
//         printersMap["checkers"] ??= [];
//         printersMap["checkers"]?.add(printer);
//       }
//     }
//   }

//   bool isDeviceExist({required String key}) {
//     return _printerKeys!.contains(key);
//   }

//   Future<bool> addPrinter({required PrinterModel printer}) async {
//     try {
//       await _printersBox?.put(printer.device?.address ?? "", printer.toJson());
//       printers.add(printer);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> removePrinter({required PrinterModel printer}) async {
//     try {
//       await _printersBox?.delete(printer.device?.address ?? "");
//       printers.removeWhere(
//         (element) => element.device?.address == printer.device?.address,
//       );
//       _printerKeys?.removeWhere(
//         (element) => element == printer.device?.address,
//       );
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<Generator> _generator({required PrinterModel printer}) async {
//     final profile = await CapabilityProfile.load();
//     return Generator(
//         _paperSizeMap[printer.paperSize] ?? PaperSize.mm58, profile);
//   }

//   testPrint({required BleDevice printer}) async {
//     try {
//       // if (printer == null) return;
//       final generator = await _generator(
//           printer: PrinterModel(
//               device: PrinterDevice(
//                   name: printer.name ?? "", address: printer.deviceId)));
//       List<int> bytes = [];
//       bytes += generator.text("Woohoo! Aku siap colab bareng",
//           styles: const PosStyles(align: PosAlign.center));
//       bytes += generator.text("Harmoni POS!",
//           styles: const PosStyles(align: PosAlign.center));
//       // bytes += generator.emptyLines(2);
//       bytes += generator.cut();
//       final ok = await PrinterManager.instance.bluetoothPrinter
//           .connect(device: printer);
//       if (ok) {
//         await PrinterManager.instance.bluetoothPrinter
//             .send(device: printer, data: bytes);
//       }
//     } catch (e) {
//       Log.e(e);
//     }
//   }

//   printReceipt(
//       {required OrderModel order,
//       ReceiptType type = ReceiptType.checkout}) async {
//     final printerList = _getAvailablePrinters(type: type);
//     for (var printer in printerList) {
//       _printHandler(order: order, printer: printer);
//     }
//   }

//   List<PrinterModel> _getAvailablePrinters(
//       {ReceiptType type = ReceiptType.checkout}) {
//     switch (type) {
//       case ReceiptType.checkout:
//         return printers
//             .where(
//               (p) => (p.isEnabled ?? false) && (p.isAutoPrint ?? false),
//             )
//             .toList();
//       case ReceiptType.bill:
//         return printers
//             .where(
//               (p) => (p.isEnabled ?? false) && (p.enableReceipts ?? false),
//             )
//             .toList();
//       case ReceiptType.receipt:
//         return printers
//             .where(
//               (p) => (p.isEnabled ?? false) && (p.enableReceipts ?? false),
//             )
//             .toList();
//       case ReceiptType.kitchen:
//         return printers
//             .where(
//               (p) => (p.isEnabled ?? false) && (p.enableKitchens ?? false),
//             )
//             .toList();
//       case ReceiptType.checker:
//         return printers
//             .where(
//               (p) => (p.isEnabled ?? false) && (p.enableCheckers ?? false),
//             )
//             .toList();
//       default:
//         return printers
//             .where(
//               (p) => (p.isEnabled ?? false) && (p.isAutoPrint ?? false),
//             )
//             .toList();
//     }
//   }

//   _printHandler({required OrderModel order, required PrinterModel printer}) {}
// }

// enum ReceiptType { bill, receipt, kitchen, checker, checkout }

// class PrinterModel {
//   String? name;
//   String? printersType;
//   String? connectivity;
//   String? paperSize;
//   PrinterDevice? device;
//   bool? isEnabled;
//   bool? isAutoPrint;
//   bool? enableReceipts;
//   bool? enableKitchens;
//   bool? enableCheckers;
//   Map<int, String>? kitchensCategory;
//   Map<int, String>? checkersCategory;

//   PrinterModel({
//     this.name,
//     this.printersType,
//     this.connectivity,
//     this.paperSize,
//     this.isEnabled,
//     this.isAutoPrint,
//     this.enableReceipts,
//     this.enableKitchens,
//     this.enableCheckers,
//     required this.device,
//   });

//   PrinterModel.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     printersType = json['printersType'];
//     connectivity = json['connectivity'];
//     paperSize = json['paperSize'];
//     isEnabled = json['isEnabled'];
//     isAutoPrint = json['isAutoPrint'];
//     enableReceipts = json['enableReceipts'];
//     enableKitchens = json['enableKitchens'];
//     enableCheckers = json['enableCheckers'];
//     kitchensCategory = Map<int, String>.from(json['kitchensCategory'] ?? {});
//     checkersCategory = Map<int, String>.from(json['checkersCategory'] ?? {});
//     device = PrinterDevice.fromJson(json['device']);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['printersType'] = printersType;
//     data['connectivity'] = connectivity;
//     data['paperSize'] = paperSize;
//     data['isEnabled'] = isEnabled;
//     data['isAutoPrint'] = isAutoPrint;
//     data['enableReceipts'] = enableReceipts;
//     data['enableKitchens'] = enableKitchens;
//     data['enableCheckers'] = enableCheckers;
//     data['kitchensCategory'] = kitchensCategory;
//     data['checkersCategory'] = checkersCategory;
//     data['device'] = device?.toJson();
//     return data;
//   }
// }
