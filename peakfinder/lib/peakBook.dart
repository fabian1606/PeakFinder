import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:peakfinder/ble.dart';
import 'network.dart';

class PeakPage extends StatefulWidget {
  final String data;
  PeakPage({required this.data});
  @override
  _PeakPageState createState() => _PeakPageState();
}

class _PeakPageState extends State<PeakPage> {
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gipfelbuch"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30.0),
                //set heigth to maximum space available
                // height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          child: BubbleNormal(
                            text: messages[index],
                            isSender: false,
                            color: Color.fromARGB(255, 254, 198, 30),
                            tail: true,
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40, // Set the desired height here
                      child: TextField(
                        controller: _textFieldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Gipfelentrag hinzufügen',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40, // Set the desired height here
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          addMessage(_textFieldController.text);
                        });
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
