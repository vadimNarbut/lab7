abstract class NoteState{}

class LoadState extends NoteState{
  final List<String> notes;
  LoadState(this.notes);
}

class AddState extends NoteState{
  final String note;
  AddState(this.note);
}

class UpdateState extends NoteState{
  final int id;
  final String updatedNote;
  UpdateState(this.id, this.updatedNote);
}

class DeleteState extends NoteState{
  final int id;
  DeleteState(this.id);
}