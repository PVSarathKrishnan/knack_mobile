import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knack/data/models/booking_model.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/video_player.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LearnCoursePage extends StatelessWidget {
  final BookingModel course;

  const LearnCoursePage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return DraggableHome(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Text(course.course_title),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
      headerWidget: headerWidget(context),
      body: [
        SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  course.course_title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                course.courseDetails["overview"],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Chapters:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: course.courseDetails["chapters"].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          String videoLink =
                              course.courseDetails["videos"][index];
                          final videoID = YoutubePlayer.convertUrlToId(
                            videoLink,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(
                                videoId: videoID!,
                                chapter: course.courseDetails["chapters"]
                                    [index],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: TapToExpand(
                            width: screenWidth,
                            content: Column(
                              children: [
                                Text(
                                  course.courseDetails["description"][index],
                                  style: text_style_n.copyWith(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                )
                              ],
                            ),
                            title: Text(
                              course.courseDetails["chapters"][index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          splashColor: g,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      fullyStretchable: true,
      expandedBody: SizedBox.shrink(),
      backgroundColor: Colors.white,
      appBarColor: g,
    );
  }

  Widget headerWidget(BuildContext context) {
    return Image.network(
      course.courseDetails["photo"],
      fit: BoxFit.fill,
    );
  }
}
