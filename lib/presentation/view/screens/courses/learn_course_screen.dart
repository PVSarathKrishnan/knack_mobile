import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knack/data/models/booking_model.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:knack/presentation/view/screens/collections.dart';
import 'package:knack/presentation/view/screens/courses/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LearnCoursePage extends StatelessWidget {
  final BookingModel course;

  const LearnCoursePage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                children: List.generate(
                  course.courseDetails["chapters"].length,
                  (index) => GestureDetector(
                    onTap: () {
                      String videoLink = course.courseDetails["videos"][index];
                      final videoID = YoutubePlayer.convertUrlToId(
                        videoLink,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(
                            videoId: videoID!,
                            chapter: course.courseDetails["chapters"][index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(
                            course.courseDetails["chapters"][index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          splashColor: g,
                          subtitle: Text(
                            course.courseDetails["description"][index],
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
