import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageTranslator extends StatefulWidget {
  ImageTranslator({Key key}) : super(key: key);

  @override
  _ImageTranslatorState createState() => _ImageTranslatorState();
}

class _ImageTranslatorState extends State<ImageTranslator> {
  List<AssetEntity> picturesList = [];
  int pageNow = 0;
  int pageLast;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  _onScrollDown(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (pageNow != pageLast) {
        _fetchImages();
      }
    }
  }

  _fetchImages() async {
    pageLast = pageNow;
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      print(albums);
      List<AssetEntity> pictures =
          await albums[0].getAssetListPaged(pageNow, 60);
      print(pictures.length);
      if (pictures.length != 0)
        setState(() {
          picturesList.addAll(pictures);
          pageNow++;
          print(pageNow);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            'Image translator',
            style: TextStyle(fontSize: 20),
          ),
          leading: Icon(Icons.image),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScrollDown(notification);
          return;
        },
        child: GridView.builder(
          itemCount: picturesList.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: picturesList[index].thumbData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return FlatButton(
                    child: Image.memory(snapshot.data),
                    onPressed: () {
                      _onButtonPressed(
                          context, snapshot, picturesList[index].title);
                    },
                  );
                return Container();
              },
            );
          },
        ),
      ),
    );
  }

  Future _onButtonPressed(
      BuildContext context, AsyncSnapshot snapshot, String title) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Oh sheet, you pressed button'),
          content: Image.memory(snapshot.data),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Add'),
              onPressed: () {},
            ),
            CupertinoDialogAction(
              child: Text('Back'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
