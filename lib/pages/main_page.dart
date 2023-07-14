import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/quotes.dart';
import '../widgets/quote_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // QuotesData _quotesData = QuotesData();
  // final newF = Future(() => QuotesData.quoteOfTheDay());
  final colors = <Color>[
    const Color(0XFF539CEE),
    const Color(0XFF9C7263),
    const Color(0XFFFF8C66),
    const Color(0XFF8863D2),
  ];
  var didChange = true;
  var _isLoading = false;
  final ScrollController _controller = ScrollController();

  void fetchMore() async {
    if (_isLoading) return;
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<QuotesData>(context, listen: false).fetchMore();
      setState(() {
        _isLoading = false;
      });
    }
  }

  String greeting() {
    final time = DateTime.now().hour;
    if (time >= 0 && time <= 11) {
      return 'Good morning!';
    } else if (time >= 12 && time <= 16) {
      return 'Good afternoon!';
    } else {
      return 'Good evening';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(fetchMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (didChange) {
      final quote = Provider.of<QuotesData>(context, listen: false);

      if (quote.loadedQuotes.isEmpty) {
        Provider.of<QuotesData>(context, listen: false).fetchQuotes();
      }
    }

    didChange = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotes = Provider.of<QuotesData>(context);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // QuoteOfTheDay(newF: newF),
            AutoSizeText(
              greeting(),
              style: GoogleFonts.alegreyaSans(
                fontSize: 30,
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<QuotesData>(context, listen: false)
                    .fetchQuotes();
              },
              child: ListView.builder(
                controller: _controller,
                itemCount: _isLoading
                    ? quotes.loadedQuotes.length + 1
                    : quotes.loadedQuotes.length,
                itemBuilder: (context, index) {
                  if (index < quotes.loadedQuotes.length) {
                    final singleQuote = quotes.loadedQuotes[index];
                    final randomIndex = math.Random().nextInt(colors.length);
                    final randomColor = colors[randomIndex];
                    return ChangeNotifierProvider.value(
                      key: UniqueKey(),
                      value: singleQuote,
                      child: QuoteCard(
                        quote: singleQuote.quote,
                        author: singleQuote.author,
                        cardColor: randomColor,
                      ),
                    );
                  } else {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.0, bottom: 40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ))
          ],
        ),
      )),
    );
  }
}

// class QuoteOfTheDay extends StatelessWidget {
//   const QuoteOfTheDay({
//     super.key,
//     required this.newF,
//   });

//   final Future<Quotes> newF;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: newF,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         if (snapshot.hasData) {
//           final quotes = snapshot.data as Quotes;
//           return QuoteCard(
//             quote: quotes.quote,
//             author: quotes.author,
//             cardColor: Colors.grey.shade700,
//           );
//         } else {
//           if (snapshot.hasError) {
//             return const Text('Something went wrong');
//           }
//           return const Text('Taking too long');
//         }
//       },
//     );
//   }
// }
