import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './common.dart';
import './details.dart';
import '../controllers/startup_controller.dart';
import '../entities/entities.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(context, '/search'),
            )
          ],
          bottom: TabBar(
            // indicatorSize: TabBarIndicatorSize.label,
            // isScrollable: true,
            tabs: <Tab>[
              Tab(text: 'Trending'),
              Tab(text: 'Albums'),
              Tab(text: 'Playlist'),
              // Tab(text: 'Charts'),
            ],
          ),
        ),
        drawer: SharedDrawer(),
        bottomNavigationBar: BottomPlayerBar(),
        body: Consumer<StartupController>(
          builder: (_, controller, child) {
            return TabBarView(
              children: <Widget>[
                controller.isLoading
                    ? _buildLoader()
                    : controller.launchData == null
                        ? _buildRetry(controller)
                        : _buildGridView(
                            context, controller.launchData.newTrending),
                controller.isLoading
                    ? _buildLoader()
                    : controller.launchData == null
                        ? _buildRetry(controller)
                        : _buildGridView(
                            context, controller.launchData.newAlbums),
                controller.isLoading
                    ? _buildLoader()
                    : controller.launchData == null
                        ? _buildRetry(controller)
                        : _buildGridView(
                            context, controller.launchData.topPlaylists),
                // controller.isLoading
                //     ? _buildLoader()
                //     : controller.launchData == null
                //         ? _buildRetry(controller)
                //         : _buildGridView(controller.launchData.topPlaylists),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRetry(StartupController controller) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        child: Text('Retry'),
        onPressed: () => controller.fetchData(),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<BaseEntity> list) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(5),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 0.9,
      children: list.map((entity) => _buildGridItem(context, entity)).toList(),
    );
  }

  Widget _buildGridItem(BuildContext context, BaseEntity entity) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Details(
            entity: entity,
          ),
        ),
      ),
      child: Card(
        elevation: 1.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: CachedNetworkImage(
                imageUrl: entity.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    entity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    entity.subtitle,
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
    );
  }
}
