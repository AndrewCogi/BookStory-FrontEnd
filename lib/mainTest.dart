import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceListScreen(),
    );
  }
}

class VoiceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice List"),
      ),
      body: ListView(
        children: [
          VoiceListItem(""),
          VoiceListItem(""),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}

class VoiceListItem extends StatefulWidget {
  String voiceName;
  int recordingCount = 0;
  bool isUploading = false;

  VoiceListItem(this.voiceName);

  @override
  _VoiceListItemState createState() => _VoiceListItemState();
}

class _VoiceListItemState extends State<VoiceListItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.voiceName.isNotEmpty) {
      // Voice Name이 비어있지 않으면 Record 버튼과 Delete 버튼을 포함한 박스를 반환
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Text(
            widget.voiceName,
            style: TextStyle(
              fontSize: 18.0, // 텍스트 크기 조절
              fontWeight: FontWeight.bold, // 텍스트 굵기 조절
            ),// 폰트 크기를 조절할 간격 설정
          ),
          Row(
            children: [
              _buildCircularPercentIndecator(),
              SizedBox(width: 10),
              _buildRecordUploadButton(),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(context);
                },
                child: Text("Delete"),
              ),
            ],
          ),
        ]
      );
    } else {
      // Voice Name이 비어있으면 "Empty Slot" 상태의 박스를 반환
      return Column(
        children: [
          Text(
            "Empty Slot",
            style: TextStyle(
              fontSize: 15.0, // 텍스트 크기 조절
              fontWeight: FontWeight.w400, // 텍스트 굵기 조절
            ),
          ),
          SizedBox(height: 6.0),
          ElevatedButton(
            onPressed: () {
              _showAddVoiceDialog(context);
            },
            child: Text("Add Your Voice"),
          ),
        ],
      );
    }
  }

  Widget _buildCircularPercentIndecator(){
    if(widget.recordingCount/10 != 1){
      return new CircularPercentIndicator(
        radius: 36.0,
        lineWidth: 5.0,
        percent: widget.recordingCount/10,
        center: Text('${((widget.recordingCount / 10)*100).toStringAsFixed(1)}%'),
        progressColor: Colors.green,
      );
    }
    else{
      return SizedBox();
    }
  }

  Widget _buildRecordUploadButton() {
    if (widget.recordingCount < 10) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            widget.recordingCount += 1;
          });
        },
        child: Text("Record"),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            widget.isUploading = true;
          });
        },
        child: widget.isUploading ? Text("Uploading") : Text("Upload"),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isUploading ? Colors.grey : null,
        ),
      );
    }
  }

  void _showAddVoiceDialog(BuildContext context) {
    String newVoiceName = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Your Voice"),
          content: TextField(
            onChanged: (text) {
              newVoiceName = text;
            },
            decoration: InputDecoration(labelText: "Voice Name"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (newVoiceName.isNotEmpty) {
                  setState(() {
                    widget.voiceName = newVoiceName;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("Confirm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Voice"),
          content: Text("Are you sure you want to delete this voice?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.voiceName = "";
                });
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}

class RecordingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recording"),
      ),
      body: Center(
        child: Text("This is the recording screen."),
      ),
    );
  }
}
