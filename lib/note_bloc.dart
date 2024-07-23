import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab7/note.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  List<String> notes = [];

  NoteBloc() : super(LoadState([])) {
    on<LoadEvent>((event, emit) {
      emit(LoadState(notes));
    });

    on<AddEvent>((event, emit){
      notes.add(event.note);
      emit(AddState(event.note));
    });

    on<UpdateEvent>((event, emit){
      notes[event.id] = event.updatedNote;
      emit(UpdateState(event.id, event.updatedNote));
    });

    on<DeleteEvent>((event, emit){
      notes.removeAt(event.id);
      emit(DeleteState(event.id));
    });
  }
}