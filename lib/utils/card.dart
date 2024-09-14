import 'package:Stash/models/fidelity_card.dart';
import 'package:Stash/models/store.dart';
import 'package:Stash/utils/url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const Map<String, String> storeLogos = {
  'Penny':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Penny-Logo.svg/512px-Penny-Logo.svg.png',
  'DrMax':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTT9sIBxpctYGzb7c4gA3pwzG50_pN32yzE4w&s',
  'Cador':
      'https://www.sibieni.ro/upload/photo_sb/2022-08/cador-home-sibiu_large.png',
  'Sensiblu':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkG4WhvgYknUzk-8-zhYuS-SJz53J8V1TS2w&s',
  'Optiblu':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZfz2IQttlNSNjLEqvn6WOcLlMwBpbz9r-qQ&s',
  'Sephora':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS66_yGOYOUuXlqxpRx61gD_mql5UCmZUPtOw&s',
  'Marionnaud':
      'https://www.vipstyle.ro/wp-content/uploads/2018/03/Marionnaud_0.jpg',
  'Cora':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSn-ZF2zQDmocrQpOcTh5iIEuF8jRPAqRlaIA&s',
  'Dona':
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcReCpIKMCwtwbxc0OMvi5VE03Ot_6qC1x_2ug&s',
  'Intersport':
      'https://koerber-supplychain.com/fileadmin/koerbersupplychain/Homepage/References/reference_intersport_logo.png',
  'Decathlon':
      'https://images.seeklogo.com/logo-png/52/1/decathlon-logo-png_seeklogo-524475.png',
  'Catena':
      'https://hotnews.ro/wp-content/uploads/2024/04/image-2017-09-19-22009927-41-catena.jpg',
  'Mega Image':
      'https://play-lh.googleusercontent.com/R0mrltwcHZwykHwkV6L9assLhAM9RMuTCOXD1P2klx4Occs8l-MEDu8hEXQo3CFwfXkE',
  'Kaufland':
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Kaufland_201x_logo.svg/1200px-Kaufland_201x_logo.svg.png',
  'Lidl': 'https://www.1min30.com/wp-content/uploads/2018/02/Symbole-Lidl.jpg',
};

Widget cardBuilder(
    BuildContext context, FidelityCard card, Map<String, Store> stores) {
  final cardColor = getCardColor(card, stores);
  final cardLogo = getStoreImage(card.storeID);
  return Container(
    width: MediaQuery.of(context).size.width * 0.44,
    height: MediaQuery.of(context).size.width * 0.44 / 1.586,
    decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            spreadRadius: -7,
            offset: Offset(0, 0),
          ),
        ]),
    child: Center(
      child: cardLogo != ''
          ? CachedNetworkImage(
              imageUrl: cardLogo,
              width: MediaQuery.of(context).size.width * 0.37,
              height: MediaQuery.of(context).size.height * 0.09,
            )
          : Text(
              card.nickname,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: cardColor == Colors.white ? Colors.black : Colors.white,
                fontFamily: 'SFProRounded',
              ),
            ),
    ),
  );
}

Color getCardColor(FidelityCard card, Map<String, Store> stores) {
  final store = stores[card.storeID] ?? Store.fromEmpty();

  if (store.id == '') {
    return Colors.lightBlue;
  }

  return store.color;
}

String getCardLogo(FidelityCard card, Map<String, Store> stores) {
  final store = stores[card.storeID] ?? Store.fromEmpty();

  return storeLogos[store.name] ?? '';
}
