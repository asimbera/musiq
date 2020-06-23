import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './common.dart';
import '../entities/entities.dart';
import '../locator.dart';
import '../services/player.dart';
import '../services/saavn.dart';

class Details extends StatefulWidget {
  final BaseEntity _entity;
  const Details({
    Key key,
    BaseEntity entity,
  })  : assert(entity != null),
        _entity = entity,
        super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool _loading = true;
  dynamic _info;

  @override
  void initState() {
    _fetchInfo(widget._entity);
    super.initState();
  }

  void _fetchInfo(BaseEntity _e) async {
    setState(() => _loading = true);
    final _path = Uri.parse(_e.permaUrl).pathSegments.last;
    switch (_e.type) {
      case 'playlist':
        final _i = await sl<Saavn>().getPlaylist(_path);
        setState(() => _info = _i);
        break;
      case 'album':
        final _i = await sl<Saavn>().getAlbum(_path);
        setState(() => _info = _i);
        break;
      case 'song':
      default:
        print(_path);
        break;
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    print(widget._entity.type);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // title: Text(_entity.title),
            // pinned: true,
            floating: true,
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget._entity.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget._entity.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            widget._entity.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              stretchModes: [StretchMode.blurBackground, StretchMode.fadeTitle],
            ),
          ),
          if (_loading) _buildLoader(),
          if (!_loading && _info == null) _buildRetryButton(),
          ..._buildContent(_info),
        ],
      ),
      bottomNavigationBar: BottomPlayerBar(),
    );
  }

  Widget _buildRetryButton() {
    return SliverFillRemaining(
      child: Container(
        alignment: Alignment.center,
        child: RaisedButton(
          child: Text('Retry'),
          onPressed: () => _fetchInfo(widget._entity),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return SliverFillRemaining(
      child: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  List<Widget> _buildContent(dynamic _i) {
    print(_i.runtimeType);
    switch (_i.runtimeType) {
      case PlaylistEntity:
        final _a = _i as PlaylistEntity;
        return [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(width: 0.5, color: Colors.grey[300]),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(toTitleCase(_a.type)),
                  Text('  -  '),
                  Text('${_a.list.length} Songs')
                ],
              ),
            ),
          ),
          _buildSongItem(_a.list),
        ];
        break;
      case AlbumEntity:
        final _a = _i as AlbumEntity;

        return [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(width: 0.5, color: Colors.grey[300]),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(toTitleCase(_a.type)),
                  Text('  -  '),
                  Text('${_a.list.length} Songs')
                ],
              ),
            ),
          ),
          _buildSongItem(_a.list),
        ];
        break;
      default:
        return [];
    }
  }

  Widget _buildSongItem(List<Song> _l) {
    return SliverList(
      delegate: SliverChildListDelegate(
        _l
            .map(
              (e) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: e.image,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  e.title,
                  maxLines: 1,
                ),
                subtitle: Text(
                  e.subtitle,
                  maxLines: 1,
                ),
                onTap: () => PlayerControl.playNow(e),
                // dense: true,
              ),
            )
            .toList(),
      ),
    );
  }
}
