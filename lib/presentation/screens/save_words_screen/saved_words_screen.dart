import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:one_dictionary/core/constants/strings.dart';
import 'package:one_dictionary/core/themes/app_theme.dart';
import 'package:one_dictionary/data/data_providers/box.dart';

import '../../../data/models/word_save_model.dart';

class SavedWordsScreen extends StatelessWidget {
  const SavedWordsScreen({Key? key}) : super(key: key);

  deleteWord(key) {
    final box = Boxes.getWordToBox();
    box.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<WordSave> list = [];
    final DateFormat formatted = DateFormat('dd-MM-yy');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Saved Words',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ValueListenableBuilder<Box<WordSave>>(
            valueListenable: Boxes.getWordToBox().listenable(),
            builder: (context, box, _) {
              list = box.values.toList().cast<WordSave>();
              if (list.isNotEmpty) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                        title: SelectableText(
                          list[i].word,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          formatted.format(
                            list[i].saveDate,
                          ),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        trailing: IconButton(
                          icon:  Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            deleteWord(list[i].key);
                          },
                        ));
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset('assets/rolling.json',
                          width: size.width * 0.8),
                      Text(
                        'No words found !',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                );
              }
            },
          )),
    );
  }
}
