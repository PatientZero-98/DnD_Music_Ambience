String getFileExtension(String filename) {
  return filename.split('.').last.toLowerCase();
}

String getFileName(String filepath) {
  return filepath.split('/').last;
}
