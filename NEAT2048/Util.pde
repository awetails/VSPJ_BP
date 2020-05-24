void _wait(int seconds){
  int time = millis() + seconds*1000;
  while (time > millis()) {}
}
