import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:palyer_app/controller/player_controller.dart';
import 'package:palyer_app/page/player_page.dart';
import 'package:palyer_app/resource/app_colors.dart';
import 'package:palyer_app/resource/text_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
      
        
        title: Text(
          'BEATS',
          style: outStyle(
            size: 20,
            
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return  Center(
              child: CircularProgressIndicator(
                color: bacColor,
                strokeWidth: 6,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: outStyle(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No Song Found',
                style: outStyle(),
              ),
            );
          }
          final songs = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: songs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: bacColor,
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Obx(
                    () => ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: bgColor,
                      title: Text(
                        songs[index].displayNameWOExt,
                        style: outStyle(size: 15),
                      ),
                      subtitle: Text(
                        "${songs[index].artist}",
                        style: outStyle(size: 12),
                      ),
                      leading: QueryArtworkWidget(
                        id: songs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: Icon(
                          Icons.music_note,
                          color: WhiteColor,
                          size: 32,
                        ),
                      ),
                      trailing: controller.playIndex.value == index && controller.isPlaying.value
                          ? Icon(Icons.play_arrow, color: WhiteColor, size: 26)
                          : null,
                      onTap: () {
                        Get.to(
                          () => Player(data: songs),
                          transition: Transition.downToUp,
                        );
                        controller.PlaySong(songs[index].uri, index);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
