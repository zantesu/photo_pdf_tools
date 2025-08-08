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
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [HomeCell(), HomeCell(), HomeCell()],
            ),
          ],
        ),
      ),
    );
  }
}
