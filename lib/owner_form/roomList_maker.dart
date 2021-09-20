import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data_provider.dart';
import 'roomtypeBox.dart';

class RoomsList extends StatefulWidget {
  const RoomsList({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DataProvider data;

  @override
  _RoomsListState createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: widget.data.roomData.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return RoomTypeBox(
              index: index,
              onDelete: () {
                widget.data.deleteRoom(widget.data.roomData[index]);
                setState(() {});
              },
            );
          }),
    );
  }
}
