import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_pdf_tools/common/util/pdf_tool.dart';

Future<void> main() async {
  final tmpDir = Directory.systemTemp.createTempSync('photo_pdf_tools_');
  final outDir = Directory(p.join(tmpDir.path, 'out'))
    ..createSync(recursive: true);
  final pdfPath = p.join(tmpDir.path, 'sample.pdf');

  // 1) 生成一个简单 PDF
  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Hello PDF -> Image', style: pw.TextStyle(fontSize: 32)),
            pw.SizedBox(height: 20),
            pw.Container(
              width: 200,
              height: 100,
              color: PdfColor.fromInt(0xFF00AAFF),
            ),
          ],
        ),
      ),
    ),
  );
  await File(pdfPath).writeAsBytes(await doc.save());

  // 2) 栅格化导出
  final outputs = await PdfTool.rasterizePages(
    pdfFilePath: pdfPath,
    outputDir: outDir.path,
    prefix: 'page',
    dpi: 144,
    format: 'png',
  );

  stdout.writeln('PDF: $pdfPath');
  stdout.writeln('Outputs (${outputs.length}):');
  for (final o in outputs) {
    final f = File(o);
    stdout.writeln('- $o (${f.existsSync() ? f.lengthSync() : 0} bytes)');
  }
  stdout.writeln('Temp dir: ${tmpDir.path}');
}
