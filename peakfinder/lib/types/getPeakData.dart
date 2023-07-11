class AllPeakData {
  final List<PeakData> peaks;

  AllPeakData({
    required this.peaks,
  });

  factory AllPeakData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> peakList = json['peak'];
    final List<PeakData> peaks = peakList.map((json) => PeakData.fromJson(json)).toList();
    return AllPeakData(peaks: peaks);
  }
}

class PeakData {
  final String avgVisitors;
  final String timestamp;

  PeakData({
    required this.avgVisitors,
    required this.timestamp,
  });

  factory PeakData.fromJson(Map<String, dynamic> json) {
    return PeakData(
      avgVisitors: json['avgVisitors'],
      timestamp: json['timestamp'],
    );
  }
}
