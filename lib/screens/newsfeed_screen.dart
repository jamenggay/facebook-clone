import 'package:flutter/material.dart';
import 'package:tuazon_mobprog/widgets/newsfeed_card.dart';

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //UI
    return ListView(
      children: [
        NewsfeedCard(
          userName: 'Jamaine Tuazon',
          postContent: 'na para bang non-existent and weekend',
          likesCount: 321,
          commentsCount: 12,
          sharesCount: 3,
          date: DateTime.now().subtract(Duration(days: 1)),
          userImage: 'assets/images/userprofile.jpeg',
        ),
        NewsfeedCard(
          userName: 'NU Central Student Government',
          postContent: 'PAGEANT SLUSH PROTEST SLUSH PROWESS!',
          likesCount: 124,
          commentsCount: 8,
          sharesCount: 15,
          imagePath: 'assets/images/imagepost.jpg',
          showPlaceholder: false,
          date: DateTime.now().subtract(Duration(minutes: 13)),
          userImage: 'assets/images/otherprofile.jpg',
        ),
      ],
    );
  }
}
