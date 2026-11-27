class RobotService {
  String ip = '192.168.51.23';
  String port = '8080';

  Future<String> sendCommand(String command) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return 'Test mode: would send';
  }
}
