import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fynxfitcoaches/resources/resources_event.dart';
import 'package:fynxfitcoaches/resources/resources_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ResourceBloc() : super(ResourceInitial()) {
    on<LoadWorkoutVideos>((event, emit) async {
      emit(ResourceLoading());
      try {
        QuerySnapshot snapshot = await _firestore.collection("workouts").get();
        List<Map<String, dynamic>> workouts = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
        emit(WorkoutVideosLoaded(workouts: workouts));
      } catch (e) {
        emit(ResourceError(message: e.toString()));
      }
    });

    on<LoadArticles>((event, emit) async {
      emit(ResourceLoading());
      try {
        QuerySnapshot snapshot = await _firestore.collection("Articles").get();
        List<Map<String, dynamic>> articles = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
        emit(ArticlesLoaded(articles: articles));
      } catch (e) {
        emit(ResourceError(message: e.toString()));
      }
    });
  }
}
