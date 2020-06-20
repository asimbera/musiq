import 'package:animations/animations.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import './common.dart';
import './info.dart';
import '../entities/entities.dart';
import '../controllers/startup_controller.dart';
import '../services/player.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab;

  @override
  void initState() {
    _currentTab = 0;
    PlayerControl.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, _) {
          return FadeScaleTransition(
            animation: primaryAnimation,
            child: child,
          );
        },
        child: _tabSwitcher(_currentTab),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildMiniplayer(context),
            _buildBottomNavbar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavbar(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: _currentTab,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(LineAwesomeIcons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesomeIcons.search),
          title: Text('Search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(LineAwesomeIcons.music),
          title: Text('Library'),
        ),
      ],
      onTap: (idx) {
        setState(() => _currentTab = idx);
      },
      selectedItemColor: Theme.of(context).accentColor,
      unselectedItemColor: Theme.of(context).accentColor.withOpacity(0.4),
    );
  }

  Widget _buildMiniplayer(BuildContext context) {
    return StreamBuilder<PlayerStateStream>(
        stream: PlayerControl.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final queue = playerState?.queue;
          final mediaItem = playerState?.mediaItem;
          final state = playerState?.playbackState;
          final processingState =
              state?.processingState ?? AudioProcessingState.none;
          final playing = state?.playing ?? false;
          final progress = (state?.currentPosition?.inMilliseconds ?? 0) /
              (mediaItem?.duration?.inMilliseconds ?? 1);
          return processingState == AudioProcessingState.none
              ? Container()
              : Column(
                  children: <Widget>[
                    // Progress bar
                    SizedBox(
                      height: 1.2,
                      child: LinearProgressIndicator(
                        value: progress,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                            width: 0.5,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_up),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/player'),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    mediaItem?.title ?? 'Very Long Song Title',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    mediaItem?.artist ?? 'Artist Names',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyText1
                                          .color
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: queue == null
                                ? null
                                : mediaItem == queue?.first
                                    ? null
                                    : AudioService.skipToNext,
                          ),
                          IconButton(
                            icon: playing
                                ? Icon(Icons.pause_circle_filled)
                                : Icon(Icons.play_circle_filled),
                            onPressed: playing
                                ? AudioService.pause
                                : AudioService.play,
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: queue == null
                                ? null
                                : mediaItem == queue?.last
                                    ? null
                                    : AudioService.skipToNext,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        });
  }

  Widget _tabSwitcher(int idx) {
    switch (idx) {
      case 0:
        return Discover();
        break;
      case 1:
        return Search();
        break;
      default:
        return Container(
          color: Colors.red,
        );
    }
  }
}

class Discover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StartupController>(
      builder: (_, snapshot, __) => CustomScrollView(
        // physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Musiq'),
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () => Navigator.pushNamed(context, '/alerts'),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
          snapshot.isLoading
              ? _buildShimmer(context)
              : snapshot.launchData == null
                  ? _buildRetry(snapshot)
                  : _buildContent(context, snapshot.launchData),
        ],
      ),
    );
  }

  Widget _buildRetry(StartupController controller) {
    return SliverFillRemaining(
      child: Container(
        alignment: Alignment.center,
        child: RaisedButton(
          child: Text('Retry'),
          onPressed: () => controller.fetchData(),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return SliverToBoxAdapter(
      child: buildShimmerContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Container(
                height: 20,
                width: 150,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 130,
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 0.45,
                mainAxisSpacing: 5.0,
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  3,
                  (index) => Card(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Container(
                height: 20,
                width: 200,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 180,
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1.2,
                mainAxisSpacing: 5.0,
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  3,
                  (index) => Card(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Container(
                height: 20,
                width: 180,
                color: Colors.white,
              ),
            ),
            ...List.generate(
                3,
                (index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width),
                          child: Container(
                            height: 80,
                            color: Colors.white,
                          )),
                    )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LaunchDataEntity data) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // _buildTitle(data.greeting, fontSize: 24),
          // _buildCharts(context, data.charts),
          _buildTitle('Trending'),
          _buildGrid(context, data.newTrending, height: 180),
          _buildTitle('Albums'),
          _buildGrid(context, data.newAlbums, height: 220),
          _buildTitle('Playlists'),
          ..._buildList(context, data.topPlaylists)
        ],
      ),
    );
  }

  Widget _buildTitle(String title, {double fontSize = 16}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<BaseEntity> l, {
    double height = 180,
    double aspectRatio = 1.2,
  }) {
    return SizedBox(
      height: height,
      child: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: aspectRatio,
        mainAxisSpacing: 5.0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        children: l
            .map(
              (BaseEntity e) => Card(
                elevation: 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: e.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            e.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            e.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildCharts(
    BuildContext context,
    List<BaseEntity> e, {
    int axisCount = 1,
  }) {
    return SizedBox(
      height: (160 * axisCount).toDouble(),
      child: GridView.count(
        crossAxisCount: axisCount,
        childAspectRatio: 0.5,
        mainAxisSpacing: 15.0,
        // crossAxisSpacing: 1.0,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        scrollDirection: Axis.horizontal,
        children: e
            .map(
              (e) => ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: OpenContainer(
                  openBuilder: (_, __) => Info(entity: e),
                  closedBuilder: (_, __) => Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(e.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black12,
                                Colors.transparent,
                                Colors.black38,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          child: Text(
                            e.title,
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _buildList(
    BuildContext context,
    List<BaseEntity> playlists,
  ) {
    return playlists
        .map(
          (e) => buildListItem(
            context: context,
            onPress: () => goToInfo(context, e),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 15,
            ),
            title: e.title,
            subtitle: e.subtitle,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(150),
              child: CachedNetworkImage(
                imageUrl: e.image,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
        )
        .toList();
  }

  void goToInfo(
    BuildContext context,
    BaseEntity entity,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Info(
          entity: entity,
        ),
      ),
    );
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StartupController>(
      builder: (_, controller, __) => CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Musiq'),
            //floating: true,
            pinned: true,
            actions: <Widget>[],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              // color: Colors.black12,
              alignment: Alignment.center,
              child: RaisedButton.icon(
                onPressed: () => null,
                icon: Icon(Icons.search),
                label: Text('Search'),
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[200]
                    : Colors.grey[700].withBlue(100),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 150,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: controller.isSearchLoading
                ? Container(
                    alignment: Alignment.center,
                    height: 250,
                    child: CircularProgressIndicator(),
                  )
                : controller.topSearches != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          'Top Searches',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: 250,
                        child: Text('Unable to retrieve top searches.'),
                      ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              controller.topSearches != null
                  ? controller.topSearches
                      .map(
                        (e) => GestureDetector(
                          onTap: () => null,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10,
                                  ),
                                  child: ClipRRect(
                                    child: CachedNetworkImage(
                                      imageUrl: e.image,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
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
                                          toTitleCase(e.type),
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
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList()
                  : [],
            ),
          )
        ],
      ),
    );
  }
}
