import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomrade/bloc/pomrade_bloc.dart';
import 'package:pomrade/models.dart';


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
        Text("Tags:", style: TextStyle(fontWeight: FontWeight.bold),)
      ] + tags.map(
        (tag) {
          return ElevatedButton(
            onPressed: () => onTagPressCallback(tag), 
            child: Text("#$tag"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black26,
              padding: EdgeInsets.symmetric(horizontal: 10)
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
  const TaskCard({super.key, required this.task, this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
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
                Text(task.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text("${task.description??"\n"}", maxLines: 2,),
                SizedBox(height: 5,),
                TagsBar(
                  onTagPressCallback: (tag) {
                    if (searchController!=null) {
                      if(!searchController!.text.contains("#$tag")) {
                        searchController!.text += " #$tag";
                      }
                    }
                  }, 
                  tags: task.tags
                ),
                SizedBox(height: 5,),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {}, 
                      child: Text("Start Task"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {}, 
                      child: Text("Mark as Complete"),
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

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = BlocProvider.of<PomradeBloc>(context).state.tasks;
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
                          constraints: BoxConstraints(maxHeight: 40),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)
                          ),
                          hintText: "Search your Tasks",
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              
                            },
                          )
                        ),
                        style: TextStyle(fontSize: 12),
                        
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top:5),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var e = tasks[index];
                    return TaskCard(
                      task: e,
                      searchController: search,
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
              onPressed: (){},
              child: Icon(Icons.add),
            ),
          )
        ),
      ],
    );
  }
}