import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:kana_bus/barrel.dart';
import 'package:logger/web.dart';
// import 'package:kana_bus/barrel.dart';

class DatabaseRepository {
  // final FirebaseFirestore _firebaseFirestore;
  // final Logger _log;

  DatabaseRepository({FirebaseFirestore? firebaseFirestore, Logger? logger});
  // : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
  //   _log = logger ?? Logger();

  Future<TranslationResult> translateWord(
    String text,
    TranslationType type,
  ) async {
    final callable = FirebaseFunctions.instance.httpsCallable('translateWord');
    final result = await callable.call<Map<String, dynamic>>({
      'text': text,
      'sourceType': type.name,
    });
    print('back');
    print(result);
    // return TranslationResult.fromJson(result.data);
    // Casting via Map<String, dynamic>.from handles the JS-interop map shape on web.
    return TranslationResult.fromJson(Map<String, dynamic>.from(result.data));
  }

  /// (Firebase) Get a list of stories
  // Future<List<Story>> getStories(bool? showArchived) async {
  //   List<Story> storiesList = [];

  //   try {
  //     late QuerySnapshot<Map<String, dynamic>> doc;
  //     if (showArchived!) {
  //       doc = await _firebaseFirestore.collection('stories').get();
  //     } else {
  //       doc = await _firebaseFirestore
  //           .collection('stories')
  //           .where('isArchived', isEqualTo: false)
  //           .get();
  //     }

  //     for (var snap in doc.docs) {
  //       storiesList.add(Story.fromSnapshot(snap));
  //     }
  //   } catch (err) {
  //     _log.e('getStories error', error: err);
  //   }
  //   return storiesList;
  // }

  // /// (Firebase) Create a story document and add the new story to it.
  // Future<Story> createStory({required Story newStory}) async {
  //   DocumentReference docRef = await _firebaseFirestore
  //       .collection('stories')
  //       .add({});
  //   await _firebaseFirestore
  //       .collection('stories')
  //       .doc(docRef.id)
  //       .set(newStory.copyWith(id: docRef.id).toJson());
  //   return newStory.copyWith(id: docRef.id);
  // }

  // /// (Firebase) Delete a story via id.
  // Future<void> deleteStory({required String storyId}) async {
  //   return _firebaseFirestore.collection('stories').doc(storyId).delete();
  // }

  // /// (Firebase) Update a story via id.
  // Future<void> updateStory({required Story story}) async {
  //   return _firebaseFirestore
  //       .collection('stories')
  //       .doc(story.id)
  //       .update(story.toJson());
  // }
}
