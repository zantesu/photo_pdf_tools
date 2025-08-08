import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';

/// PDF 工具
class PdfTool {
  /// 将 PDF 的每一页渲染为图片并保存到指定目录。
  /// 注意：这是将页面整体栅格化为图片（而非仅提取内嵌位图对象）。
  ///
  /// 参数：
  /// - [pdfFilePath]: PDF 文件绝对路径。
  /// - [outputDir]: 输出目录，若不存在会自动创建。
  /// - [prefix]: 文件名前缀（默认 page），输出如 page_p1.png。
  /// - [dpi]: 渲染分辨率（默认 144）。数值越大越清晰，体积也更大。
  /// - [format]: 输出格式：png 或 jpg。
  /// - [jpgQuality]: JPG 质量 1-100。
  ///
  /// 返回：生成的图片文件路径列表（顺序与页码一致）。
  static Future<List<String>> rasterizePages({
    required String pdfFilePath,
    required String outputDir,
    String prefix = 'page',
    double dpi = 144,
    String format = 'png',
    int jpgQuality = 90,
  }) async {
    final pdfFile = File(pdfFilePath);
    if (!await pdfFile.exists()) {
      throw FileSystemException('PDF 文件不存在', pdfFilePath);
    }

    final outDir = Directory(outputDir);
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }

    final pdfBytes = await pdfFile.readAsBytes();
    final ext = _ext(format);

    final List<String> outputs = [];
    int pageIdx = 0;
    // printing.raster 会按页回调一批 Image。
    await for (final pageImage in Printing.raster(
      pdfBytes,
      dpi: dpi,
      // limitPages: [0,1] // 可选：限制页
    )) {
      pageIdx++;
      final fileName = '${prefix}_p$pageIdx.$ext';
      final path = p.join(outDir.path, fileName);
      final data = await pageImage.toPng(); // Uint8List PNG
      if (ext == 'png') {
        await File(path).writeAsBytes(data);
      } else {
        // 若用户选 jpg，则转码
        final decoded = img.decodePng(data);
        if (decoded != null) {
          final jpg = img.encodeJpg(decoded, quality: jpgQuality);
          await File(path).writeAsBytes(Uint8List.fromList(jpg));
        } else {
          // 回退直接写 PNG
          await File(path).writeAsBytes(data);
        }
      }
      outputs.add(path);
    }
    return outputs;
  }

  static String _ext(String format) {
    final f = format.toLowerCase();
    return (f == 'jpg' || f == 'jpeg') ? 'jpg' : 'png';
  }
}
