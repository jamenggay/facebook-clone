import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/widgets/custom_inkwell_button.dart';
import 'package:tuazon_mobprog/widgets/like_icon.dart';
import 'package:tuazon_mobprog/widgets/share_icon.dart';
import 'package:tuazon_mobprog/widgets/comment_icon.dart';
import '../constants.dart';
import 'package:tuazon_mobprog/screens/detail_screen.dart';
import 'custom_font.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final DateTime date;
  final String likesCount;
  final int commentsCount;
  final int sharesCount;
  final String userImage;
  final String? imagePath;
  final bool showPlaceholder;
  final String adsMarket;

  const PostCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.userImage,
    this.likesCount = "0",
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.imagePath,
    this.showPlaceholder = false,
    this.adsMarket = '',
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likes = int.tryParse(widget.likesCount) ?? 0;
  }

  String formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    Widget buildPostImage() {
      // Constrain ad/market posts so the CTA row ("MORE DETAILS" + button)
      // never gets clipped/overlaps in fixed-height containers (e.g. CarouselSlider).
      final bool isAdsMarket = widget.adsMarket.isNotEmpty;
      final double adsImageHeight = 160.h;

      if (widget.imagePath == null) {
        if (!widget.showPlaceholder) {
          return SizedBox(height: ScreenUtil().setHeight(1));
        }

        return Container(
          height: isAdsMarket ? adsImageHeight : ScreenUtil().setHeight(150),
          width: double.infinity,
          color: Colors.grey[200],
          child: Center(
            child: Icon(
              Icons.image,
              size: ScreenUtil().setSp(40),
              color: Colors.grey,
            ),
          ),
        );
      }

      final Widget image = widget.imagePath!.startsWith('http')
          ? Image.network(
              widget.imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: double.infinity,
                  height: isAdsMarket ? adsImageHeight : null,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: isAdsMarket
                      ? adsImageHeight
                      : ScreenUtil().setHeight(150),
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      size: ScreenUtil().setSp(40),
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            )
          : Image.asset(
              widget.imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
            );

      if (isAdsMarket) {
        return SizedBox(
          width: double.infinity,
          height: adsImageHeight,
          child: image,
        );
      }

      return ClipRRect(borderRadius: BorderRadius.circular(8.r), child: image);
    }

    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              userName: widget.userName,
              postContent: widget.postContent,
              date: formatDate(widget.date),
              numOfLikes: _likes,
              imageUrl: widget.imagePath ?? '',
              profileImageUrl: widget.userImage,
            ),
          ),
        );

        if (result != null && result is Map && result['likes'] != null) {
          setState(() {
            _likes = result['likes'] as int;
            if (result['isLiked'] != null) _isLiked = result['isLiked'] as bool;
          });
        }
      },
      child: Card(
        color: FB_TEXT_COLOR_WHITE,
        margin: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Padding(
          padding: EdgeInsetsGeometry.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: widget.userImage.startsWith('http')
                        ? CachedNetworkImageProvider(widget.userImage)
                        : AssetImage(widget.userImage) as ImageProvider,
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: widget.userName,
                        fontSize: ScreenUtil().setSp(15),
                        color: FB_DARK_PRIMARY,
                        fontWeight: FontWeight.bold,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomFont(
                            text: formatDate(widget.date),
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.grey,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(3)),
                          Icon(
                            Icons.public,
                            color: Colors.grey,
                            size: ScreenUtil().setSp(15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.more_horiz),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              //post content
              CustomFont(
                text: widget.postContent,
                fontSize: ScreenUtil().setSp(12),
                color: FB_DARK_PRIMARY,
              ),
              SizedBox(height: ScreenUtil().setHeight(5)),
              buildPostImage(),

              // counts row (hide for ads/market posts)
              (widget.adsMarket != '')
                  ? const SizedBox()
                  : Column(
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(6)),
                        Row(
                          children: [
                            Text(
                              '$_likes likes',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${widget.commentsCount} comments',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(12)),
                            Text(
                              '${widget.sharesCount} shares',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(5)),
                      ],
                    ),
              (widget.adsMarket != '')
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LikeButton(
                          onPressed: () {
                            setState(() {
                              if (_isLiked) {
                                _likes = (_likes - 1) < 0 ? 0 : _likes - 1;
                                _isLiked = false;
                              } else {
                                _likes = _likes + 1;
                                _isLiked = true;
                              }
                            });
                          },
                          textColor: _isLiked
                              ? FB_DARK_PRIMARY
                              : FB_TEXT_COLOR_GREY,
                        ),
                        CommentButton(
                          onPressed: () {
                            print('Comment Tapped!');
                          },
                          textColor: FB_TEXT_COLOR_GREY,
                        ),
                        ShareButton(
                          onPressed: () {
                            print('Shared Tapped!');
                          },
                          textColor: FB_TEXT_COLOR_GREY,
                        ),
                      ],
                    ),
              (widget.adsMarket != '')
                  ? const SizedBox()
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(
                            'assets/images/userprofile.jpg',
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setSp(10),
                            0,
                            0,
                            0,
                          ),
                          alignment: Alignment.centerLeft,
                          height: ScreenUtil().setHeight(25),
                          width: ScreenUtil().setWidth(330),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setSp(10)),
                            ),
                          ),
                          child: CustomFont(
                            text: 'Write a comment...',
                            fontSize: ScreenUtil().setSp(11),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
              (widget.adsMarket != '')
                  ? Container(
                      padding: EdgeInsets.all(5.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomFont(
                                text: 'MORE DETAILS',
                                fontSize: 17.sp,
                                color: Colors.black,
                              ),
                              CustomFont(
                                text: widget.adsMarket,
                                fontSize: 17.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          CustomInkwellButton(
                            height: 40.h,
                            width: 90.w,
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  userName: widget.userName,
                                  postContent: widget.postContent,
                                  date: formatDate(widget.date),
                                  numOfLikes: _likes,
                                  imageUrl: widget.imagePath ?? '',
                                  profileImageUrl: widget.userImage,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              (widget.adsMarket != '')
                  ? const SizedBox()
                  : SizedBox(height: ScreenUtil().setHeight(10)),
              (widget.adsMarket != '')
                  ? const SizedBox()
                  : CustomFont(
                      text: 'View comments',
                      fontSize: ScreenUtil().setSp(11),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
