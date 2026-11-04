import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Generate branding PNGs (app_logo, foreground, splash_logo)', (tester) async {
    final logoKey = GlobalKey();
    final foregroundKey = GlobalKey();
    final splashKey = GlobalKey();

    tester.view.physicalSize = const Size(2048, 2048);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Full 1024x1024 app icon
                RepaintBoundary(
                  key: logoKey,
                  child: Container(
                    width: 1024,
                    height: 1024,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE83E4D),
                      borderRadius: BorderRadius.circular(224),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.handyman_rounded,
                        color: Colors.white,
                        size: 540,
                      ),
                    ),
                  ),
                ),

                // 2. Android adaptive foreground (1024x1024 with transparent bg)
                RepaintBoundary(
                  key: foregroundKey,
                  child: Container(
                    width: 1024,
                    height: 1024,
                    color: Colors.transparent,
                    child: const Center(
                      child: Icon(
                        Icons.handyman_rounded,
                        color: Colors.white,
                        size: 460,
                      ),
                    ),
                  ),
                ),

                // 3. Splash centered logo (512x512)
                RepaintBoundary(
                  key: splashKey,
                  child: Container(
                    width: 512,
                    height: 512,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE83E4D),
                      borderRadius: BorderRadius.circular(112),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.handyman_rounded,
                        color: Colors.white,
                        size: 270,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> exportPng(GlobalKey key, String path) async {
      final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();
        final file = File(path);
        await file.parent.create(recursive: true);
        await file.writeAsBytes(pngBytes);
      });
    }

    await exportPng(logoKey, 'assets/branding/app_logo.png');
    await exportPng(foregroundKey, 'assets/branding/app_logo_foreground.png');
    await exportPng(splashKey, 'assets/branding/splash_logo.png');

    expect(File('assets/branding/app_logo.png').existsSync(), isTrue);
    expect(File('assets/branding/app_logo_foreground.png').existsSync(), isTrue);
    expect(File('assets/branding/splash_logo.png').existsSync(), isTrue);
  });
}
