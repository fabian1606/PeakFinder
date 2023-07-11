class Peaks {
  final List<Peak> peaks;

  Peaks({
    required this.peaks,
  });

  factory Peaks.fromJson(Map<String, dynamic> json) {
    final List<dynamic> peakList = json['peaks'];
    final List<Peak> peaks = peakList.map((json) => Peak.fromJson(json)).toList();
    return Peaks(peaks: peaks);
  }
}

class Peak {
  final String peakId;
  final String peakName;

  Peak({
    required this.peakId,
    required this.peakName,
  });

  factory Peak.fromJson(Map<String, dynamic> json) {
    return Peak(
      peakId: json['peakId'],
      peakName: json['peakName'],
    );
  }
}