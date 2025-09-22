// lib/helpers/quotes_helper.dart

import 'dart:math';

// Anda bisa menambahkan ratusan quote di dalam list ini
final List<Map<String, String>> localQuotes = [
  {
    'content':
        'Cara terbaik untuk memulai adalah dengan berhenti berbicara dan mulai melakukan.',
    'author': 'Walt Disney',
  },
  {
    'content':
        'Waktu Anda terbatas, jangan sia-siakan dengan menjalani hidup orang lain.',
    'author': 'Steve Jobs',
  },
  {
    'content':
        'Jika hidup dapat diprediksi, itu akan berhenti menjadi hidup, dan tanpa rasa.',
    'author': 'Eleanor Roosevelt',
  },
  {
    'content':
        'Jika Anda melihat lebih dekat, sebagian besar kesuksesan dalam semalam memakan waktu lama.',
    'author': 'Steve Jobs',
  },
  {
    'content':
        'Sukses bukanlah final, kegagalan bukanlah fatal: yang terpenting adalah keberanian untuk melanjutkan.',
    'author': 'Winston Churchill',
  },
  {
    'content':
        'Satu-satunya hal yang mustahil adalah hal yang tidak Anda coba.',
    'author': 'Sara Blakely',
  },
  {
    'content': 'Percayalah Anda bisa dan Anda sudah setengah jalan.',
    'author': 'Theodore Roosevelt',
  },
  {
    'content':
        'Bertindaklah seolah-olah apa yang Anda lakukan membuat perbedaan. Memang benar.',
    'author': 'William James',
  },
  {
    'content':
        'Saya tidak pernah memimpikan kesuksesan. Saya bekerja untuk itu.',
    'author': 'Estée Lauder',
  },
  {
    'content':
        'Sukses biasanya datang kepada mereka yang terlalu sibuk untuk mencarinya.',
    'author': 'Henry David Thoreau',
  },
  {
    'content':
        'Untuk menjadi sukses, keinginan Anda untuk sukses harus lebih besar dari ketakutan Anda akan kegagalan.',
    'author': 'Bill Cosby',
  },
  {
    'content':
        'Jangan takut menyerah pada yang baik untuk mengejar yang hebat.',
    'author': 'John D. Rockefeller',
  },
  {
    'content':
        'Semua impian kita bisa menjadi kenyataan, jika kita punya keberanian untuk mengejarnya.',
    'author': 'Walt Disney',
  },
  {
    'content': 'Hal-hal hebat tidak pernah datang dari zona nyaman.',
    'author': 'Anonim',
  },
  {
    'content':
        'Satu-satunya tempat di mana kesuksesan datang sebelum kerja adalah di kamus.',
    'author': 'Vidal Sassoon',
  },
  {
    'content': 'Jangan menunggu. Waktunya tidak akan pernah tepat.',
    'author': 'Napoleon Hill',
  },
];

// Fungsi untuk mendapatkan satu quote acak dari list di atas
Map<String, String> getRandomQuote() {
  final random = Random();
  return localQuotes[random.nextInt(localQuotes.length)];
}
