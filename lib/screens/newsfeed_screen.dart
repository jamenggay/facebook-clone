import 'package:flutter/material.dart';
import 'package:tuazon_mobprog/widgets/post_card.dart';

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //UI
    return ListView(
      children: [
        PostCard(
          userName: 'Jamaine Tuazon',
          postContent: 'na para bang non-existent and weekend',
          likesCount: "321",
          commentsCount: 12,
          sharesCount: 3,
          date: DateTime.now().subtract(Duration(days: 1)),
          userImage: 'assets/images/userprofile.jpg',
        ),
        PostCard(
          userName: 'NU Central Student Government',
          postContent: 'PAGEANT SLUSH PROTEST SLUSH PROWESS!',
          likesCount: "124",
          commentsCount: 8,
          sharesCount: 15,
          imagePath: 'assets/images/imagepost.jpg',
          showPlaceholder: false,
          date: DateTime.now().subtract(Duration(minutes: 13)),
          userImage: 'assets/images/otherprofile.jpg',
        ),
        PostCard(
          userName: 'ABS-CBN',
          postContent: 'Rules are made to be followed, guys',
          likesCount: "781",
          commentsCount: 14,
          sharesCount: 11,
          imagePath: 'assets/images/imagepost2.jpg',
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: 'assets/images/otherprofile3.jpg',
        ),
        PostCard(
          userName: 'ABS-CBN',
          postContent: "Ang lala! Hindi na 'yan tama. 😢😢😢",
          likesCount: "5.4K",
          commentsCount: 357,
          sharesCount: 158,
          imagePath: 'assets/images/imagepost4.jpg',
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: 'assets/images/otherprofile3.jpg',
        ),
        PostCard(
          userName: 'AWS Cloud Clubs Philippines',
          postContent: 'Phase 2 emails are finally here! ^^',
          likesCount: "9",
          commentsCount: 3,
          sharesCount: 3,
          imagePath: 'assets/images/imagepost3.jpg',
          date: DateTime.now().subtract(Duration(hours: 9)),
          userImage: 'assets/images/otherprofile2.jpg',
        ),
      ],
    );
  }
}
