class TimeParser {

  static String formatter(int value) {
    /* 숫자를 두 자리 포맷에 맞추어 String 타입으로 반환한다.
     * e.g.) 1 -> '01', 13 -> '13'
     *
     * last modified: 2022-07-13
     */
    if(value < 10) return '0$value';
    else return '$value';
  }

  static String fromSeconds(int seconds) {
    /* 초를 받아와 HH:MM:SS 포맷에 맞추어 String 타입으로 반환한다.
     * e.g.) 3941 -> 01:05:41
     *
     * last modified: 2022-07-13
     */
    int hour = (seconds / 3600).floor();
    int minute = ((seconds - hour * 3600) / 60).floor();
    int second = seconds - hour * 3600 - minute * 60;

    return '${formatter(hour)}:${formatter(minute)}:${formatter(second)}';
  }
}