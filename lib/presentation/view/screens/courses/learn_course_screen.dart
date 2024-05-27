import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knack/data/models/booking_model.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/video_player.dart';
import 'package:knack/presentation/view/style/text_style.dart';
import 'package:tap_to_expand/tap_to_expand.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_expandable_text/flutter_expandable_text.dart';

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
                  SingleChildScrollView(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(),
                      scrollDirection: Axis.vertical,
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
                                    description: course
                                        .courseDetails["description"][index],
                                    descriptions:
                                        course.courseDetails["description"],
                                    chapters: course.courseDetails["chapters"],
                                    videoIds: course.courseDetails["videos"]
                                        .map((link) =>
                                            YoutubePlayer.convertUrlToId(link))
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color.fromARGB(245, 245, 245, 245),
                              ),
                              child: ListTile(
                                subtitle: ExpandableText(
                                  course.courseDetails["description"][index],

                                  readMoreText: 'Read more',
                                  readLessText: 'Show less',
                                  trim:
                                      4, // Maximum number of lines to show before collapsing
                                  style: text_style_n.copyWith(
                                    color: v,
                                  ),
                                ),
                                title: Text(
                                  course.courseDetails["chapters"][index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
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
