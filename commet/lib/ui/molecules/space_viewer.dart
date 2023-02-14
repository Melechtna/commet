import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../client/client.dart';

class SpaceViewer extends StatefulWidget {
  SpaceViewer(this.space, {super.key});
  Space space;

  @override
  State<SpaceViewer> createState() => _SpaceViewerState();
}

class _SpaceViewerState extends State<SpaceViewer>
    with TickerProviderStateMixin {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  int _count = 0;
  late List<Room> _rooms;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    widget.space.onUpdate.stream.listen((event) {
      setState(() {});
    });

    _rooms = widget.space.rooms.getItems(onChange: (i) {
      _listKey.currentState?.setState(() {});
    }, onInsert: (i) {
      _listKey.currentState
          ?.insertItem(i, duration: Duration(milliseconds: 300));
      _count++;
    }, onRemove: (i) {
      _count--;
      _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
    });

    _count = _rooms.length;
    print("Rooms: $_count");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SpaceViewer oldWidget) {
    _listKey = GlobalKey();

    _rooms = widget.space.rooms.getItems(onChange: (i) {
      _listKey.currentState?.setState(() {});
    }, onInsert: (i) {
      _listKey.currentState
          ?.insertItem(i, duration: Duration(milliseconds: 300));
      _count++;
    }, onRemove: (i) {
      _count--;
      _listKey.currentState?.removeItem(i, (_, __) => const ListTile());
    });

    _count = _rooms.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(widget.space.displayName,
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(
              width: 300,
              height: 500,
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _count,
                itemBuilder: (context, i, animation) => SlideTransition(
                  position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                      .animate(animation),
                  child: Text(_rooms[i].displayName),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
