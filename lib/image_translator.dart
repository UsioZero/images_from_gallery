import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageTranslator extends StatefulWidget {
  ImageTranslator({Key key}) : super(key: key);

  @override
  _ImageTranslatorState createState() => _ImageTranslatorState();
}

class _ImageTranslatorState extends State<ImageTranslator> {
  List<AssetEntity> picturesList = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  _fetchImages() async {
    var result = await PhotoManager.requestPermission();
    if (result) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);

      List<AssetEntity> pictures = await albums[0].getAssetListPaged(0, 20);
      setState(() {
        picturesList = pictures;
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
      body: GridView.builder(
        itemCount: picturesList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: picturesList[index].thumbData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Image.memory(
                  snapshot.data,
                  fit: BoxFit.cover,
                );
              return Container();
            },
          );
        },
      ),
    );
  }
}
