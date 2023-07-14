import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/models/quotes.dart';
import 'package:quotes_app/widgets/fave_cards.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});
  final colors = <Color>[
    const Color(0XFF539CEE),
    const Color(0XFF9C7263),
    const Color(0XFFFF8C66),
    const Color(0XFF8863D2),
  ];

  @override
  Widget build(BuildContext context) {
    final favesOnly = Provider.of<QuotesData>(context).fetchFavorites();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: ListView.builder(
              itemCount: favesOnly.length,
              itemBuilder: (context, index) {
                final randomIndex = math.Random().nextInt(colors.length);
                final randomColor = colors[randomIndex];
                return favesOnly.isEmpty
                    ? Center(
                        child: Text(
                          'No Favorites!. Add Some',
                          style: GoogleFonts.alegreyaSans(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : FaveCard(
                        quote: favesOnly[index].quote,
                        author: favesOnly[index].author,
                        cardColor: randomColor,
                      );
              }),
        ),
      ),
    );
  }
}
