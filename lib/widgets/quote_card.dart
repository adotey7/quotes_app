import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quotes.dart';
import 'package:provider/provider.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard(
      {required this.quote,
      required this.author,
      required this.cardColor,
      super.key});
  final String quote;
  final String author;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    final singleCard = Provider.of<Quotes>(context, listen: false);
    return Container(

      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.all(20),
      height: math.min((quote.length * 3) + 100, 400),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(8),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            quote,
            style: GoogleFonts.ptSerif(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' - $author',
                style: GoogleFonts.acme(
                  color: Colors.white,
                ),
              ),
              Consumer<Quotes>(
                builder: (context, value, child) => IconButton(
                  onPressed: () {
                    singleCard.toggleFavorites();
                  },
                  icon: singleCard.isFavorite
                      ? Icon(Icons.favorite_rounded)
                      : Icon(Icons.favorite_border_rounded),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
