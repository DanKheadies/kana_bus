import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:kana_bus/barrel.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // double calcWidth = constraints.maxWidth < 850
            //     ? constraints.maxWidth - 300
            //     : 300;
            return FutureBuilder<String>(
              future: _loadMarkdownFile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Markdown(data: snapshot.data!);
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Future<String> _loadMarkdownFile() async {
    return await rootBundle.loadString('assets/data/transit_guide.md');
  }
}
