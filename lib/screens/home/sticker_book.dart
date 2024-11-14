import 'package:flutter/material.dart';

// 스티커 데이터 모델
class StickerItem {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  bool isUnlocked;

  StickerItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    this.isUnlocked = false,
  });
}

class StickerAlbumApp extends StatelessWidget {
  const StickerAlbumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스티커 도감',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
      ),
      home: const StickerAlbumPage(),
    );
  }
}

class StickerAlbumPage extends StatefulWidget {
  const StickerAlbumPage({super.key});

  @override
  _StickerAlbumPageState createState() => _StickerAlbumPageState();
}

class _StickerAlbumPageState extends State<StickerAlbumPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // 샘플 데이터 - 실제 앱에서는 데이터베이스나 API에서 가져올 수 있습니다
  final List<StickerItem> stickers = [
    StickerItem(
      id: '1',
      name: '동물1',
      imageUrl: 'assets/animals/cat.png',
      category: '동물',
      isUnlocked: true,
    ),
    StickerItem(
      id: '2',
      name: '동물2',
      imageUrl: 'assets/animals/dog.png',
      category: '동물',
      isUnlocked: false,
    ),
    StickerItem(
      id: '3',
      name: '식물1',
      imageUrl: 'assets/plants/flower.png',
      category: '식물',
      isUnlocked: true,
    ),
    StickerItem(
      id: '4',
      name: '식물2',
      imageUrl: 'assets/plants/tree.png',
      category: '식물',
      isUnlocked: false,
    ),
    // 더 많은 스티커 추가 가능
  ];

  late List<String> categories;

  @override
  void initState() {
    super.initState();
    // 중복 없는 카테고리 목록 생성
    categories = stickers.map((e) => e.category).toSet().toList();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스티커 도감'),
        bottom: TabBar(
          controller: _tabController,
          tabs: categories.map((category) => Tab(text: category)).toList(),
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) {
          final categoryStickers = stickers.where(
            (sticker) => sticker.category == category
          ).toList();
          
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categoryStickers.length,
            itemBuilder: (context, index) {
              final sticker = categoryStickers[index];
              return StickerCard(
                sticker: sticker,
                onTap: () {
                  setState(() {
                    sticker.isUnlocked = !sticker.isUnlocked;
                  });
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class StickerCard extends StatelessWidget {
  final StickerItem sticker;
  final VoidCallback onTap;

  const StickerCard({
    super.key,
    required this.sticker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Center(
                child: sticker.isUnlocked
                    ? Image.asset(
                        sticker.imageUrl,
                        fit: BoxFit.contain,
                      )
                    : Container(
                        color: Colors.black54,
                        child: const Center(
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Text(
                  sticker.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: sticker.isUnlocked ? Colors.black87 : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}