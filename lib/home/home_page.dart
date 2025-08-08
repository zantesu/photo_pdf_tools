import 'package:flutter/material.dart';
import 'package:photo_pdf_tools/home/home_cell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Image.asset('images/301.png')),
            SliverGrid.count(
              childAspectRatio: 4,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                HomeCell(title: '成品检查'),
                HomeCell(title: '图片尺寸统计'),
                HomeCell(title: '图片合并pdf'),
                HomeCell(title: 'pdf图片提取'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
