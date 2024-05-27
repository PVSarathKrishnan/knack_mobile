import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String chapter;
  final String description;
  final List<dynamic> descriptions;
  final List<dynamic> chapters;
  final List<dynamic> videoIds;

  VideoPlayerPage({
    Key? key,
    required this.videoId,
    required this.chapter,
    required this.description,
    required this.chapters,
    required this.videoIds,
    required this.descriptions,
  }) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        forceHD: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    int currentIndex = widget.chapters.indexOf(widget.chapter);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.chapter,
          style: text_style_n,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.descriptions[currentIndex],
                style: text_style_n.copyWith()
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentIndex > 0)
                    Center(
                      child: Container(
                        width: screenWidth / 2,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the previous chapter's video player page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerPage(
                                  videoId: widget.videoIds[currentIndex - 1],
                                  chapter: widget.chapters[currentIndex - 1],
                                  descriptions: widget.descriptions,
                                  description: widget.description,
                                  chapters: widget.chapters,
                                  videoIds: widget.videoIds,
                                ),
                              ),
                            );
                          },
                          child: Text('Play Previous Chapter'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              currentIndex == 0 ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10),
                  if (currentIndex < widget.chapters.length - 1)
                    Center(
                      child: Container(
                        width: screenWidth / 2,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to the next chapter's video player page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerPage(
                                  videoId: widget.videoIds[currentIndex + 1],
                                  chapter: widget.chapters[currentIndex + 1],
                                  description: widget.description,
                                  chapters: widget.chapters,
                                  descriptions: widget.descriptions,
                                  videoIds: widget.videoIds,
                                ),
                              ),
                            );
                          },
                          child: Text('Play Next Chapter'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              currentIndex == widget.chapters.length - 1
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
