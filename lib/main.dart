import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab7/note_bloc.dart';
import 'note.dart';

import 'note_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => NoteBloc(),
        child: NotesApp(),
      ),
    );
  }
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => NotePage(),
        '/': (context) => NotesListScreen(),
        '/create': (context) => CreateNoteScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final Note note = settings.arguments as Note;
          return MaterialPageRoute(
            builder: (context) {
              return NoteDetailScreen(note: note);
            },
          );
        }
        return null;
      },
      home: BlocProvider(
        create: (context) => NoteBloc(),
        //child: NotePage(),
        child: NotesListScreen(),
      ),
    );
  }
}

class NotePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is LoadState) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.notes[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      noteBloc.add(DeleteEvent(index));
                    },
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          noteBloc.add(AddEvent('New Note'));
        },
        child: Icon(Icons.add),
      ),
    );
  }

}

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final List<Note> notes = [
    Note(
      title: 'Заметка 1',
      content: 'Содержание заметки 1',
      lastEdited: DateTime.now(),
    ),
    // Добавьте больше заметок по необходимости
  ];

  void _deleteNote(Note note){
    setState(() {
      notes.remove(note);
    });
  }

  @override
  Widget build(BuildContext context) { //Этот аннотационный метод указывает, что метод build переопределяет метод из родительского класса StatelessWidget
    return Scaffold( //это контейнер для базовой структуры визуального интерфейса приложения. Он предоставляет такие элементы, как AppBar, Drawer, FloatingActionButton и другие.
      appBar: AppBar( //это верхняя панель приложения. В данном случае она содержит заголовок “Заметки”.
        title: Text('Заметки'),
      ),
      body: ListView.builder( //это виджет, который создает прокручиваемый список элементов. Он принимает два параметра:
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index]; //Этот код извлекает заметку из списка notes по текущему индексу index.
          return ListTile( // это виджет, который представляет одну строку в списке. Он содержит:
            title: Text(note.title), //заголовок заметки.
            subtitle: Text(note.content), //содержание заметки.
            //trailing: Text(note.lastEdited.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteNote(note);
                  },
                ),
              ],
            ),// дата последнего редактирования заметки.
            onTap: () { //функция, которая вызывается при нажатии на элемент списка.
              Navigator.pushNamed( //используется для перехода на новый экран.
                context, //текущий контекст.
                '/detail',
                arguments: note,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton( //это плавающая кнопка действия, которая отображается в правом нижнем углу экрана. Она содержит:
        onPressed: () async { //функция, которая вызывается при нажатии на кнопку. В данном случае она переходит на экран CreateNoteScreen
          final newNote = await Navigator.pushNamed(context, '/create');
          if (newNote != null && newNote is Note) {
            setState(() {
              notes.add(newNote);
            });
          }
        },
        child: Icon(Icons.add),//иконка, отображаемая на кнопке (в данном случае это иконка добавления).
      ),
    );
  }
}

class NoteDetailScreen extends StatefulWidget { //Этот класс представляет экран для отображения и редактирования выбранной заметки. Он наследуется от StatefulWidget, что означает, что его состояние может изменяться.
  final Note note; //Поле note хранит объект заметки, который будет отображаться и редактироваться на этом экране. Оно объявлено как final, что означает, что его значение не может быть изменено после инициализации.

  NoteDetailScreen({required this.note}); //Конструктор класса NoteDetailScreen, который принимает обязательный параметр note и инициализирует соответствующее поле.

  @override //Аннотация @override указывает, что метод переопределяет метод из родительского класса.
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
} //Метод createState создает и возвращает экземпляр состояния _NoteDetailScreenState, который будет управлять состоянием виджета.

class _NoteDetailScreenState extends State<NoteDetailScreen> { //Этот класс представляет состояние виджета NoteDetailScreen. Он наследуется от State<NoteDetailScreen>.
  late TextEditingController _titleController;
  late TextEditingController _contentController;
//Эти поля объявляют контроллеры для текстовых полей заголовка и содержания заметки. Контроллеры используются для управления текстом в текстовых полях.

  @override
  void initState() { //Метод initState вызывается при инициализации состояния виджета. В нем создаются экземпляры контроллеров и инициализируются значениями из переданной заметки.
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  } //Эти строки инициализируют контроллеры значениями заголовка и содержания заметки.

  @override
  void dispose() { //Метод dispose вызывается при удалении виджета. В нем освобождаются ресурсы, занятые контроллерами.
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  } //Эти строки освобождают ресурсы, занятые контроллерами.

  @override
  Widget build(BuildContext context) { //Метод build создает и возвращает виджет, который будет отображаться на экране. Он принимает параметр BuildContext, который предоставляет доступ к дереву виджетов.
    return Scaffold( //Scaffold - это контейнер для базовой структуры визуального интерфейса приложения. Он предоставляет такие элементы, как AppBar, Drawer, FloatingActionButton и другие.
      appBar: AppBar( //AppBar - это верхняя панель приложения. В данном случае она содержит заголовок “Редактирование заметки”.
        title: Text('Редактирование заметки'),
      ),
      body: Padding( //Padding - это виджет, который добавляет отступы вокруг своего дочернего виджета. В данном случае отступы равны 16 пикселям.
        padding: const EdgeInsets.all(16.0),
        child: Column( //Column - это виджет, который располагает свои дочерние виджеты вертикально.
          children: [
            TextField( //TextField - это виджет для ввода текста. В данном случае он используется для ввода заголовка и содержания заметки. Контроллеры _titleController и _contentController управляют текстом в этих полях.
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Содержание'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton( //ElevatedButton - это виджет кнопки с приподнятым стилем. В данном случае кнопка используется для сохранения изменений в заметке. При нажатии на кнопку вызывается функция, которая обновляет заголовок, содержание и дату последнего редактирования заметки, а затем возвращает пользователя на предыдущий экран.
              onPressed: () {
                setState(() { //Функция setState используется для обновления состояния виджета. В данном случае она обновляет заголовок, содержание и дату последнего редактирования заметки.
                  widget.note.title = _titleController.text;
                  widget.note.content = _contentController.text;
                  widget.note.lastEdited = DateTime.now();
                });
                Navigator.pop(context); //Функция Navigator.pop используется для возврата на предыдущий экран.
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новая заметка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Заголовок'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Содержание'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newNote = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  lastEdited: DateTime.now(),
                );
                Navigator.pop(context, newNote);
              },
              child: Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}