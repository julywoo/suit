class Alarm {
  final String? sendUser;
  final String? recvUserList;
  final String? recvFactoryUserList;
  final String? sendDate;
  final String? readState;
  final String? sendMsg;

  Alarm(
      {this.sendUser,
      this.recvUserList,
      this.recvFactoryUserList,
      this.sendDate,
      this.readState,
      this.sendMsg});

  Alarm.fromJson(Map<String, dynamic> json)
      : sendUser = json['sendUser'],
        recvUserList = json['recvUserList'],
        recvFactoryUserList = json['recvFactoryUserList'],
        sendDate = json['sendDate'],
        readState = json['readState'],
        sendMsg = json['sendMsg'];

  Map<String, dynamic> toJson() => {
        'sendUser': sendUser,
        'recvUserList': recvUserList,
        'recvFactoryUserList': recvFactoryUserList,
        'sendDate': sendDate,
        'readState': readState,
        'sendMsg': sendMsg,
      };
}
