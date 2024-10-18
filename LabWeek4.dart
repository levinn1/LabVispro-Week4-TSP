import 'dart:io';
import 'dart:math';

// Elemen untuk daftar terhubung
class PointNode {
  String name;
  PointNode? nextPoint;

  PointNode(this.name);
}

// Struktur daftar terhubung untuk menyimpan daftar menghubungkan poin
class PointList {
  PointNode? firstPoint;

  // Menambah menghubungkan poin baru di akhir daftar
  void addPoint(String name) {
    if (firstPoint == null) {
      firstPoint = PointNode(name);
    } else {
      PointNode current = firstPoint!;
      while (current.nextPoint != null) {
        current = current.nextPoint!;
      }
      current.nextPoint = PointNode(name);
    }
  }

  // Menampilkan daftar menghubungkan poin
  void showPoints() {
    PointNode? current = firstPoint;
    while (current != null) {
      print(current.name);
      current = current.nextPoint;
    }
  }
}

// Kelas untuk representasi graf dan menyelesaikan TSP
class DistanceGraph {
  List<List<int>> distanceMatrix;
  List<String> pointNames;

  DistanceGraph(this.distanceMatrix, this.pointNames);

  // Mendapatkan jarak antara dua menghubungkan poin
  int findDistance(String start, String destination) {
    int startIdx = pointNames.indexOf(start);
    int destIdx = pointNames.indexOf(destination);

    if (startIdx == -1 || destIdx == -1) {
      print('poin tidak ditemukan.');
      return -1;
    }

    return distanceMatrix[startIdx][destIdx];
  }

  // Algoritma rekursif TSP
  int solveTSP(List<int> route, int position, int visited, int count, int totalDistance, int shortestDistance) {
    if (count == distanceMatrix.length && distanceMatrix[position][0] > 0) {
      return min(shortestDistance, totalDistance + distanceMatrix[position][0]);
    }

    for (int i = 0; i < distanceMatrix.length; i++) {
      if ((visited & (1 << i)) == 0 && distanceMatrix[position][i] > 0) {
        visited |= (1 << i);
        route.add(i);
        shortestDistance = solveTSP(route, i, visited, count + 1, totalDistance + distanceMatrix[position][i], shortestDistance);
        visited &= ~(1 << i);
        route.removeLast();
      }
    }
    return shortestDistance;
  }

  // Memulai proses penyelesaian TSP
  void findOptimalRoute() {
    List<int> route = [0];
    int visited = 1;
    int shortestDistance = solveTSP(route, 0, visited, 1, 0, 100000000);
    print("Jarak minimum TSP: $shortestDistance");
  }
}

void main() {
  // Membuat daftarpoin menggunakan PointList
  PointList pointCollection = PointList();
  pointCollection.addPoint('A');
  pointCollection.addPoint('B');
  pointCollection.addPoint('C');
  pointCollection.addPoint('D');
  pointCollection.addPoint('E');

  // Matriks jarak antara poin
  List<List<int>> distances = [
    [0, 8, 3, 4, 10],  // A
    [8, 0, 5, 2, 7],   // B
    [3, 5, 0, 1, 6],   // C
    [4, 2, 1, 0, 3],   // D
    [10, 7, 6, 3, 0]   // E
  ];

  // Nama menghubungkan poin
  List<String> points = ['A', 'B', 'C', 'D', 'E'];

  // Membuat graf berdasarkan matriks jarak dan nama menghubungkan poin
  DistanceGraph pointGraph = DistanceGraph(distances, points);

  // Menerima input pengguna untuk mencari jarak antara dua menghubungkan poin
  while (true) {
    print('\nA, B, C, D, E');
    print('\nMasukkan 2 poin dari atas yang mau disambung (cth: A B), ketik exit untuk keluar:');
    String? userInput = stdin.readLineSync();

    if (userInput == null || userInput.toLowerCase() == 'exit') {
      print('Terima Kasih');
      break;
    }

    List<String> selectedPoints = userInput.split(' ');
    if (selectedPoints.length == 2) {
      String startPoint = selectedPoints[0];
      String endPoint = selectedPoints[1];

      int distance = pointGraph.findDistance(startPoint, endPoint);
      if (distance != -1) {
        print('Jarak dari $startPoint ke $endPoint adalah $distance.');
      }
    } else {
      print('Error, input ulang');
    }
  }
}
