import 'package:firestore_sample/model/count.dart';
import 'package:firestore_sample/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountPage extends StatefulWidget {
  CountPage({Key? key}) : super(key: key);
  @override
  _CountePageState createState() => _CountePageState();
}

class _CountePageState extends State<CountPage> {
  int _counter = 0;
  CountRepository _countRepository = CountRepository();
  late StreamProvider _streamProvider;

  @override
  void initState() {
    _streamProvider = StreamProvider<List<Count>>((ref) => _countRepository
        .getSnapshot()
        .map((e) => e.docs.map((data) => _convert(data.data())).toList()));
  }

  Count _convert(Object? obj) {
    if (obj == null) {
      return Count(dateTime: DateTime.now(), count: -1);
    }
    var map = obj as Map<String, dynamic>;
    return Count.fromJson(map);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    Count countData = Count(
      dateTime: DateTime.now(),
      count: _counter,
    );
    _countRepository.saveCount(countData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirestoreSample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Consumer(builder: ((context, ref, child) {
              final provider = ref.watch(_streamProvider);
              return provider.when(
                  data: (data) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: ((context, index) {
                        Count count = data[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(count.dateTime.toString()),
                            trailing: Text(count.count.toString()),
                            tileColor: Colors.lightBlueAccent,
                          ),
                        );
                      }),
                    );
                  },
                  error: (e, st) => Text(e.toString()),
                  loading: () => const CircularProgressIndicator());
            }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
