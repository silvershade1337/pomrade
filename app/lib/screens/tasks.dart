import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';
import 'package:pomrade/screens/viewnotes.dart';


class TagsBar extends StatelessWidget {
  final List<String> tags;
  final void Function(String tag) onTagPressCallback; 
  const TagsBar({super.key, required this.onTagPressCallback, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: <Widget> [
        const Text("Tags:", style: TextStyle(fontWeight: FontWeight.bold),)
      ] + tags.map(
        (tag) {
          return ElevatedButton(
            onPressed: () => onTagPressCallback(tag), 
            child: Text("#$tag"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black26,
              padding: const EdgeInsets.symmetric(horizontal: 10)
            ),
          );
        }
      ).toList(),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final TextEditingController? searchController;
  final void Function(Task task) onTaskCompleteCallback;
  final void Function(Task task) onTaskStartCallback;
  final void Function(Task task) onViewNotesCallback;
  final void Function(String tag) onTagClickCallback;
  const TaskCard({super.key, required this.task, this.searchController, required this.onTaskCompleteCallback, required this.onTaskStartCallback, required this.onViewNotesCallback, required this.onTagClickCallback});

  @override
  Widget build(BuildContext context) {
    PomradeBloc bloc = BlocProvider.of<PomradeBloc>(context);
    return Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.deepPurple[200]!.withAlpha(20),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                const SizedBox(height: 5,),
                if(task.description != null) Text("${task.description??""}", maxLines: 2,),
                const SizedBox(height: 5,),
                if(task.tags.isNotEmpty) TagsBar(
                  onTagPressCallback: (tag) {
                    onTagClickCallback(tag);
                  }, 
                  tags: task.tags
                ),
                const SizedBox(height: 5,),
                const Divider(),
                task.completed? Row(
                  children: [
                     Text("Completed"),
                     SizedBox(width: 10,),
                     if(task.notes != null) ElevatedButton(
                      onPressed: () {
                        onViewNotesCallback(task);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[300],
                        foregroundColor: Colors.black,
                      ),
                      child: Text("View Notes"),
                    )
                  ],
                )
                : 
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onTaskStartCallback(task);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task ==bloc.state.startedTask ? Colors.green[200]!.withAlpha(100): Colors.deepPurple[300],
                        foregroundColor: Colors.black,
                      ),
                      child: Text(task ==bloc.state.startedTask ? "Current task" :"Start Task"),
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        onTaskCompleteCallback(task);
                      },
                      child: const Text("Mark as Complete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white12,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool showCompleted = false;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Task> alltasks = BlocProvider.of<PomradeBloc>(context).state.tasks;
    List<String> searchTags = search.text.split(" ");
    searchTags.removeWhere((element) => !element.startsWith("#"));
    List<Task> showTasks = List<Task>.from(alltasks);
    if (searchTags.isNotEmpty) {
      showTasks.removeWhere((element) {
          for (var tag in searchTags) {
            if (element.tags.contains( tag.substring(1) ) ) {
              return false;
            }
          }
          return true;
        },
      );
    }
    if(!showCompleted) {
      showTasks.removeWhere((element) {
        return element.completed == true;
      },);
    }
    showTasks =  showTasks.reversed.toList();
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      "Your Tasks   ",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: TextField(
                        controller: search,
                        decoration: InputDecoration(
                          constraints: const BoxConstraints(maxHeight: 40),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          hintText: "Search your Tasks",
                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              
                            },
                          )
                        ),
                        style: const TextStyle(fontSize: 12),
                        onChanged: (value) {
                          setState(() {
                            
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.black12,
                child: Row(
                  children: [
                    Checkbox(value: showCompleted, onChanged: (value) {
                      setState(() {
                        showCompleted = value!;
                      });
                      
                    }, tristate: false,),
                    Text("Show Completed Tasks")
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top:5),
                  itemCount: showTasks.length,
                  itemBuilder: (context, index) {
                    var e = showTasks[index];
                    return TaskCard(
                      task: e,
                      searchController: search,
                      onTaskCompleteCallback: (task) {
                        setState(() {
                          for (var taskk in alltasks) {
                            if(taskk.id == task.id) {
                              taskk.completed = true;
                              if (BlocProvider.of<PomradeBloc>(context).state.startedTask == taskk) {
                                BlocProvider.of<PomradeBloc>(context).state.startedTask = null;
                              }
                              BlocProvider.of<PomradeBloc>(context).add(TasksChangedEvent(alltasks));
                            }
                          }
                        });
                      },
                      onTaskStartCallback: (task) {
                        setState(() {
                          
                          if (task == BlocProvider.of<PomradeBloc>(context).state.startedTask) {
                            BlocProvider.of<PomradeBloc>(context).state.startedTask = null;
                          }
                          else {
                            BlocProvider.of<PomradeBloc>(context).state.startedTask = task;
                          }
                        });
                      },
                      onViewNotesCallback: (task) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNotesPage(task: task),));
                      },
                      onTagClickCallback: (tag) {
                        if(!search.text.contains("#$tag")) {
                          setState(() {
                            search.text += " #$tag";
                          });
                            
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: FloatingActionButton(
              onPressed: () async {
                Task? returned = await Navigator.push<Task>(context, MaterialPageRoute(builder: (context) => const CreateTaskPage(),));
                print(returned);
                print("done");
                if (returned!=null){
                  setState(() {
                    alltasks.add(returned);
                    BlocProvider.of<PomradeBloc>(context).add(TasksChangedEvent(alltasks));
                  });
                }
              },
              child: const Icon(Icons.add),
            ),
          )
        ),
      ],
    );
  }
}

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController tags = TextEditingController();
  TextEditingController notes = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create new task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  label: Text("Task Name"),
                  border: OutlineInputBorder()
                ),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                maxLines: 1,
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                  label: Text("Task Description (Optional)"),
                  border: OutlineInputBorder()
                ),
                maxLines: 2,
              ),
              TextField(
                controller: tags,
                decoration: InputDecoration(
                  label: Text("Tags"),
                  hintText: "Enter upto 5 tags separated by a space",
                  border: OutlineInputBorder()
                ),
              ),
              TextField(
                controller: notes,
                decoration: InputDecoration(
                  label: Text("Pre-Task Notes"),
                  hintText: "You can enter any notes which you can access in the Notes page when you start the task",
                  border: OutlineInputBorder()
                  
                ),
                minLines: 3,
                maxLines: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context, 
                    Task(
                      id: BlocProvider.of<PomradeBloc>(context).state.tasks.length, 
                      name: name.text, 
                      description: description.text.isNotEmpty?description.text:null,
                      notes: notes.text.isNotEmpty?notes.text:null,
                      tags: tags.text.isEmpty?null:tags.text.split(" "),
                      created: DateTime.now()
                    )
                  );
                }, 
                child: const Text("Create Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ].map((e) => Padding(padding: EdgeInsets.all(10), child: e,)).toList(),
          ),
        ),
      ),
    );
  }
}