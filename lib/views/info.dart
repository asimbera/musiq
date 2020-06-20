import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import './common.dart';
import '../entities/entities.dart';
import '../locator.dart';
import '../services/player.dart';
import '../services/saavn.dart';

class Info extends StatelessWidget {
  final BaseEntity _entity;
  const Info({
    Key key,
    BaseEntity entity,
  })  : assert(entity != null),
        _entity = entity,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildInfoRouter(),
    );
  }

  Widget buildInfoRouter() {
    switch (_entity.type) {
      case 'song':
        return _Song();
        break;
      case 'album':
        return _Album();
        break;
      case 'playlist':
        return _Playlist(entity: _entity);
        break;
      default:
        return _NotImplemented();
    }
  }
}

class _Song extends StatefulWidget {
  _Song({Key key}) : super(key: key);

  @override
  __SongState createState() => __SongState();
}

class __SongState extends State<_Song> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Album extends StatefulWidget {
  _Album({Key key}) : super(key: key);

  @override
  __AlbumState createState() => __AlbumState();
}

class __AlbumState extends State<_Album> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Playlist extends StatefulWidget {
  final BaseEntity entity;
  _Playlist({Key key, this.entity}) : super(key: key);

  @override
  __PlaylistState createState() => __PlaylistState();
}

class __PlaylistState extends State<_Playlist> {
  bool _isLoading;
  PlaylistEntity _playlist;

  @override
  void initState() {
    _isLoading = true;
    _fetchData();
    super.initState();
  }

  Future _fetchData() async {
    setState(() => _isLoading = true);
    final _u = Uri.parse(widget.entity.permaUrl).pathSegments.last;
    final _p = await sl<Saavn>().getPlaylist(_u);
    if (_p != null) setState(() => _playlist = _p);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Playlist'),
            // centerTitle: true,
            pinned: true,
            // backgroundColor: Colors.transparent,
            elevation: 5,
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: Navigator.of(context).pop,
            ),
            actions: <Widget>[
              IconButton(
                icon: true ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                iconSize: 22,
                color: Colors.pink,
                onPressed: () => null,
              )
            ],
          ),
          _isLoading
              ? _buildShimmer(context)
              : _playlist == null ? _buildRetry() : _buildContent(context),
          SliverList(
            delegate: SliverChildListDelegate(
              _playlist == null
                  ? []
                  : _playlist.list
                      .map(
                        (e) => buildListItem(
                          context: context,
                          leading: ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: e.image,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: e.title,
                          subtitle: e.subtitle,
                          trailing: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              tryParseDuration(
                                Duration(
                                  seconds: int.tryParse(
                                    e.moreInfo.duration,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          onPress: () => PlayerControl.playNow(e),
                        ),
                      )
                      .toList(),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }

  Widget _buildRetry() {
    return SliverFillRemaining(
      child: Container(
        alignment: Alignment.center,
        child: RaisedButton(
          child: Text('Retry'),
          onPressed: () => _fetchData(),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return SliverToBoxAdapter(
      child: buildShimmerContainer(
          context: context,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.white,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 16,
                    width: 150,
                    color: Colors.white,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 12,
                    width: 250,
                    color: Colors.white,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 60,
                    width: 200,
                    color: Colors.white,
                  ),
                ),
                ...List.generate(
                    5,
                    (index) => Container(
                          alignment: Alignment.center,
                          height: 60,
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          color: Colors.white,
                        )),
              ],
            ),
          )),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 140,
                      width: 140,
                      color: Colors.black12,
                      child: CachedNetworkImage(
                        imageUrl: _playlist.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _playlist.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
//                        fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            _playlist.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                RaisedButton.icon(
                                  elevation: 0,
                                  onPressed: () => null,
                                  icon: Icon(Icons.play_arrow),
                                  label: Text(
                                    'Play All',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: Colors.pink,
                                  colorBrightness: Brightness.dark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotImplemented extends StatelessWidget {
  const _NotImplemented({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Not Implemented'),
    );
  }
}
