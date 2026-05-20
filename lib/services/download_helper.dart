import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart'
    as impl;

Future<void> downloadFile(List<int> bytes, String filename) async =>
    impl.downloadFile(bytes, filename);
