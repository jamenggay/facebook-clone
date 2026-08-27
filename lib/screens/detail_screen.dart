import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tuazon_mobprog/constants.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';
import '../services/shared_preference.dart';
import '../widgets/custom_font.dart';
import '../widgets/like_icon.dart';
import '../widgets/comment_icon.dart';
import '../widgets/share_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;

  final int postId;
  final String postTitle;
  final bool isLiked;
  final String currentUserImage;

  const DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    required this.date,
    this.imageUrl = '',
    this.profileImageUrl = '',
    this.postId = 0,
    this.postTitle = '',
    this.isLiked = false,
    this.currentUserImage = 'assets/images/userprofile.jpg',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CommentService _commentService = CommentService();
  final SessionService _session = SessionService();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  late int _currentLikes;
  late bool _isLiked;

  List<Comment> _comments = [];
  bool _isLoadingComments = true;
  String _commentsError = '';
  bool _isSending = false;

  final Set<int> _likedComments = {};

  int _userId = 0;
  String _userName = 'You';

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.numOfLikes;
    _isLiked = widget.isLiked;
    _loadSignedInUser();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  Future<void> _loadSignedInUser() async {
    final user = await _session.getUser();
    if (user == null || !mounted) return;
    setState(() {
      _userId = user.id;
      _userName = user.fullName.isEmpty ? user.username : user.fullName;
    });
  }

  Future<void> _loadComments() async {
    if (widget.postId <= 0) {
      setState(() => _isLoadingComments = false);
      return;
    }

    try {
      final comments = await _commentService.getCommentsByPostId(widget.postId);
      if (!mounted) return;
      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingComments = false;
        _commentsError = 'Could not load the comments. Please try again.';
      });
    }
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _currentLikes = (_currentLikes - 1) < 0 ? 0 : _currentLikes - 1;
        _isLiked = false;
      } else {
        _currentLikes = _currentLikes + 1;
        _isLiked = true;
      }
    });
  }

  void _toggleCommentLike(int commentId) {
    setState(() {
      if (_likedComments.contains(commentId)) {
        _likedComments.remove(commentId);
      } else {
        _likedComments.add(commentId);
      }
    });
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (widget.postId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This post does not accept comments.')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final created = await _commentService.addComment(
        body: text,
        postId: widget.postId,
        userId: _userId,
      );

      if (!mounted) return;

      if (created == null) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not add the comment.')),
        );
        return;
      }

      setState(() {
        _comments.insert(
          0,
          Comment(
            id: created.id,
            postId: created.postId,
            body: created.body,
            likes: 0,
            userId: _userId,
            username: created.username,
            fullName: created.fullName.isEmpty ? _userName : created.fullName,
          ),
        );
        _commentController.clear();
        _isSending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not reach the server.')),
      );
    }
  }

  Map<String, dynamic> get _result => {
    'likes': _currentLikes,
    'isLiked': _isLiked,
    if (_commentsError == '' && !_isLoadingComments)
      'comments': _comments.length,
  };

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _result);
        return false;
      },
      child: Scaffold(
        backgroundColor: FB_SURFACE,
        appBar: AppBar(
          backgroundColor: FB_LIGHT_PRIMARY,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, _result),
          ),
          centerTitle: true,
          title: CustomFont(
            text: widget.userName,
            fontSize: ScreenUtil().setSp(20),
            color: FB_TEXT_COLOR_WHITE,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPostImage(),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    _buildPostHeader(),
                    SizedBox(height: ScreenUtil().setHeight(15)),
                    _buildPostBody(),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    _buildActionRow(),
                    Divider(color: FB_SECONDARY),
                    _buildCommentsSection(),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                  ],
                ),
              ),
            ),
            _buildAddCommentBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    if (widget.imageUrl == '') return const SizedBox();

    if (widget.imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: ScreenUtil().setHeight(150),
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: ScreenUtil().setHeight(150),
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      );
    }
    return Image.asset(widget.imageUrl, width: double.infinity);
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Row(
        children: [
          (widget.profileImageUrl == '')
              ? const Icon(Icons.person)
              : CircleAvatar(
                  radius: ScreenUtil().setSp(25),
                  backgroundImage: widget.profileImageUrl.startsWith('http')
                      ? CachedNetworkImageProvider(widget.profileImageUrl)
                      : AssetImage(widget.profileImageUrl) as ImageProvider,
                ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFont(
                  text: widget.userName,
                  fontSize: ScreenUtil().setSp(18),
                  color: FB_TEXT_PRIMARY,
                  fontWeight: FontWeight.bold,
                ),
                Row(
                  children: [
                    CustomFont(
                      text: widget.date,
                      fontSize: ScreenUtil().setSp(13),
                      color: Colors.grey,
                    ),
                    SizedBox(width: ScreenUtil().setWidth(3)),
                    Icon(
                      Icons.public,
                      color: Colors.grey,
                      size: ScreenUtil().setSp(14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (widget.postTitle == '')
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
                  child: CustomFont(
                    text: widget.postTitle,
                    fontSize: ScreenUtil().setSp(16),
                    color: FB_DARK_PRIMARY,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          CustomFont(
            text: widget.postContent,
            fontSize: ScreenUtil().setSp(14),
            color: FB_TEXT_PRIMARY,
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Row(
            children: [
              Text(
                '$_currentLikes likes',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${_comments.length} comments',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LikeButton(
            onPressed: _toggleLike,
            textColor: _isLiked ? FB_DARK_PRIMARY : FB_TEXT_COLOR_GREY,
            isLiked: _isLiked,
          ),
          CommentButton(
            onPressed: () => _commentFocus.requestFocus(),
            textColor: FB_TEXT_COLOR_GREY,
          ),
          ShareButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post shared!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            textColor: FB_TEXT_COLOR_GREY,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFont(
            text: 'Comments',
            fontSize: ScreenUtil().setSp(16),
            color: FB_DARK_PRIMARY,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          if (_isLoadingComments)
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Center(
                child: CircularProgressIndicator(color: FB_LIGHT_PRIMARY),
              ),
            )
          else if (_commentsError != '')
            CustomFont(
              text: _commentsError,
              fontSize: ScreenUtil().setSp(13),
              color: Colors.grey,
            )
          else if (_comments.isEmpty)
            CustomFont(
              text: 'No comments yet. Be the first to comment!',
              fontSize: ScreenUtil().setSp(13),
              color: Colors.grey,
            )
          else
            Column(children: _comments.map(_buildCommentTile).toList()),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    final bool liked = _likedComments.contains(comment.id);
    final int likes = liked ? comment.likes + 1 : comment.likes;

    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: FB_SECONDARY,
            backgroundImage: comment.image == ''
                ? null
                : CachedNetworkImageProvider(comment.image),
            child: comment.image == ''
                ? const Icon(Icons.person, size: 16, color: Colors.white)
                : null,
          ),
          SizedBox(width: ScreenUtil().setWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  decoration: BoxDecoration(
                    color: fbDarkMode ? FB_CARD : Colors.grey[200],
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFont(
                        text: comment.fullName.isEmpty
                            ? comment.username
                            : comment.fullName,
                        fontSize: ScreenUtil().setSp(13),
                        color: FB_DARK_PRIMARY,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(2)),
                      CustomFont(
                        text: comment.body,
                        fontSize: ScreenUtil().setSp(13),
                        color: FB_TEXT_PRIMARY,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _toggleCommentLike(comment.id),
                      icon: Icon(
                        liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: ScreenUtil().setSp(14),
                        color: liked ? FB_DARK_PRIMARY : FB_TEXT_COLOR_GREY,
                      ),
                      label: Text(
                        '$likes',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(12),
                          color: liked ? FB_DARK_PRIMARY : FB_TEXT_COLOR_GREY,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentBar() {
    return Container(
      color: FB_CARD,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
        vertical: ScreenUtil().setHeight(8),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: widget.currentUserImage.startsWith('http')
                  ? CachedNetworkImageProvider(widget.currentUserImage)
                  : AssetImage(widget.currentUserImage) as ImageProvider,
            ),
            SizedBox(width: ScreenUtil().setWidth(10)),
            Expanded(
              child: TextField(
                controller: _commentController,
                focusNode: _commentFocus,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(13),
                  color: FB_TEXT_PRIMARY,
                ),
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: TextStyle(
                    color: FB_TEXT_COLOR_GREY,
                    fontSize: ScreenUtil().setSp(13),
                    fontFamily: 'Frutiger',
                  ),
                  filled: true,
                  fillColor: fbDarkMode ? FB_SURFACE : Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(15),
                    vertical: ScreenUtil().setHeight(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            _isSending
                ? Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                    child: SizedBox(
                      height: ScreenUtil().setSp(20),
                      width: ScreenUtil().setSp(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: FB_LIGHT_PRIMARY,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.send, color: FB_LIGHT_PRIMARY),
                    onPressed: _addComment,
                  ),
          ],
        ),
      ),
    );
  }
}
