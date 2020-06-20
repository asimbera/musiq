import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import './common.dart';

class Queue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<MediaItem>>(
        stream: AudioService.queueStream,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('Queue'),
                leading: IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete_sweep),
                    onPressed: () => print('Clear Queue'),
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(snapshot.data != null
                    ? snapshot.data.map(
                        (e) => GestureDetector(
                          onTap: () => null,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[200]
                                  : Colors.grey[700].withBlue(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.music_note,
                                    size: 25,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          e.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          e.album,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    tryParseDuration(e.duration),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ).toList()
                    : []),
              ),
            ],
          );
        },
      ),
    );
  }
}
