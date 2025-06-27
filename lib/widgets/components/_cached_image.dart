import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

List<String> _imageFileExtensions = [
  'jpg',
  'jpeg',
  'png',
  'gif',
  'bmp',
  'wbmp',
  'webp',
  'svg'
];

class CachedImage extends StatefulWidget {
  const CachedImage(
      {super.key,
      this.imageUrl =
          'https://via.placeholder.com/480x480.png?text=Image%20not%20found',
      this.fit,
      this.width,
      this.height,
      this.alignment,
      this.radius,
      this.errorWidget,
      this.onComplete});
  final String imageUrl;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final double? radius;
  final Widget? errorWidget;
  final Function()? onComplete;

  static String? directoryPath;

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  Completer<void>? _fetchDataCompleter;
  File? image;
  bool isLoading = false;
  bool isSvg = false;
  bool isError = false;
  bool isAssets = false;
  bool isAlreadyExists = false;
  @override
  void initState() {
    _fetchDataCompleter = Completer<void>();
    loadFromNetwork();
    super.initState();
  }

  Future<void> loadFromNetwork() async {
    try {
      // Get the directory where the application stores its documents.
      CachedImage.directoryPath ??=
          (await getApplicationDocumentsDirectory()).path;

      // Get the file name for the image.
      final fileName = widget.imageUrl.replaceAll(RegExp('[^A-Za-z0-9]'), '');

      // Create a file object for the image.
      isAssets = !('${widget.imageUrl.trim()}/'
          .split('/')
          .first
          .toLowerCase()
          .contains('http'));

      final splitByDots = widget.imageUrl.split('.');
      isSvg = splitByDots.last.trim().toLowerCase() == 'svg';
      if (isAssets) {
        setState(() {
          isAlreadyExists = true;
          isLoading = false;
        });
        return;
      }
      setState(() {
        isLoading = true;
      });
      image = File(
          '${CachedImage.directoryPath}/$fileName.${splitByDots.isNotEmpty ? (_imageFileExtensions.contains(splitByDots.last) ? splitByDots.last : 'jpg') : 'jpg'}');
      // Check if the image file already exists.
      isAlreadyExists = await image?.exists() ?? false;
      if (!isAlreadyExists) {
        // Load the image data from the network.
        Uint8List bytes = (await NetworkAssetBundle(Uri.parse(widget.imageUrl))
                .load(widget.imageUrl))
            .buffer
            .asUint8List();
        // Write the image data to the file.
        await image?.writeAsBytes(bytes);
      }

      // Update the state to indicate that the image has been loaded.
      if (!(_fetchDataCompleter?.isCompleted ?? false)) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Update the state to indicate that an error has occurred.
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    if (!(_fetchDataCompleter?.isCompleted ?? false)) {
      // Dispose the completer and cancel the ongoing operation if it's not completed
      _fetchDataCompleter
          ?.complete(); // Complete the completer to prevent further processing
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      loadFromNetwork();
    }
  }

  late final Widget _errorWidget = Container(
    width: widget.width,
    height: widget.height,
    padding: const EdgeInsets.all(3),
    color: const Color(0xffF4F4EF),
    child: Center(
      child: Icon(
        Icons.error,
        size: min((widget.height ?? 20), (widget.width ?? 20)) * 0.5,
        color: const Color(0xff8A8383),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius ?? 0),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: isAlreadyExists ? 0 : 200),
        child: isLoading
            ? Shimmer.fromColors(
                key: const ValueKey<int>(1),
                baseColor: Colors.grey.shade200,
                direction: ShimmerDirection.ltr,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  color: Colors.white,
                  width: widget.width,
                  height: widget.height,
                ))
            : isError
                ? (widget.errorWidget ?? _errorWidget)
                : isSvg
                    ? isAssets
                        ? SvgPicture.asset(
                            widget.imageUrl,
                            alignment: widget.alignment ?? Alignment.center,
                            width: widget.width,
                            height: widget.height,
                            key: const ValueKey<int>(2),
                            fit: widget.fit ?? BoxFit.contain,
                          )
                        : image != null
                            ? SvgPicture.file(
                                image!,
                                alignment: widget.alignment ?? Alignment.center,
                                width: widget.width,
                                height: widget.height,
                                key: const ValueKey<int>(2),
                                fit: widget.fit ?? BoxFit.contain,
                              )
                            : SizedBox(
                                // color: Colors.grey.shade200,
                                width: widget.width,
                                height: widget.height,
                              )
                    : isAssets
                        ? Image.asset(
                            widget.imageUrl,
                            alignment: widget.alignment ?? Alignment.center,
                            width: widget.width,
                            height: widget.height,
                            key: const ValueKey<int>(2),
                            fit: widget.fit,
                            errorBuilder: (context, error, stackTrace) =>
                                _errorWidget,
                          )
                        : image != null
                            ? Image.file(
                                image!,
                                alignment: widget.alignment ?? Alignment.center,
                                width: widget.width,
                                height: widget.height,
                                key: const ValueKey<int>(2),
                                fit: widget.fit,
                                errorBuilder: (context, error, stackTrace) =>
                                    _errorWidget,
                              )
                            : SizedBox(
                                // color: Colors.grey.shade200,
                                width: widget.width,
                                height: widget.height,
                              ),
      ),
    );
  }
}
