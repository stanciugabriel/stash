import 'package:cardnest/card_preview.dart';
import 'package:cardnest/scan_modal.dart';
import 'package:flutter/material.dart';
import 'package:cardnest/models/card.dart' as LCard;
// Replace with the actual import path for CardStorage
// Replace with the actual import path for CardStorage

class CardListPage extends StatefulWidget {
  @override
  _CardListPageState createState() => _CardListPageState();
}

class _CardListPageState extends State<CardListPage> {
  List<LCard.Card> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // Load cards from local storage
  Future<void> _loadCards() async {
    List<LCard.Card> cards = await LCard.CardStorage.getCards();
    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Cards'),
      ),
      body: _cards.isEmpty
          ? Center(child: Text('No cards saved yet.'))
          : ListView.builder(
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CardPreview(
                              code: card.barcode,
                              name: card.name,
                              format: card.format)),
                    );
                  },
                  child: ListTile(
                    title: Text(card.name),
                    subtitle: Text(card.barcode),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteCard(card);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ScanModal.show(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add Card',
      ),
    );
  }

  // Add a new card to the list and update storage
  Future<void> _addCard(LCard.Card card) async {
    setState(() {
      _cards.add(card);
    });
    await LCard.CardStorage.saveCards(_cards);
  }

  // Delete a card from the list and update storage
  Future<void> _deleteCard(LCard.Card card) async {
    setState(() {
      _cards.remove(card);
    });
    await LCard.CardStorage.saveCards(_cards);
  }
}
