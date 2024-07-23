abstract class NoteEvent{}

class LoadEvent extends NoteEvent {}

class AddEvent extends NoteEvent{
  final String note;
  AddEvent(this.note);
}

class UpdateEvent extends NoteEvent{
  final int  id;
  final String updatedNote;
  UpdateEvent(this.id, this.updatedNote);
}

class DeleteEvent extends NoteEvent{
  final int id;
  DeleteEvent(this.id);
}