import 'package:book_story/pages/popups/record_tips_popup.dart';
import 'package:book_story/pages/screens/record_screen.dart';
import 'package:flutter/material.dart';

enum ProcessStatus{
  init,       // 생성됨
  recordDone, // 녹음완료
  uploading,  // 업로드중
  processing, // 훈련중
  done,       // 완료(성공)
}

class VoiceListItem extends StatefulWidget {
  String voiceName="";
  bool isRecorded = false;
  ProcessStatus status = ProcessStatus.init;

  VoiceListItem(this.voiceName, {super.key});

  @override
  VoiceListItemState createState() => VoiceListItemState();
}

class VoiceListItemState extends State<VoiceListItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      padding: const EdgeInsets.all(16.0),
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
            const SizedBox(),
            Text(
              widget.voiceName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),// 폰트 크기를 조절할 간격 설정
            ),
            Row(
              children: [
                // _buildCircularPercentIndecator(),
                const SizedBox(width: 30),
                _buildStatusButton(widget.status),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  child: const Text("Delete"),
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
              fontWeight: FontWeight.w600, // 텍스트 굵기 조절
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

  Widget _buildStatusButton(ProcessStatus status) {
    switch(status){
      case ProcessStatus.init:
        return ElevatedButton(
          onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return const RecordTipsPopup();
            }).then((_) => {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const RecordScreen(),
                ),
              ).then((isRecorded) {
                print('VALUE: $isRecorded');
              })
            });
          },
          child: const Text("Record")
        );
      case ProcessStatus.recordDone:
        return ElevatedButton(
          onPressed: (){
            // TODO : 업로드 시작
          },
          child: const Text("Upload")
        );
      default:
        return TextButton(onPressed: (){}, child: const Text("?Error?"));
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
                  widget.voiceName="";
                  widget.status = ProcessStatus.init;
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

  Widget _statusText(){
    switch(widget.status){
      case ProcessStatus.init:
        return Text("Record");
      case ProcessStatus.recordDone:
        return Text("Upload");
      case ProcessStatus.uploading:
        return Text("Uploading");
      default:
        return Text("?");
    }

  }
}