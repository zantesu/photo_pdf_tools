import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

  ///合并[imagesPath]目录下的所有图片到[outputPdfPath]的pdf文件
  /// 参数：
  /// - [imagesPath]: 图片目录路径。
  /// - [pdfPath]: 输出的 PDF 文件路径。
  ///返回：生成的PDF文件路径
  static Future<void> mergeImageToPdf({
    required String imagesPath,
    required String pdfPath,
  }) async {
    final dir = Directory(imagesPath);
    if (!await dir.exists()) {
      throw FileSystemException('图片目录不存在', imagesPath);
    }

    // 支持的图片扩展名
    final exts = <String>{'.png', '.jpg', '.jpeg', '.webp', '.bmp'};
    final files = await dir
        .list()
        .where((e) => e is File)
        .cast<File>()
        .where((f) => exts.contains(p.extension(f.path).toLowerCase()))
        .toList();

    if (files.isEmpty) {
      throw StateError('目录中未找到可用的图片文件');
    }

    final doc = pw.Document();
    int addedPages = 0;

    for (final file in files) {
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        // 跳过无法解析的图片
        continue;
      }

      final isPortrait = decoded.height >= decoded.width;
      final format = isPortrait ? PdfPageFormat.a4 : PdfPageFormat.a4.landscape;

      doc.addPage(
        pw.Page(
          pageFormat: format,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Center(
            child: pw.Image(
              pw.MemoryImage(bytes),
              fit: pw.BoxFit.contain, // 保持比例完整展示
            ),
          ),
        ),
      );
      addedPages++;
    }

    // 确保输出目录存在
    final outFile = File(pdfPath);
    await outFile.parent.create(recursive: true);
    if (addedPages == 0) {
      throw StateError('没有可用的图片生成 PDF');
    }
    final data = await doc.save();
    await outFile.writeAsBytes(data);
  }
}
