/// AgriVision NTB - Disease Model
/// Model untuk penyakit tanaman - 80 penyakit umum di Indonesia/NTB

class Disease {
  final String id;
  final String name;
  final String nameIndonesia;
  final String description;
  final String symptoms;
  final String causes;
  final List<String> affectedPlants;
  final String iconPath;
  final String imagePath;

  Disease({
    required this.id,
    required this.name,
    required this.nameIndonesia,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.affectedPlants,
    this.iconPath = '',
    this.imagePath = '',
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameIndonesia: json['name_id'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      symptoms: json['symptoms'] ?? '',
      causes: json['causes'] ?? '',
      affectedPlants: List<String>.from(json['affected_plants'] ?? []),
      iconPath: json['icon_path'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_id': nameIndonesia,
      'description': description,
      'symptoms': symptoms,
      'causes': causes,
      'affected_plants': affectedPlants,
      'icon_path': iconPath,
      'image_path': imagePath,
    };
  }

  // ============================================
  // 80 PENYAKIT TANAMAN UMUM DI INDONESIA/NTB
  // ============================================
  static List<Disease> commonDiseases = [
    // ========== PENYAKIT PADI (1-12) ==========
    Disease(
      id: 'rice_blast',
      name: 'Rice Blast',
      nameIndonesia: 'Blas Padi',
      description:
          'Blas adalah penyakit jamur ganas yang disebabkan oleh Pyricularia oryzae. Penyakit ini menyerang semua fase pertumbuhan padi, dari pembibitan hingga panen. Pada fase vegetatif, gejala berupa bercak belah ketupat pada daun (Leaf Blast) yang dapat mematikan tanaman. Pada fase generatif, jamur menyerang leher malai (Neck Blast) menyebabkan leher busuk dan patah, sehingga pengisian bulir terhenti dan gabah menjadi hampa (puso). Penyakit ini sangat merugikan di daerah dengan kelembaban tinggi dan penggunaan pupuk Nitrogen berlebihan.',
      symptoms:
          'Bercak berbentuk belah ketupat, tepi coklat, pusat abu-abu, leher malai patah',
      causes: 'Jamur Pyricularia oryzae',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_brown_spot',
      name: 'Brown Spot',
      nameIndonesia: 'Bercak Coklat Padi',
      description:
          'Penyakit bercak coklat disebabkan oleh jamur Bipolaris oryzae (Helminthosporium). Penyakit ini sering menjadi indikator kesehatan tanah yang buruk, terutama kekurangan unsur hara Kalium (K), Silika (Si), atau tanah yang masam. Gejala khas berupa bercak oval berwarna coklat dengan titik pusat abu-abu atau putih di daun (seperti biji wijen). Serangan berat dapat menyebabkan daun mengering dan kualitas gabah menurun drastis karena kulit gabah menjadi kotor dan berbintik hitam.',
      symptoms:
          'Bercak oval coklat dengan pusat abu-abu, hawar bibit, gabah hampa',
      causes: 'Jamur Bipolaris oryzae',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_bacterial_leaf_blight',
      name: 'Bacterial Leaf Blight',
      nameIndonesia: 'Hawar Daun Bakteri Padi',
      description:
          'Hawar Daun Bakteri (HDB) atau dikenal petani sebagai "Kresek" disebabkan oleh bakteri Xanthomonas oryzae. Penyakit ini sangat destruktif pada musim hujan dengan angin kencang yang membantu penyebarannya. Gejala awal berupa garis basah di tepi daun yang kemudian melebar, menguning, dan akhirnya mengering berwarna putih jerami. Serangan pada fase pembibitan dapat menyebabkan tanaman layu dan mati total (kresek). Penggunaan urea berlebih memperparah penyakit ini.',
      symptoms: 'Daun menguning dari tepi, layu, eksudat bakteri kuning',
      causes: 'Bakteri Xanthomonas oryzae pv. oryzae',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_sheath_blight',
      name: 'Sheath Blight',
      nameIndonesia: 'Hawar Pelepah Padi',
      description:
          'Hawar pelepah disebabkan oleh jamur tanah Rhizoctonia solani. Penyakit ini menyerang pelepah daun, menyebabkan bercak oval besar berwarna hijau keabu-abuan dengan tepi coklat tidak beraturan. Jika tidak dikendalikan, bercak akan meluas hingga ke daun bendera, menyebabkan tanaman mudah rebah dan pengisian bulir tidak optimal. Penyakit ini menyebar cepat pada pertanaman padi yang sangat rapat dengan kelembaban tinggi di bagian bawah kanopi.',
      symptoms:
          'Bercak lonjong hijau keabu-abuan pada pelepah, sklerotia coklat',
      causes: 'Jamur Rhizoctonia solani',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_tungro',
      name: 'Rice Tungro',
      nameIndonesia: 'Tungro Padi',
      description:
          'Tungro adalah penyakit virus kompleks (RTBV & RTSV) yang ditularkan oleh hama Wereng Hijau (Nephotettix virescens). Gejala utama adalah perubahan warna daun menjadi kuning-oranye mulai dari ujung daun muda, tanaman tumbuh kerdil, dan jumlah anakan berkurang drastis. Serangan dini dapat menyebabkan tanaman tidak mengeluarkan malai sama sekali. Pengendalian vektor wereng hijau sangat krusial untuk mencegah penyebaran virus ini.',
      symptoms: 'Daun menguning/oranye, tanaman kerdil, anakan sedikit',
      causes:
          'Rice Tungro Bacilliform Virus (RTBV) dan Rice Tungro Spherical Virus (RTSV)',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_grassy_stunt',
      name: 'Grassy Stunt',
      nameIndonesia: 'Kerdil Rumput Padi',
      description:
          'Penyakit Kerdil Rumput disebabkan oleh Rice Grassy Stunt Virus (RGSV) yang ditularkan secara persisten oleh vektor Wereng Batang Coklat (Nilaparvata lugens). Penyakit ini tersebar luas di Asia Selatan dan Tenggara termasuk Indonesia. Gejala sangat khas: tanaman padi mengalami kekerdilan parah dan memiliki penampilan menyerupai rumput karena pembentukan anakan yang sangat berlebihan namun berukuran kecil. Pertumbuhan tanaman menjadi sangat tegak (erect), dengan daun pendek, sempit, dan kaku. Warna daun hijau pucat atau kuning, seringkali menunjukkan bercak atau noda berwarna cokelat tua atau karat (rusty spots). Jika infeksi terjadi pada fase pembibitan, tanaman jarang mencapai kematangan dan hampir tidak pernah menghasilkan malai. Tanaman yang terinfeksi pada fase lebih lanjut mungkin bermalai tetapi umumnya gabah hampa. Pengendalian fokus pada manajemen vektor wereng coklat: varietas tahan wereng, tidak menanam secara terus-menerus, insektisida sistemik, dan membakar sisa tanaman terinfeksi.',
      symptoms:
          'Tanaman sangat kerdil seperti rumput, anakan berlebihan tapi kecil, daun pendek sempit tegak, bercak karat',
      causes: 'Rice Grassy Stunt Virus (RGSV), vektor: Nilaparvata lugens',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_ragged_stunt',
      name: 'Ragged Stunt',
      nameIndonesia: 'Kerdil Compeng Padi',
      description:
          'Penyakit Kerdil Compeng disebabkan oleh Rice Ragged Stunt Virus (RRSV), pertama kali dilaporkan di Indonesia pada tahun 1976. Sama seperti Kerdil Rumput, virus ini juga ditularkan secara persisten oleh Wereng Batang Coklat (Nilaparvata lugens). Gejala utama adalah pertumbuhan tanaman terhambat (kerdil) dan daun berwarna hijau gelap dengan ujung terpilin atau melengkung. Ciri diagnostik yang sangat khas adalah tepi daun yang tidak rata, robek-robek, dan bergerigi (ragged = compeng). Selain itu, terjadi pembengkakan pada tulang daun yang membentuk puru atau gall berwarna putih kecoklatan. Pada fase berbunga, malai mungkin tidak keluar sama sekali (bunting) atau hanya keluar sebagian dari pelepah daun bendera, dan gabah yang terbentuk akan hampa. Tanaman yang terserang menghasilkan anakan yang tampak tegak dan lebih pendek dari normal. Pengendalian sama dengan Kerdil Rumput yaitu fokus pada manajemen vektor wereng batang coklat dengan pendekatan PHT (Pengendalian Hama Terpadu).',
      symptoms:
          'Daun bergerigi compeng tidak teratur, tulang daun bengkak (gall), tanaman kerdil hijau gelap, malai tidak keluar',
      causes: 'Rice Ragged Stunt Virus (RRSV), vektor: Nilaparvata lugens',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_stem_rot',
      name: 'Stem Rot',
      nameIndonesia: 'Busuk Batang Padi',
      description:
          'Busuk Batang Padi disebabkan oleh jamur tanah Sclerotium oryzae (fase seksual: Magnaporthe salvinii). Penyakit ini sering terjadi pada tanaman padi yang sudah tua (fase generatif) di lahan yang tergenang dan kaya bahan organik. Gejala awal berupa bercak nekrotik hitam berbentuk tidak teratur pada pelepah daun terluar di dekat permukaan air. Bercak ini meluas ke pelepah bagian dalam dan pangkal batang, menyebabkan jaringan batang bagian dalam membusuk dan hancur. Ciri diagnostik adalah ditemukannya sklerotia (struktur istirahat jamur) berbentuk bulat kecil berwarna coklat tua hingga hitam di dalam rongga batang atau di permukaan pelepah. Batang yang terserang menjadi lemah, kosong di bagian dalam, dan sangat mudah rebah (lodging) terutama jika terkena angin atau hujan lebat. Akibatnya, pengisian gabah tidak optimal, gabah banyak yang hampa atau ringan, dan kualitas beras menurun (beras kapur). Pengendalian meliputi pengelolaan air (drainase berkala), tidak membenamkan jerami berlebihan, penggunaan kalium (K) yang cukup, dan varietas dengan batang kokoh.',
      symptoms:
          'Bercak hitam pada pelepah dan pangkal batang, sklerotia hitam bulat kecil, batang kosong mudah rebah',
      causes: 'Jamur Sclerotium oryzae (syn. Magnaporthe salvinii)',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_leaf_scald',
      name: 'Leaf Scald',
      nameIndonesia: 'Lepuh Daun Padi',
      description:
          'Lepuh Daun atau Leaf Scald disebabkan oleh jamur Rhynchosporium oryzae (syn. Gerlachia oryzae). Penyakit ini lebih umum terjadi di daerah beriklim sejuk atau dataran tinggi dengan kelembaban tinggi. Gejala awal berupa bercak kecil berbentuk lonjong hingga memanjang berwarna coklat muda keabu-abuan dengan tepi coklat tua yang bergelombang tidak teratur pada ujung daun. Bercak kemudian meluas ke arah pangkal daun, menyebabkan ujung daun tampak seperti terbakar atau tersiram air panas (scalded). Lesi yang sudah tua biasanya memiliki pola zonasi dengan warna yang bergradasi dari pusat yang pucat ke tepi yang lebih gelap. Pada serangan berat, sebagian besar area daun menjadi nekrotik dan daun mengering prematur, mengurangi kemampuan fotosintesis tanaman. Penyakit ini juga dapat menyerang pelepah daun. Pengendalian meliputi penggunaan varietas toleran, tidak menggunakan pupuk nitrogen berlebihan, memperbaiki sirkulasi udara dengan jarak tanam yang tepat, dan aplikasi fungisida berbahan aktif propikonazol atau azoksistrobin jika diperlukan.',
      symptoms:
          'Bercak coklat muda memanjang dengan tepi bergelombang, ujung daun seperti terbakar/lepuh, pola zonasi',
      causes: 'Jamur Rhynchosporium oryzae (syn. Gerlachia oryzae)',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_false_smut',
      name: 'False Smut',
      nameIndonesia: 'Gosong Palsu Padi',
      description:
          'Gosong palsu (Ustilaginoidea virens) menyerang bulir padi individu saat fase berbunga. Bulir yang terserang berubah menjadi bola spora besar, padat, dan beludru. Awalnya berwarna kuning, kemudian berubah menjadi hijau tua atau hitam. Penyakit ini menurunkan kualitas beras secara signifikan karena spora ijo akan mengotori beras sehat saat penggilingan, dan juga mengandung racun alkaloid.',
      symptoms: 'Bola spora hijau kekuningan pada gabah, gabah membesar',
      causes: 'Jamur Ustilaginoidea virens',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_narrow_brown_spot',
      name: 'Narrow Brown Spot',
      nameIndonesia: 'Bercak Coklat Sempit Padi',
      description:
          'Bercak Coklat Sempit disebabkan oleh jamur Cercospora janseana (syn. Sphaerulina oryzina). Penyakit ini tersebar luas di daerah tropis dan subtropis beriklim lembab. Gejala berupa bercak nekrotik berbentuk garis sempit memanjang (linear) berwarna coklat kemerahan hingga coklat tua yang terletak sejajar dengan tulang daun. Panjang bercak bisa mencapai beberapa sentimeter namun lebarnya hanya 1-2 mm. Bercak biasanya memiliki tepi yang jelas dan tidak melebar seperti pada penyakit bercak coklat biasa (Bipolaris). Pada serangan berat, bercak-bercak menyatu menyebabkan nekrosis area daun yang luas dan daun mengering prematur. Penyakit ini umumnya dianggap sebagai penyakit minor, namun pada kondisi yang sangat mendukung (kelembaban tinggi, tanaman lemah) bisa menyebabkan penurunan hasil signifikan. Faktor predisposisi meliputi kekurangan kalium, tanah asam, dan stres kekeringan. Pengendalian meliputi pemupukan berimbang terutama kalium, penggunaan varietas toleran, dan rotasi tanaman.',
      symptoms:
          'Bercak coklat sempit linear memanjang sejajar tulang daun, tepi jelas, daun mengering jika parah',
      causes: 'Jamur Cercospora janseana (syn. Sphaerulina oryzina)',
      affectedPlants: ['Padi'],
    ),
    Disease(
      id: 'rice_bakanae',
      name: 'Bakanae Disease',
      nameIndonesia: 'Penyakit Bakanae',
      description:
          'Penyakit Bakanae ("Benih Bodoh") disebabkan oleh Fusarium fujikuroi yang memproduksi hormon giberelin berlebih. Gejala paling khas adalah tanaman tumbuh abnormal tinggi, kurus, dan pucat kekuningan (etiolasi) dibanding tanaman sehat. Tanaman mungkin memiliki akar udara pada buku-buku batang dan biasanya mati sebelum menghasilkan malai. Sumber infeksi utama berasal dari benih yang terkontaminasi.',
      symptoms:
          'Tanaman sangat tinggi dan kurus, pucat, akar adventif pada batang',
      causes: 'Jamur Fusarium fujikuroi',
      affectedPlants: ['Padi'],
    ),

    // ========== PENYAKIT JAGUNG (13-24) ==========
    Disease(
      id: 'corn_downy_mildew',
      name: 'Downy Mildew',
      nameIndonesia: 'Bulai Jagung',
      description:
          'Bulai adalah momok utama bagi petani jagung di Indonesia, disebabkan oleh jamur Peronosclerospora maydis. Infeksi sistemik terjadi pada tanaman muda (2-3 minggu). Gejala khas berupa klorosis memanjang bergaris-garis putih kekuningan sejajar tulang daun. Di pagi hari yang lembab, terlihat lapisan spora putih seperti tepung di bawah daun. Tanaman yang terserang akan kerdil dan hampir pasti tidak menghasilkan tongkol sama sekali (puso).',
      symptoms:
          'Garis-garis klorotik, spora putih di bawah daun, tanaman kerdil',
      causes: 'Jamur Peronosclerospora maydis',
      affectedPlants: ['Jagung', 'Sorgum'],
    ),
    Disease(
      id: 'corn_leaf_blight',
      name: 'Northern Corn Leaf Blight',
      nameIndonesia: 'Hawar Daun Jagung',
      description:
          'Hawar daun disebabkan oleh Exserohilum turcicum. Penyakit ini menyerang daun tua terlebih dahulu, kemudian menyebar ke atas. Gejala awal berupa bercak kecil yang kemudian membesar membentuk lesi elips panjang (seperti cerutu atau perahu) berwarna abu-abu kehijauan yang akhirnya menjadi coklat kering. Serangan berat mengurangi area fotosintesis secara drastis, menyebabkan biji jagung tidak terisi penuh dan tongkol menjadi kecil.',
      symptoms: 'Bercak elips abu-abu kehijauan, memanjang 5-15 cm',
      causes: 'Jamur Exserohilum turcicum',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_rust',
      name: 'Common Rust',
      nameIndonesia: 'Karat Jagung',
      description:
          'Karat jagung (Puccinia sorghi) biasanya muncul di dataran tinggi atau musim kemarau yang sejuk. Gejalanya berupa bintil-bintil (pustula) kecil berwarna coklat kemerahan di kedua permukaan daun. Jika disentuh, spora seperti serbuk karat akan menempel di jari. Meskipun jarang mematikan, serangan berat dapat menyebabkan daun mengering lebih cepat (senesensi dini) dan menurunkan bobot biji jagung.',
      symptoms: 'Pustula coklat kemerahan tersebar pada daun, daun mengering',
      causes: 'Jamur Puccinia sorghi',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_southern_rust',
      name: 'Southern Rust',
      nameIndonesia: 'Karat Selatan Jagung',
      description:
          'Karat Selatan (Puccinia polysora) adalah penyakit karat yang lebih agresif dan merusak dibandingkan karat biasa (P. sorghi). Di Indonesia, penyakit ini dapat menyebabkan kerugian hasil yang sangat besar jika menyerang pada fase sebelum pembentukan biji. Gejala khas berupa pustula (bintil kecil) berwarna oranye keemasan hingga coklat muda yang tersebar sangat rapat dan padat, terutama di permukaan atas daun (berbeda dengan karat biasa yang pustulanya tersebar di kedua permukaan). Pustula berukuran lebih kecil dan lebih padat dibanding karat biasa. Daun yang terserang berat akan mengering dan mati prematur, mengurangi area fotosintesis secara drastis. Penyakit berkembang cepat pada suhu hangat (25-30°C) dengan kelembaban tinggi. Spora menyebar jarak jauh melalui angin. Pengendalian meliputi penggunaan varietas tahan (seperti XCI 47, Arjuna, Wiyasa), pengaturan waktu tanam (awal musim kemarau), jarak tanam yang tidak terlalu rapat, dan aplikasi fungisida berbahan aktif mankozeb, azoksistrobin, atau propikonazol jika serangan tinggi.',
      symptoms:
          'Pustula oranye keemasan kecil sangat padat, terutama di permukaan atas daun, daun cepat mengering',
      causes: 'Jamur Puccinia polysora',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_stalk_rot',
      name: 'Stalk Rot',
      nameIndonesia: 'Busuk Batang Jagung',
      description:
          'Busuk Batang Jagung dapat disebabkan oleh berbagai jamur tanah termasuk Fusarium verticillioides, Colletotrichum graminicola (Antraknosa), Diplodia maydis, dan Gibberella zeae. Penyakit ini umumnya muncul pada akhir musim tanam saat tanaman sudah memasuki fase pengisian biji dan mengalami stres (kekeringan, kepadatan tinggi, kekurangan kalium). Gejala awal berupa perubahan warna daun menjadi keabu-abuan atau menguning prematur, dimulai dari daun bawah. Jika batang dibelah, terlihat jaringan empulur (pith) bagian dalam yang membusuk, berwarna coklat kehitaman, dan hancur. Batang menjadi empuk, mudah remuk jika ditekan atau dipijit (squeeze test positif), dan tanaman mudah rebah (lodging) saat terkena angin atau saat panen. Serangan dapat menyebabkan tongkol tidak terisi penuh karena gangguan translokasi nutrisi. Pengendalian meliputi pemilihan varietas dengan batang kokoh, tidak menanam terlalu rapat, pemupukan kalium yang cukup, pengelolaan sisa tanaman, rotasi tanaman dengan kacang-kacangan, dan panen tepat waktu sebelum tanaman rebah.',
      symptoms:
          'Batang bawah coklat kehitaman lunak mudah remuk, empulur hancur, tanaman rebah, daun keabu-abuan prematur',
      causes:
          'Jamur Fusarium sp., Colletotrichum graminicola, Diplodia, Gibberella',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_ear_rot',
      name: 'Ear Rot',
      nameIndonesia: 'Busuk Tongkol Jagung',
      description:
          'Busuk tongkol sering disebabkan oleh jamur Fusarium verticillioides atau Aspergillus flavus. Gejala terlihat saat kelobot dibuka: biji jagung berubah warna menjadi merah jambu, putih, atau hitam, dan sering diselimuti benang jamur. Bahaya utamanya bukan hanya gagal panen, tetapi produksi mikotoksin (seperti Aflatoksin) yang beracun bagi manusia dan ternak jika jagung tersebut dikonsumsi.',
      symptoms: 'Biji berubah warna, miselium putih/merah muda, bau apek',
      causes: 'Jamur Fusarium verticillioides, Aspergillus sp.',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_gray_leaf_spot',
      name: 'Gray Leaf Spot',
      nameIndonesia: 'Bercak Daun Abu-abu Jagung',
      description:
          'Bercak Daun Abu-abu disebabkan oleh jamur Cercospora zeae-maydis dan merupakan salah satu penyakit daun paling merusak pada jagung di daerah lembab. Gejala awal berupa bercak kecil berwarna coklat muda hingga coklat dengan tepi kuning pada daun bagian bawah. Ciri diagnostik yang sangat khas adalah lesi yang berkembang menjadi bercak persegi panjang atau segi empat memanjang berwarna abu-abu kecoklatan yang dibatasi secara tegas oleh tulang daun (vein-limited lesions). Bentuk lesi seperti kotak atau persegi panjang ini sangat berbeda dari penyakit lain. Dalam kondisi optimal (suhu hangat 22-30°C, kelembaban tinggi, embun pagi), lesi dapat menyatu dan menutupi seluruh permukaan daun sehingga tampak hawar keabu-abuan. Defoliasi parah terjadi jika serangan terjadi sebelum pengisian biji, menyebabkan penurunan hasil signifikan. Jamur bertahan pada sisa jagung. Pengendalian meliputi rotasi tanaman, pengolahan tanah untuk membenamkan sisa tanaman, varietas tahan, dan aplikasi fungisida strobilurin atau kombinasi azoksistrobin-propikonazol.',
      symptoms:
          'Bercak persegi panjang abu-abu kecoklatan dibatasi tegas oleh tulang daun, lesi menyatu menjadi hawar',
      causes: 'Jamur Cercospora zeae-maydis',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_maize_streak',
      name: 'Maize Streak Virus',
      nameIndonesia: 'Virus Belang Jagung',
      description:
          'Virus Belang Jagung (Maize Streak Virus/MSV) adalah penyakit virus penting pada jagung di Afrika dan beberapa wilayah Asia termasuk Indonesia. Virus ini ditularkan secara persisten oleh vektor wereng daun (leafhopper) genus Cicadulina. Gejala khas berupa garis-garis atau bercak-bercak kuning pucat yang tersusun putus-putus sepanjang tulang daun, memberikan tampilan \"belang\" atau \"streak\" yang khas. Garis-garis ini lebih jelas terlihat pada daun muda. Tanaman yang terinfeksi pada fase awal mengalami kekerdilan parah, pemucatan, dan gagal membentuk tongkol atau tongkol sangat kecil dengan biji yang tidak terisi. Infeksi pada fase lebih lanjut menyebabkan efek yang lebih ringan. Tidak ada obat untuk tanaman yang sudah terinfeksi. Pengendalian fokus pada pemutusan siklus vektor: menanam varietas tahan MSV, menghilangkan gulma inang di sekitar lahan, menanam serempak untuk menghindari bridge tanaman, dan pengendalian vektor wereng daun dengan insektisida sistemik jika populasi tinggi.',
      symptoms:
          'Garis-garis kuning pucat putus-putus sepanjang tulang daun (belang/streak), tanaman kerdil, tongkol kecil/tidak ada',
      causes: 'Maize Streak Virus (MSV), vektor: Cicadulina spp.',
      affectedPlants: ['Jagung', 'Sorgum'],
    ),
    Disease(
      id: 'corn_smut',
      name: 'Common Smut',
      nameIndonesia: 'Gosong Jagung (Bengkak)',
      description:
          'Gosong Jagung atau Gosong Bengkak disebabkan oleh jamur Ustilago maydis. Penyakit ini unik karena dapat menyerang semua bagian tanaman yang aktif tumbuh di atas tanah, terutama bagian yang sedang berkembang seperti tongkol muda, batang, dan daun. Gejala khas berupa pembengkakan abnormal (gall/tumor) pada bagian yang terserang. Tumor awalnya berwarna putih keperakan dengan tekstur lunak dan berdaging, kemudian membesar dan berubah warna menjadi abu-abu kehijauan, dan akhirnya pecah mengeluarkan massa spora hitam seperti debu (teliospore). Pembengkakan pada tongkol sangat menonjol dan dapat menggantikan seluruh biji. Pada batang dan daun, gall biasanya lebih kecil. Menariknya, di Meksiko, gall muda dikonsumsi sebagai makanan lezat bernama \"Huitlacoche\". Penyakit favorit pada tanaman stres luka (serangga, hujan es). Pengendalian meliputi menghindari kerusakan mekanis pada tanaman, tidak menggunakan pupuk nitrogen berlebihan, varietas tahan, membuang dan membakar gall sebelum pecah (mengeluarkan spora), dan rotasi tanaman.',
      symptoms:
          'Tumor/gall putih keabu-abuan pada tongkol, batang, atau daun, membesar lalu pecah mengeluarkan spora hitam',
      causes: 'Jamur Ustilago maydis',
      affectedPlants: ['Jagung'],
    ),
    Disease(
      id: 'corn_leaf_spot',
      name: 'Curvularia Leaf Spot',
      nameIndonesia: 'Bercak Daun Curvularia Jagung',
      description:
          'Bercak Daun Curvularia disebabkan oleh jamur Curvularia lunata dan merupakan penyakit yang umum menyerang jagung muda terutama di persemaian atau pada fase vegetatif awal di daerah tropis lembab. Gejala berupa bercak kecil berbentuk oval hingga bulat berwarna coklat muda hingga keabu-abuan dengan pusat yang lebih terang. Bercak sering dikelilingi oleh halo (lingkaran) berwarna kuning. Bercak dapat membesar dan menyatu pada serangan berat, menyebabkan daun mengering. Penyakit ini umumnya tidak menyebabkan kerugian ekonomi yang besar pada tanaman dewasa karena tanaman yang lebih tua cenderung lebih tahan. Namun, pada jagung muda atau bibit, serangan berat dapat menghambat pertumbuhan. Jamur bertahan pada sisa tanaman dan benih terinfeksi. Pengendalian meliputi penggunaan benih sehat dan bebas penyakit, perlakuan benih dengan fungisida, sanitasi persemaian, dan menghindari kelembaban berlebihan di sekitar bibit.',
      symptoms:
          'Bercak kecil oval coklat muda dengan pusat terang dan halo kuning, terutama pada tanaman muda',
      causes: 'Jamur Curvularia lunata',
      affectedPlants: ['Jagung', 'Sorgum', 'Padi'],
    ),
    Disease(
      id: 'corn_crazy_top',
      name: 'Crazy Top',
      nameIndonesia: 'Pucuk Gila Jagung',
      description:
          'Pucuk Gila atau Crazy Top disebabkan oleh jamur Sclerophthora macrospora, merupakan penyakit yang jarang namun sangat mencolok jika terjadi. Penyakit ini berkembang ketika tanaman muda (fase 2-4 daun) tergenang air dalam waktu lama (24-48 jam). Gejala paling mencolok terlihat saat tanaman mulai berbunga: bunga jantan (tassel) mengalami proliferasi abnormal dan berubah menjadi struktur daun-daunan berlebihan yang tampak \"gila\" atau tidak teratur (phyllody). Tassel menjadi sangat lebat, bercabang berlebihan, dan steril. Daun juga menunjukkan gejala bergelombang, menebal, dan kaku. Tanaman terserang biasanya tidak menghasilkan tongkol atau tongkolnya sangat abnormal. Seluruh tanaman dapat menunjukkan kekerdilan. Penyakit ini tidak menyebar dari tanaman ke tanaman di lapangan, melainkan infeksi terjadi melalui zoospora dari tanah saat genangan. Pengendalian utama adalah menghindari genangan air di lahan jagung, memperbaiki drainase, dan tidak menanam di lahan yang sering tergenang.',
      symptoms:
          'Tassel (bunga jantan) berproliferasi abnormal seperti daun-daunan, daun bergelombang kaku, tanaman steril',
      causes: 'Jamur Sclerophthora macrospora',
      affectedPlants: ['Jagung', 'Sorgum', 'Padi'],
    ),
    Disease(
      id: 'corn_bacterial_stalk_rot',
      name: 'Bacterial Stalk Rot',
      nameIndonesia: 'Busuk Batang Bakteri Jagung',
      description:
          'Busuk Batang Bakteri disebabkan oleh bakteri Dickeya zeae (sebelumnya Erwinia chrysanthemi pv. zeae) dan merupakan penyakit yang sangat cepat menyebabkan kerusakan dibanding busuk batang jamur. Penyakit ini favorit berkembang pada kondisi panas dan lembab, terutama setelah hujan deras atau irigasi berlebihan yang menyebabkan genangan. Gejala awal berupa bercak basah berair pada pelepah atau batang yang berkembang sangat cepat (dalam 2-3 hari). Jaringan yang terinfeksi menjadi sangat lunak, berair (water-soaked), dan berwarna coklat. Ciri khas adalah bau busuk yang sangat menyengat (foul odor) dari jaringan yang membusuk karena fermentasi bakteri. Bagian atas tanaman dapat dengan mudah terlepas dari bagian bawah dan roboh. Bakteri menyebar melalui air irigasi dan percikan air hujan. Pengendalian meliputi menghindari genangan air, tidak melakukan irigasi berlebihan terutama saat cuaca panas, pengaturan jarak tanam untuk sirkulasi udara, pencabutan dan pemusnahan tanaman terinfeksi, serta penggunaan varietas tahan jika tersedia.',
      symptoms:
          'Batang lunak berair sangat cepat membusuk, bau busuk menyengat, tanaman mudah roboh, bagian atas terlepas',
      causes: 'Bakteri Dickeya zeae (syn. Erwinia chrysanthemi pv. zeae)',
      affectedPlants: ['Jagung'],
    ),

    // ========== PENYAKIT CABAI (25-36) ==========
    Disease(
      id: 'chili_anthracnose',
      name: 'Anthracnose',
      nameIndonesia: 'Antraknosa Cabai',
      description:
          'Antraknosa ("Patek") adalah penyakit paling merusak pada cabai, terutama saat musim hujan. Disebabkan oleh jamur Colletotrichum sp., penyakit ini menyerang buah muda maupun masak. Gejala awal berupa bercak coklat kehitaman yang kemudian membesar dan cekung (lesi). Di tengah bercak, sering terlihat massa spora berwarna merah muda atau oranye yang tersusun melingkar (konsentris). Buah yang terserang akan membusuk kering dan gugur, menyebabkan kerugian hasil hingga 80%.',
      symptoms: 'Bercak cekung pada buah, lingkaran konsentris, busuk lunak',
      causes: 'Jamur Colletotrichum capsici, C. gloeosporioides',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_bacterial_wilt',
      name: 'Bacterial Wilt',
      nameIndonesia: 'Layu Bakteri Cabai',
      description:
          'Layu Bakteri adalah penyakit mematikan yang disebabkan oleh Ralstonia solanacearum. Karakteristik utamanya adalah tanaman layu mendadak saat siang hari namun tampak segar kembali di malam hari, sebelum akhirnya mati total dengan kondisi daun tetap hijau. Jika batang dipotong dan dicelupkan ke air bening, akan keluar aliran massa bakteri menyerupai asap putih (ooze). Bakteri ini bertahan lama di tanah dan menyebar lewat air irigasi.',
      symptoms: 'Layu mendadak tanpa menguning, batang berlendir saat dipotong',
      causes: 'Bakteri Ralstonia solanacearum',
      affectedPlants: ['Cabai', 'Tomat', 'Terong'],
    ),
    Disease(
      id: 'chili_fusarium_wilt',
      name: 'Fusarium Wilt',
      nameIndonesia: 'Layu Fusarium Cabai',
      description:
          'Layu Fusarium adalah penyakit layu pembuluh serius pada cabai yang disebabkan oleh jamur tanah Fusarium oxysporum f.sp. capsici. Jamur ini menginfeksi akar dan menyumbat pembuluh xylem sehingga transportasi air terganggu. Gejala awal berupa layu yang dimulai dari cabang atau sisi tanaman tertentu saja (layu unilateral) pada siang hari terik. Berbeda dengan layu bakteri yang daun tetap hijau, layu Fusarium menyebabkan daun menguning secara progresif dari bawah ke atas sebelum layu permanen. Jika batang dibelah, terlihat pembuluh xylem berwarna coklat tua hingga coklat kemerahan. Pada bagian tanaman yang terinfeksi berat, sering terlihat miselium (hifa) putih seperti kapas di permukaan batang yang lembab. Akar mengecil, rapuh, dan mudah patah. Jamur bertahan lama di tanah melalui klamidospora. Kondisi tanah asam dan suhu tinggi (>28°C) mendukung perkembangan penyakit. Pengendalian meliputi rotasi tanaman minimal 3-4 tahun, penggunaan agen hayati antagonis (Trichoderma sp., Gliocladium sp.), memperbaiki pH tanah, drainase yang baik, dan varietas tahan.',
      symptoms:
          'Daun menguning dari bawah, layu satu sisi (unilateral), pembuluh batang coklat tua, miselium putih',
      causes: 'Jamur Fusarium oxysporum f.sp. capsici',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_cercospora_leaf_spot',
      name: 'Cercospora Leaf Spot',
      nameIndonesia: 'Bercak Daun Cercospora Cabai (Mata Katak)',
      description:
          'Bercak Daun Cercospora, dikenal juga sebagai "Penyakit Mata Katak" karena bentuk bercaknya, disebabkan oleh jamur Cercospora capsici. Penyakit ini dapat menyerang tanaman cabai dari fase persemaian hingga berbuah. Gejala khas berupa bercak bulat berwarna cokelat dengan bagian pusat yang lebih pucat (abu-abu keputihan) dan tepi yang lebih gelap (coklat tua), memberikan tampilan seperti mata katak. Bercak berukuran kecil (2-5 mm) namun jumlahnya bisa sangat banyak. Sering dikelilingi halo (lingkaran) kuning. Pada serangan lanjut, bagian tengah bercak bisa rontok menyebabkan daun berlubang-lubang. Daun yang terserang parah akan menguning dan gugur, menyebabkan defoliasi yang mengurangi kemampuan fotosintesis dan membuat buah terpapar sinar matahari langsung (sunscald). Penyakit juga menyerang batang dan tangkai buah. Kondisi kelembaban tinggi, musim hujan, jarak tanam terlalu rapat, dan drainase buruk mendukung perkembangan penyakit. Pengendalian meliputi jarak tanam yang cukup, drainase baik, sanitasi, dan aplikasi fungisida mankozeb atau klorotalonil.',
      symptoms:
          'Bercak bulat coklat dengan pusat pucat (mata katak), halo kuning, daun berlubang lalu gugur',
      causes: 'Jamur Cercospora capsici',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_powdery_mildew',
      name: 'Powdery Mildew',
      nameIndonesia: 'Embun Tepung Cabai',
      description:
          'Embun Tepung pada cabai disebabkan oleh jamur Leveillula taurica yang berbeda dari embun tepung pada tanaman lain. Penyakit ini lebih umum menjadi masalah di dataran tinggi (>700 mdpl) dengan suhu sejuk dan relatif kering. Gejala awal berupa bercak kekuningan tidak jelas di permukaan atas daun tua. Jika daun dibalik, terlihat lapisan serbuk putih keabu-abuan seperti tepung yang merupakan miselium dan spora jamur. Berbeda dengan embun tepung pada mentimun yang tepungnya terlihat di atas daun, pada cabai tepung lebih jelas terlihat di bawah daun. Serangan biasanya dimulai pada daun tua kemudian menyebar ke daun muda. Daun yang terserang parah akan menguning, mengering, dan gugur menyebabkan defoliasi. Penyakit berkembang optimal pada suhu 15-32°C, kelembaban rendah-sedang, dan kondisi ternaung. Buah yang kehilangan naungan daun berisiko terbakar matahari. Pengendalian meliputi penggunaan varietas toleran, memperbaiki sirkulasi udara, dan aplikasi fungisida sulfur atau azoksistrobin.',
      symptoms:
          'Bercak kuning di atas daun, lapisan tepung putih keabu-abuan di bawah daun, daun menguning lalu gugur',
      causes: 'Jamur Leveillula taurica',
      affectedPlants: ['Cabai', 'Paprika', 'Tomat', 'Terong'],
    ),
    Disease(
      id: 'chili_phytophthora_blight',
      name: 'Phytophthora Blight',
      nameIndonesia: 'Hawar Phytophthora Cabai',
      description:
          'Hawar Phytophthora disebabkan oleh Phytophthora capsici dan merupakan salah satu penyakit paling merusak pada cabai terutama saat musim hujan dengan curah hujan tinggi. Patogen ini dapat menyerang semua bagian tanaman: akar, batang, daun, dan buah. Gejala pada batang berupa bercak coklat kehitaman yang dimulai dari pangkal batang dekat permukaan tanah, kemudian meluas ke atas dan ke bawah. Seiring waktu, dapat muncul miselium halus berwarna putih-hitam pada permukaan bercak saat kondisi lembab. Infeksi menyebabkan akar dan pangkal batang membusuk (crown rot), mengakibatkan tanaman layu dan mati. Daun yang terserang menunjukkan bercak basah berair yang cepat meluas menjadi hawar, menyebabkan daun layu dan rontok dari daun bawah ke atas. Buah yang terserang menunjukkan bercak busuk basah coklat dan sering menyebabkan gugur buah dan bunga. Jamur menyukai kondisi basah hangat (optimal ~26°C). Pengendalian meliputi perbaikan drainase (bedengan tinggi), tidak menyiram berlebihan, mulsa plastik, rotasi tanaman dengan non-Solanaceae, dan aplikasi fungisida metalaksil atau fosetil-Al.',
      symptoms:
          'Busuk coklat kehitaman pada pangkal batang (crown rot), daun layu basah, buah busuk berair, tanaman mati',
      causes: 'Jamur/Oomycete Phytophthora capsici',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_mosaic_virus',
      name: 'Chili Mosaic Virus',
      nameIndonesia: 'Virus Mosaik Cabai',
      description:
          'Virus Mosaik Cabai dapat disebabkan oleh beberapa jenis virus, yang paling umum adalah Cucumber Mosaic Virus (CMV) dan Chili Veinal Mottle Virus (ChiVMV). CMV ditularkan oleh kutu daun (aphid) secara non-persisten, sedangkan ChiVMV oleh kutu daun secara semi-persisten. Gejala bervariasi tergantung jenis virus dan kondisi lingkungan. Gejala umum meliputi mosaik (belang-belang hijau muda dan hijau tua tidak teratur pada daun), daun keriting atau berkerut (crinkled), daun mengecil dan menyempit (shoelace), serta deformasi tulang daun (vein banding). Tanaman yang terinfeksi dini tumbuh kerdil dan produksi buah sangat rendah. Buah yang dihasilkan kecil, cacat, dan sering menunjukkan bercak atau belang. Tidak ada obat untuk tanaman yang sudah terinfeksi. Pengendalian fokus pada pengendalian vektor kutu daun, eradikasi tanaman terinfeksi dan gulma inang, penggunaan mulsa perak reflektif untuk mengusir kutu daun, barrier tanaman (jagung), dan penggunaan benih bebas virus.',
      symptoms:
          'Daun belang hijau muda-tua (mosaik), daun keriting mengecil, buah kecil cacat berbintik',
      causes:
          'Cucumber Mosaic Virus (CMV), Chili Veinal Mottle Virus (ChiVMV), ditularkan kutu daun',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_yellow_leaf_curl',
      name: 'Yellow Leaf Curl',
      nameIndonesia: 'Keriting Kuning Cabai',
      description:
          'Penyakit Virus Kuning (Gemini) merupakan ancaman serius karena penyebarannya yang sangat cepat oleh vektor Kutu Kebul (Bemisia tabaci). Tanaman yang terserang menunjukkan gejala daun muda menguning cerah, tulang daun menebal, dan helai daun melengkung ke atas (cupping). Pertumbuhan tanaman terhambat (kerdil) dan tidak mampu menghasilkan buah. Pengendalian utamanya adalah memutus siklus hidup vektor kutu kebul.',
      symptoms: 'Daun menggulung ke atas, menguning, tanaman kerdil',
      causes: 'Pepper Yellow Leaf Curl Virus (PepYLCV)',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_bacterial_spot',
      name: 'Bacterial Spot',
      nameIndonesia: 'Bercak Bakteri Cabai',
      description:
          'Bercak Bakteri disebabkan oleh bakteri Xanthomonas euvesicatoria (sebelumnya X. campestris pv. vesicatoria) dan merupakan penyakit penting pada cabai terutama saat musim hujan. Bakteri menyerang daun, batang, dan buah. Gejala pada daun berupa bercak kecil (1-3 mm) berbentuk tidak teratur, awalnya basah berair (water-soaked) kemudian berubah menjadi coklat tua hingga hitam dengan tepi kuning. Bercak dapat menyatu membentuk area nekrotik besar. Daun yang terserang berat akan menguning dan rontok. Pada buah, gejala berupa bercak kecil menonjol berwarna coklat dengan permukaan kasar seperti kerak (scab-like), yang menurunkan kualitas buah dan nilai jual. Pada buah hijau, bercak sering tampak terangkat; pada buah merah, bercak tampak cekung. Bakteri menyebar melalui percikan air hujan, irigasi overhead, benih terinfeksi, dan alat. Kondisi hangat lembab (24-30°C) mendukung penyakit. Pengendalian meliputi penggunaan benih sehat bebas penyakit, menghindari irigasi overhead, jarak tanam cukup, sanitasi, aplikasi bakterisida berbasis tembaga (copper), dan varietas tahan jika tersedia.',
      symptoms:
          'Bercak kecil basah berair pada daun menjadi coklat-hitam, bercak kasar seperti kerak pada buah',
      causes:
          'Bakteri Xanthomonas euvesicatoria (syn. X. campestris pv. vesicatoria)',
      affectedPlants: ['Cabai', 'Paprika', 'Tomat'],
    ),
    Disease(
      id: 'chili_damping_off',
      name: 'Damping Off',
      nameIndonesia: 'Rebah Semai Cabai',
      description:
          'Rebah Semai atau Damping-off adalah penyakit fatal yang menyerang bibit cabai di persemaian, disebabkan oleh kompleks jamur tanah termasuk Rhizoctonia solani, Pythium spp., Fusarium spp., dan Phytophthora spp. Penyakit ini dapat menyerang sebelum atau sesudah benih berkecambah. Gejala sebelum muncul (pre-emergence damping-off) berupa benih yang membusuk di dalam tanah sehingga tidak muncul ke permukaan. Gejala setelah muncul (post-emergence damping-off) berupa lesi basah berair pada pangkal batang bibit yang menyebabkan batang menjadi lunak, mengerut, dan berwarna kecoklatan. Bibit kemudian rebah, layu, dan mati. Serangan dapat menyebar cepat dari satu bibit ke bibit lainnya dalam barisan, menyebabkan kekosongan (patchy stand). Kondisi yang mendukung meliputi kelembaban tanah berlebihan, drainase buruk, persemaian terlalu padat, ventilasi kurang, dan penggunaan tanah yang tidak steril. Pengendalian meliputi sterilisasi media semai, penggunaan benih berkualitas, jangan menyemai terlalu padat, penyiraman secukupnya (tidak berlebihan), ventilasi baik, aplikasi Trichoderma sp. pada media semai, dan perlakuan benih dengan fungisida.',
      symptoms:
          'Pangkal batang bibit berair lunak mengerut kecoklatan, bibit rebah dan mati, benih busuk tidak muncul',
      causes:
          'Jamur kompleks: Rhizoctonia solani, Pythium spp., Fusarium spp., Phytophthora spp.',
      affectedPlants: ['Cabai', 'Tomat', 'Terong', 'Paprika'],
    ),
    Disease(
      id: 'chili_leaf_curl',
      name: 'Leaf Curl Disease',
      nameIndonesia: 'Keriting Daun Cabai',
      description: 'Penyakit yang menyebabkan daun menggulung.',
      symptoms: 'Daun menggulung, menebal, permukaan tidak rata',
      causes: 'Tungau Polyphagotarsonemus latus atau virus',
      affectedPlants: ['Cabai', 'Paprika'],
    ),
    Disease(
      id: 'chili_root_knot',
      name: 'Root Knot Nematode',
      nameIndonesia: 'Nematoda Puru Akar Cabai',
      description: 'Penyakit yang disebabkan nematoda parasit akar.',
      symptoms: 'Benjolan/puru pada akar, tanaman kerdil, layu saat panas',
      causes: 'Nematoda Meloidogyne sp.',
      affectedPlants: ['Cabai', 'Tomat', 'Terong', 'Wortel'],
    ),

    // ========== PENYAKIT TOMAT (37-46) ==========
    Disease(
      id: 'tomato_late_blight',
      name: 'Late Blight',
      nameIndonesia: 'Hawar Daun Tomat (Busuk Daun)',
      description:
          'Hawar Daun atau Busuk Daun adalah penyakit paling destruktif pada tomat dan kentang, disebabkan oleh Phytophthora infestans. Di Indonesia, penyakit ini merupakan ancaman utama di dataran tinggi dengan iklim sejuk dan lembab. Gejala awal berupa bercak basah tidak beraturan berwarna hijau keabu-abuan di tepi atau ujung daun, yang cepat melebar menjadi coklat kehitaman dengan batas tidak jelas. Pada kondisi lembab (RH >80%), di permukaan bawah daun muncul lapisan miselium putih halus keabu-abuan (sporangia). Penyakit dapat menyerang batang dan buah, menyebabkan buah membusuk dengan tampilan marbled brown (coklat belang). Penyakit berkembang optimal pada suhu 18-26°C dengan kelembaban tinggi dapat menghancurkan seluruh kebun hanya dalam 3-7 hari. Pengendalian meliputi penggunaan varietas tahan, rotasi tanaman non-Solanaceae, sanitasi (cabut dan bakar tanaman terinfeksi), dan aplikasi fungisida mankozeb, klorotalonil, atau mandipropamid secara preventif.',
      symptoms:
          'Bercak basah coklat kehitaman tidak beraturan, miselium putih di bawah daun saat lembab, buah busuk',
      causes: 'Jamur/Oomycete Phytophthora infestans',
      affectedPlants: ['Tomat', 'Kentang'],
    ),
    Disease(
      id: 'tomato_early_blight',
      name: 'Early Blight',
      nameIndonesia: 'Bercak Kering Tomat (Alternaria)',
      description:
          'Bercak Kering atau Early Blight disebabkan oleh jamur Alternaria solani, merupakan penyakit penting yang menyerang tomat di semua fase pertumbuhan. Berbeda dengan Late Blight yang lebih suka cuaca sejuk, penyakit ini berkembang baik pada suhu hangat (24-29°C) dengan periode basah bergantian kering. Gejala khas berupa bercak coklat tua berbentuk bulat hingga tidak teratur dengan pola lingkaran konsentris seperti "target" atau "papan sasaran", sering dikelilingi halo kuning. Serangan dimulai dari daun tua di bagian bawah tanaman, kemudian menyebar ke atas. Jamur juga menyerang buah, menyebabkan bercak cekung gelap di dekat tangkai. Jamur bertahan pada sisa tanaman terinfeksi di tanah. Pengendalian meliputi rotasi tanaman 2-3 tahun, memangkas daun bawah, mulsa untuk mencegah percikan tanah, dan aplikasi fungisida berbahan aktif klorotalonil atau mankozeb.',
      symptoms:
          'Bercak coklat dengan lingkaran konsentris (pola target), halo kuning, menyerang dari daun bawah',
      causes: 'Jamur Alternaria solani',
      affectedPlants: ['Tomat', 'Kentang', 'Cabai', 'Terong'],
    ),
    Disease(
      id: 'tomato_fusarium_wilt',
      name: 'Fusarium Wilt',
      nameIndonesia: 'Layu Fusarium Tomat',
      description:
          'Layu Fusarium adalah penyakit layu pembuluh yang sangat merusak, disebabkan oleh jamur tanah Fusarium oxysporum f.sp. lycopersici. Jamur ini menginfeksi akar dan menyumbat pembuluh xylem sehingga air tidak dapat naik ke bagian atas tanaman. Gejala khas adalah penguningan dan layu yang dimulai dari satu sisi tanaman atau satu cabang saja (layu unilateral/asimetris). Daun menguning dari bawah ke atas secara progresif. Jika batang dipotong melintang, terlihat cincin pembuluh berwarna coklat kemerahan. Tanaman akhirnya layu permanen dan mati. Jamur dapat bertahan di tanah selama bertahun-tahun melalui klamidospora. Kondisi suhu tinggi (>28°C) dan tanah asam mendukung perkembangan penyakit. Pengendalian terbaik adalah menggunakan varietas tahan (gen I-1, I-2, I-3), rotasi tanaman minimal 5-7 tahun, dan memperbaiki pH tanah menjadi 6.5-7.0.',
      symptoms:
          'Layu satu sisi tanaman (asimetris), daun menguning dari bawah, pembuluh batang coklat kemerahan',
      causes: 'Jamur Fusarium oxysporum f.sp. lycopersici',
      affectedPlants: ['Tomat'],
    ),
    Disease(
      id: 'tomato_bacterial_wilt',
      name: 'Bacterial Wilt',
      nameIndonesia: 'Layu Bakteri Tomat',
      description:
          'Layu Bakteri adalah salah satu penyakit paling merusak pada tomat di daerah tropis dan subtropis, disebabkan oleh bakteri Ralstonia solanacearum. Karakteristik unik penyakit ini adalah tanaman layu mendadak dan cepat tanpa didahului gejala penguningan daun seperti layu Fusarium. Pada awalnya, tanaman terlihat layu saat siang hari terik namun pulih di malam hari, sebelum akhirnya layu permanen dan mati dalam beberapa hari. Uji diagnostik sederhana: potong batang dan celupkan ke air jernih, akan terlihat aliran massa bakteri (bacterial ooze) berwarna putih susu seperti asap yang keluar dari pembuluh. Bakteri ini memiliki kisaran inang sangat luas (>200 spesies) dan bertahan lama di tanah serta menyebar melalui air irigasi. Tidak ada fungisida yang efektif. Pengendalian meliputi penggunaan varietas tahan, rotasi dengan tanaman non-inang (padi, jagung), perbaikan drainase, dan sanitasi ketat.',
      symptoms:
          'Layu mendadak cepat tanpa menguning, daun tetap hijau, cairan bakteri putih dari potongan batang',
      causes: 'Bakteri Ralstonia solanacearum',
      affectedPlants: ['Tomat', 'Cabai', 'Terong', 'Kentang'],
    ),
    Disease(
      id: 'tomato_leaf_mold',
      name: 'Leaf Mold',
      nameIndonesia: 'Kapang Daun Tomat',
      description:
          'Kapang Daun adalah penyakit serius pada budidaya tomat di rumah kaca atau screen house dengan kelembaban tinggi, disebabkan oleh jamur Passalora fulva (syn. Fulvia fulva, Cladosporium fulvum). Gejala awal berupa bercak hijau muda pucat atau kuning pucat tidak bertepi jelas di permukaan atas daun tua. Ciri diagnostik utama adalah terbentuknya lapisan kapang beludru berwarna hijau zaitun hingga coklat zaitun di permukaan bawah daun pada lokasi yang bersesuaian dengan bercak di atas. Seiring perkembangan penyakit, bercak meluas dan daun menggulung, mengering, dan rontok, menyebabkan defoliasi parah. Buah jarang terserang namun bisa terjadi busuk hitam di ujung tangkai. Penyakit berkembang optimal pada kelembaban >85% dan suhu 22-24°C. Spora sangat tahan kering dan dapat bertahan berbulan-bulan. Pengendalian utama adalah menjaga sirkulasi udara, menurunkan kelembaban di bawah 85%, menggunakan varietas tahan, dan aplikasi fungisida klorotalonil.',
      symptoms:
          'Bercak kuning pucat di atas daun, lapisan beludru hijau zaitun di bawah daun, daun menggulung kering',
      causes: 'Jamur Passalora fulva (syn. Cladosporium fulvum)',
      affectedPlants: ['Tomat'],
    ),
    Disease(
      id: 'tomato_septoria_leaf_spot',
      name: 'Septoria Leaf Spot',
      nameIndonesia: 'Bercak Septoria Tomat',
      description:
          'Bercak Septoria adalah salah satu penyakit daun paling merusak pada tomat, disebabkan oleh jamur Septoria lycopersici. Penyakit ini berkembang pesat pada musim hujan atau kondisi lembab dengan suhu hangat (20-25°C). Gejala khas berupa bercak kecil bulat (diameter 2-3 mm) yang sangat banyak jumlahnya, dengan pusat berwarna abu-abu hingga tan dan tepi gelap coklat tua, sering dikelilingi halo kuning. Ciri diagnostik adalah adanya titik-titik hitam kecil (pycnidia) di tengah bercak yang terlihat dengan kaca pembesar. Serangan dimulai dari daun tua di bawah saat tanaman mulai berbuah, kemudian menyebar ke atas menyebabkan defoliasi parah. Defoliasi menyebabkan buah terbakar matahari (sunscald). Tidak ada varietas tomat komersial yang tahan. Jamur bertahan pada sisa tanaman dan gulma Solanaceae. Pengendalian meliputi rotasi 2-3 tahun, sanitasi, menghindari irigasi overhead, mulsa, dan aplikasi fungisida klorotalonil atau mankozeb.',
      symptoms:
          'Bercak kecil bulat banyak, pusat abu-abu dengan titik hitam (pycnidia), tepi coklat, halo kuning, defoliasi',
      causes: 'Jamur Septoria lycopersici',
      affectedPlants: ['Tomat'],
    ),
    Disease(
      id: 'tomato_mosaic',
      name: 'Tomato Mosaic Virus',
      nameIndonesia: 'Virus Mosaik Tomat',
      description:
          'Virus Mosaik Tomat (ToMV) adalah penyakit virus yang sangat mudah menular secara mekanis melalui sentuhan, alat, dan benih terinfeksi. Virus ini sangat stabil dan dapat bertahan pada permukaan kering selama berminggu-minggu bahkan bertahun-tahun. Gejala bervariasi tergantung strain virus, kultivar, dan kondisi lingkungan. Gejala umum meliputi: mosaik (belang-belang hijau muda dan hijau tua pada daun), daun menggulung atau berkerut (puckering), daun menyempit seperti tali sepatu (shoestring), tanaman kerdil, dan buah dengan bercak cincin atau berbintik coklat internal (internal browning). Suhu tinggi dapat menyembunyikan gejala (masked symptoms). Tidak ada obat untuk virus. Pengendalian meliputi menggunakan benih bebas virus, mencuci tangan dengan susu atau sabun sebelum memegang tanaman, tidak merokok dekat tanaman (virus terkait TMV), dan menggunakan varietas tahan gen Tm-2 atau Tm-2².',
      symptoms:
          'Daun belang hijau muda-tua (mosaik), daun keriting/berkerut, daun menyempit, buah berbintik internal',
      causes: 'Tomato Mosaic Virus (ToMV)',
      affectedPlants: ['Tomat', 'Cabai', 'Paprika', 'Terong'],
    ),
    Disease(
      id: 'tomato_yellow_leaf_curl',
      name: 'Yellow Leaf Curl',
      nameIndonesia: 'Keriting Kuning Tomat (TYLCV)',
      description:
          'Tomato Yellow Leaf Curl Virus (TYLCV) adalah salah satu penyakit virus paling merusak pada tomat di seluruh dunia, menyebabkan kerugian hasil hingga 100% jika infeksi terjadi dini. Ditularkan secara persisten oleh vektor Kutu Kebul (Bemisia tabaci) dengan masa inkubasi 2-3 minggu. Gejalanya sangat khas dan mudah dikenali: daun muda menguning terutama di pinggir (chlorotic margins), daun menggulung ke atas seperti mangkuk atau sendok (cupping), daun mengecil dan menebal, tulang daun menebal (vein swelling), tanaman sangat kerdil (stunting parah), internoda memendek, dan bunga sering gugur sehingga produksi buah sangat minim atau nihil. Tanaman yang terinfeksi saat muda hampir tidak menghasilkan buah sama sekali. Tidak ada obat untuk virus. Pengendalian fokus pada manajemen vektor kutu kebul: mulsa perak reflektif, screen house dengan mesh 50, insektisida sistemik (imidakloprid, tiametoksam), dan penggunaan varietas tahan gen Ty-1, Ty-2, atau Ty-3.',
      symptoms:
          'Daun menggulung ke atas (cupping), menguning di pinggir, tanaman sangat kerdil, bunga gugur, tidak berbuah',
      causes: 'Tomato Yellow Leaf Curl Virus (TYLCV), vektor: Bemisia tabaci',
      affectedPlants: ['Tomat'],
    ),
    Disease(
      id: 'tomato_blossom_end_rot',
      name: 'Blossom End Rot',
      nameIndonesia: 'Busuk Ujung Bunga Tomat',
      description:
          'Busuk Ujung Bunga adalah gangguan fisiologis (bukan penyakit infeksi) yang disebabkan oleh ketidakseimbangan kalsium di dalam jaringan buah yang sedang berkembang. Meskipun kalsium mungkin tersedia di tanah, stres air (penyiraman tidak teratur), pertumbuhan vegetatif terlalu cepat, atau kerusakan akar dapat mengganggu serapan dan translokasi kalsium ke buah. Gejala muncul pada ujung buah (blossom end) berupa bercak kecil basah yang berkembang menjadi bercak besar coklat kehitaman, cekung, dan kering seperti kulit (leathery). Serangan biasanya terjadi pada buah pertama yang terbentuk saat cuaca panas dan kering. Buah yang terserang tidak dapat dipulihkan. Pencegahan meliputi penyiraman teratur dan konsisten (drip irrigation ideal), mulsa untuk menjaga kelembaban tanah, tidak memberikan pupuk nitrogen berlebihan, dan aplikasi kalsium melalui daun (Ca foliar spray) saat awal pembentukan buah. Menjaga pH tanah 6.5 untuk optimalisasi serapan kalsium.',
      symptoms:
          'Bercak hitam/coklat cekung kering di ujung buah (blossom end), tekstur seperti kulit',
      causes:
          'Gangguan fisiologis: defisiensi kalsium lokal, penyiraman tidak teratur',
      affectedPlants: ['Tomat', 'Cabai', 'Paprika', 'Semangka', 'Terong'],
    ),
    Disease(
      id: 'tomato_target_spot',
      name: 'Target Spot',
      nameIndonesia: 'Bercak Target Tomat (Corynespora)',
      description:
          'Bercak Target adalah penyakit jamur yang semakin penting pada tomat di daerah tropis dan subtropis, disebabkan oleh Corynespora cassiicola yang memiliki kisaran inang sangat luas (>500 spesies tanaman). Gejala pada daun berupa bercak kecil berair yang berkembang menjadi bercak nekrotik bulat dengan pusat coklat muda hingga abu-abu dan tepi gelap. Ciri khas adalah pola lingkaran konsentris yang jelas seperti "target" atau "papan sasaran" di tengah bercak, mirip Early Blight namun biasanya lebih kecil. Bercak dapat menyatu menyebabkan hawar dan defoliasi. Pada buah, gejala berupa bercak cekung menonjol dengan pusat coklat pucat dan pola konsentris, menyebabkan buah tidak layak jual. Pada batang, lesi memanjang dapat melingkari dan mematikan cabang. Penyakit berkembang optimal pada kelembaban tinggi dengan daun basah 16-44 jam dan suhu 20-28°C. Pengendalian meliputi rotasi tanaman, sanitasi, sirkulasi udara baik, dan aplikasi fungisida azoxystrobin atau klorotalonil.',
      symptoms:
          'Bercak bulat dengan lingkaran konsentris jelas (pola target), pusat coklat muda, tepi gelap, defoliasi',
      causes: 'Jamur Corynespora cassiicola',
      affectedPlants: ['Tomat', 'Mentimun', 'Kedelai', 'Pepaya', 'Karet'],
    ),

    // ========== PENYAKIT BAWANG (47-54) ==========
    Disease(
      id: 'onion_purple_blotch',
      name: 'Purple Blotch',
      nameIndonesia: 'Bercak Ungu Bawang',
      description:
          'Bercak Ungu atau "Trotol" disebabkan oleh jamur Alternaria porri, merupakan penyakit utama pada bawang merah di Indonesia. Penyakit ini menyerang daun bawang, menimbulkan bercak kecil cekung berwarna putih yang kemudian membesar menjadi oval dengan pusat ungu kemerahan dikelilingi zona kuning. Pada kondisi lembab, permukaan bercak ditutupi spora berwarna coklat gelap. Bercak yang meluas menyebabkan daun patah rebah (patah leher) dan mengering, sehingga proses pembentukan umbi terganggu dan ukuran umbi mengecil. Serangan berat dapat menurunkan hasil panen hingga 50%. Penyakit ini berkembang optimal pada suhu 25-30°C dengan kelembaban tinggi.',
      symptoms:
          'Bercak oval keunguan dengan pusat coklat, zona konsentris, daun patah dan mengering',
      causes: 'Jamur Alternaria porri',
      affectedPlants: ['Bawang Merah', 'Bawang Putih', 'Bawang Bombay'],
    ),
    Disease(
      id: 'onion_downy_mildew',
      name: 'Downy Mildew',
      nameIndonesia: 'Bulai Bawang',
      description:
          'Bulai atau Embun Bulu (Peronospora destructor) merupakan ancaman serius bagi petani bawang merah di Indonesia, terutama pada musim hujan dengan kelembaban tinggi. Gejala awal berupa daun yang mengerut, pucat kekuningan, hingga mengering menjadi putih. Pada kondisi udara lembab, daun menunjukkan bintik-bintik berwarna ungu dengan lapisan spora seperti tepung di permukaan bawah daun. Pada udara kering, daun menunjukkan bintik-bintik putih. Infeksi dapat menyebar ke umbi, menyebabkan umbi berwarna cokelat, membusuk, dan lapisan luarnya mengering serta berkerut. Tanaman rentan terserang pada usia 36 hari setelah tanam, terutama saat memasuki fase generatif. Pengendalian meliputi penanaman varietas toleran (Bauji, Bima), penyiraman pagi hari sebelum matahari muncul, dan aplikasi fungisida berbahan aktif klorotalonil, mankozeb, atau propineb.',
      symptoms:
          'Daun mengerut kekuningan, spora keunguan di bawah daun, daun rebah, umbi membusuk',
      causes: 'Jamur Peronospora destructor',
      affectedPlants: ['Bawang Merah', 'Bawang Putih'],
    ),
    Disease(
      id: 'onion_fusarium_basal_rot',
      name: 'Fusarium Basal Rot',
      nameIndonesia: 'Busuk Pangkal Bawang (Moler)',
      description:
          'Penyakit "Moler" atau Inul adalah penyakit devastatif pada bawang merah yang disebabkan oleh Fusarium oxysporum f.sp. cepae. Gejala paling khas adalah daun bawang melintir, memutar seperti spiral (meliur), dan menguning dari bagian ujung ke pangkal. Sistem perakaran membusuk dan lempeng dasar umbi (basal plate) menjadi lunak serta berwarna kecoklatan sampai merah muda. Tanaman mudah dicabut karena akarnya hancur. Saat umbi dibelah, terlihat pembuluh berwarna coklat kemerahan. Penyakit ini sering meledak saat suhu tanah meningkat (>27°C) dan pada tanah yang tergenang. Jamur dapat bertahan di tanah selama bertahun-tahun melalui klamidospora. Pengendalian meliputi rotasi tanaman minimal 4 tahun, penggunaan bibit sehat, dan perbaikan drainase.',
      symptoms:
          'Daun melintir (moler), akar coklat membusuk, pangkal umbi lunak kemerahan',
      causes: 'Jamur Fusarium oxysporum f.sp. cepae',
      affectedPlants: ['Bawang Merah', 'Bawang Putih'],
    ),
    Disease(
      id: 'onion_anthracnose',
      name: 'Anthracnose Twister',
      nameIndonesia: 'Antraknosa Bawang',
      description:
          'Antraknosa pada bawang, sering disebut penyakit "Otomatis" oleh petani karena kematian tanaman yang sangat cepat dan mendadak. Disebabkan oleh Colletotrichum gloeosporioides yang menyebar sangat cepat lewat percikan air hujan. Gejala awal berupa bercak putih kecil cekung di daun yang kemudian membentuk lesi memanjang berwarna coklat tua. Ciri khas adalah daun menjadi terpuntir dan bengkok tidak normal. Daun kemudian mengering dan mati mendadak dalam hitungan hari. Pada leher batang, serangan menyebabkan tanaman rebah total ("ampless") dan membusuk hingga ke umbi. Kondisi cuaca panas lembab (suhu 27-32°C, RH >80%) sangat mendukung perkembangan penyakit. Pengendalian meliputi menghindari penanaman saat musim hujan lebat, sanitasi kebun, dan aplikasi fungisida kontak secara preventif.',
      symptoms:
          'Daun terpuntir bengkok, bercak cekung memanjang, daun kering mendadak, tanaman rebah',
      causes: 'Jamur Colletotrichum gloeosporioides',
      affectedPlants: ['Bawang Merah', 'Bawang Daun'],
    ),
    Disease(
      id: 'onion_white_rot',
      name: 'White Rot',
      nameIndonesia: 'Busuk Putih Bawang',
      description:
          'Busuk Putih adalah salah satu penyakit paling destruktif dan sulit dikendalikan pada tanaman Allium (bawang-bawangan), disebabkan oleh jamur tanah Sclerotium cepivorum. Gejala awal berupa tanaman layu dan daun menguning dari ujung, diikuti kematian daun secara progresif. Saat tanaman dicabut, terlihat miselium putih halus seperti kapas menutupi pangkal umbi dan akar yang membusuk lunak. Ciri diagnostik adalah adanya sklerotia (struktur istirahat jamur) berupa butiran hitam bulat sebesar biji poppy (0.5-2mm) yang tersebar di permukaan umbi dan tanah sekitar. Bahaya utama penyakit ini adalah sklerotia dapat bertahan di tanah selama 10-40 tahun bahkan tanpa tanaman inang. Tidak ada varietas bawang yang tahan terhadap penyakit ini. Pengendalian meliputi penggunaan bibit bebas penyakit, rotasi tanaman minimal 6 tahun dengan tanaman bukan Allium, dan aplikasi fungisida tebuconazole atau iprodione pada saat tanam.',
      symptoms:
          'Miselium putih kapas di pangkal umbi, sklerotia hitam bulat kecil, akar busuk, daun kuning layu',
      causes: 'Jamur Sclerotium cepivorum',
      affectedPlants: [
        'Bawang Merah',
        'Bawang Putih',
        'Bawang Bombay',
        'Daun Bawang',
      ],
    ),
    Disease(
      id: 'onion_bacterial_soft_rot',
      name: 'Bacterial Soft Rot',
      nameIndonesia: 'Busuk Lunak Bakteri Bawang',
      description:
          'Busuk Lunak Bakteri adalah penyakit penting yang menyebabkan kerugian besar terutama saat penyimpanan umbi bawang, disebabkan oleh bakteri Pectobacterium carotovorum (sebelumnya Erwinia carotovora). Infeksi biasanya dimulai melalui luka mekanis atau bekas serangan hama. Gejala khas adalah satu atau beberapa lapis umbi (sisik) menjadi lunak, berair, dan berwarna kuning pucat hingga kecoklatan. Jaringan yang terinfeksi berubah menjadi massa berlendir dengan bau busuk yang sangat menyengat (seperti belerang). Jika umbi ditekan, cairan berbau busuk akan keluar dari leher umbi. Uniknya, pembusukan tidak selalu menyebar ke sisik sebelahnya sehingga bisa ditemukan sisik busuk berdampingan dengan sisik sehat. Di lapangan, daun muda tampak pucat dan layu. Bakteri ini tidak bertahan lama di tanah, melainkan menyebar melalui air irigasi, luka, dan serangga. Pengendalian meliputi pengeringan umbi sempurna sebelum penyimpanan (kadar air leher <15%), tidak memanen saat hujan, penyimpanan pada suhu 0-3°C dengan RH 65-70%, dan menghindari kerusakan mekanis.',
      symptoms:
          'Umbi lunak berair, bau busuk menyengat, cairan dari leher umbi, lapisan dalam berlendir',
      causes: 'Bakteri Pectobacterium carotovorum (syn. Erwinia carotovora)',
      affectedPlants: ['Bawang Merah', 'Bawang Putih', 'Bawang Bombay'],
    ),
    Disease(
      id: 'onion_stemphylium_blight',
      name: 'Stemphylium Blight',
      nameIndonesia: 'Hawar Stemphylium Bawang',
      description:
          'Hawar Stemphylium (Stemphylium vesicarium) adalah penyakit penting pada bawang di daerah beriklim panas dan lembab. Penyakit ini sering muncul bersamaan dengan Bercak Ungu (Alternaria porri), bahkan kedua patogen dapat ditemukan dalam satu lesi yang sama. Gejala awal berupa bercak kecil basah berwarna putih kekuningan pada daun, sering muncul di sisi daun yang menghadap arah angin. Bercak kemudian membesar dan menyatu membentuk lesi memanjang berwarna coklat muda hingga tan dengan zona konsentris. Seiring perkembangan penyakit, bagian tengah lesi berubah menjadi coklat zaitun gelap hingga hitam karena produksi spora jamur yang melimpah. Pada tahap lanjut, terjadi nekrosis besar yang dapat melingkari dan mematikan daun atau tangkai bunga. Kondisi optimal untuk perkembangan penyakit adalah suhu 21-30°C dan kelembaban relatif 80-90% dengan daun yang basah dalam waktu lama. Pengendalian meliputi memperbaiki sirkulasi udara, menghindari irigasi overhead, dan aplikasi fungisida mankozeb atau klorotalonil secara bergantian.',
      symptoms:
          'Bercak basah kuning kecoklatan, meluas jadi hawar coklat-hitam, daun mengering dari ujung',
      causes: 'Jamur Stemphylium vesicarium',
      affectedPlants: ['Bawang Merah', 'Bawang Putih', 'Bawang Bombay'],
    ),
    Disease(
      id: 'onion_leaf_blight',
      name: 'Botrytis Leaf Blight',
      nameIndonesia: 'Hawar Daun Botrytis Bawang',
      description:
          'Hawar Daun Botrytis disebabkan oleh jamur Botrytis squamosa dan merupakan penyakit penting di daerah dengan iklim sejuk dan lembab. Gejala awal berupa bintik-bintik kecil berwarna putih keperakan (silver-white spots) yang tersebar di permukaan daun, ukurannya ±1-5mm. Bintik ini disebut "straw fleck" karena menyerupai serpihan jerami. Pada serangan berat, bintik-bintik menyatu dan menyebabkan hawar (blighting), daun mengering dan mati. Berbeda dengan Bercak Ungu yang cekung berwarna ungu, lesi Botrytis berwarna putih-jerami dan tidak cekung. Di pagi hari yang lembab, terlihat spora abu-abu pada permukaan daun yang terinfeksi. Penyakit berkembang optimal pada suhu 15-20°C dengan kelembaban tinggi (>85%) dan curah hujan yang sering. Pengendalian meliputi menghindari penanaman terlalu rapat, memperbaiki drainase, rotasi tanaman, dan aplikasi fungisida iprodione atau vinclozolin saat kondisi cuaca mendukung penyakit.',
      symptoms:
          'Bintik putih kecil seperti jerami, meluas menjadi hawar, daun kering mengering',
      causes: 'Jamur Botrytis squamosa',
      affectedPlants: ['Bawang Merah', 'Bawang Bombay', 'Daun Bawang'],
    ),

    // ========== PENYAKIT KEDELAI (55-62) ==========
    Disease(
      id: 'soybean_rust',
      name: 'Asian Soybean Rust',
      nameIndonesia: 'Karat Kedelai',
      description:
          'Karat Kedelai disebabkan oleh jamur Phakopsora pachyrhizi merupakan salah satu penyakit paling merusak pada kedelai di Indonesia, dapat menyebabkan kehilangan hasil hingga 90% pada serangan berat. Gejala awal berupa bercak klorotik (kekuningan) kecil tidak beraturan pada permukaan atas daun tua di bagian bawah kanopi. Bercak kemudian berubah menjadi coklat atau coklat tua (tan). Ciri diagnostik utama adalah pustula (uredinia) berbentuk kerucut kecil berisi spora berwarna seperti karat besi kecoklatan yang terbentuk terutama di permukaan bawah daun. Spora mudah terlepas dan menyebar melalui angin. Pada serangan parah, daun menguning, mengering, dan gugur prematur (defoliasi dini), mengurangi fase pengisian polong sehingga biji keriput dan ringan. Penyakit berkembang optimal pada suhu 15-28°C dengan kelembaban tinggi dan curah hujan sering. Pengendalian meliputi penanaman varietas tahan, penggunaan fungisida nabati (minyak cengkih) atau kimia (mankozeb, triazol), menanam di awal musim kemarau, dan aplikasi agen hayati (Bacillus sp., Verticillium sp.).',
      symptoms:
          'Pustula coklat keemasan seperti karat di bawah daun, bercak kuning di atas, defoliasi dini',
      causes: 'Jamur Phakopsora pachyrhizi',
      affectedPlants: ['Kedelai'],
    ),
    Disease(
      id: 'soybean_anthracnose',
      name: 'Anthracnose',
      nameIndonesia: 'Antraknosa Kedelai',
      description:
          'Antraknosa Kedelai disebabkan oleh jamur Colletotrichum truncatum dan merupakan penyakit penting yang menyerang polong, batang, dan biji kedelai, terutama saat musim hujan dengan kelembaban tinggi. Gejala pada batang dan tangkai daun berupa bercak cokelat gelap hingga hitam yang tidak beraturan. Pada polong, muncul bercak coklat cekung yang pada serangan lanjut menyebabkan polong retak atau pecah dan biji di dalamnya busuk. Biji yang terinfeksi tampak keriput, berwarna coklat hingga hitam, dan sering berkembang menjadi benih mati (tidak berkecambah). Jamur dapat menyerang sepanjang fase pertumbuhan mulai dari bibit hingga polong matang. Sumber inokulum utama adalah benih terinfeksi dan sisa tanaman. Kondisi hangat lembab (25-30°C, RH >80%) sangat mendukung perkembangan penyakit. Pengendalian meliputi penggunaan benih sehat bersertifikat, perlakuan benih dengan fungisida (mankozeb, thiram), rotasi tanaman minimal 2 tahun, sanitasi sisa tanaman, dan penyemprotan fungisida saat kondisi cuaca mendukung.',
      symptoms:
          'Bercak coklat-hitam pada polong dan batang, polong retak, biji keriput berwarna gelap',
      causes: 'Jamur Colletotrichum truncatum',
      affectedPlants: ['Kedelai'],
    ),
    Disease(
      id: 'soybean_mosaic',
      name: 'Soybean Mosaic Virus',
      nameIndonesia: 'Virus Mosaik Kedelai',
      description:
          'Virus Mosaik Kedelai (Soybean Mosaic Virus/SMV) adalah penyakit virus utama pada kedelai yang ditularkan oleh kutu daun (Aphis glycines) secara non-persisten dan melalui benih terinfeksi. Gejala bervariasi tergantung strain virus, varietas, dan kondisi lingkungan. Gejala umum meliputi pola mosaik (belang hijau muda dan hijau tua tidak teratur) pada daun muda yang sedang tumbuh aktif. Daun juga tampak berkerut (crinkled) terutama di sepanjang tulang daun, menggulung ke bawah (cupping), dan tampak kaku. Tanaman yang terinfeksi dini tumbuh kerdil dengan internoda pendek. Jumlah polong berkurang dan ukurannya mengecil. Biji yang dihasilkan menunjukkan belang coklat pada kulit biji (mottling), menurunkan kualitas dan harga jual. Gejala paling jelas terlihat pada cuaca dingin (18-22°C). Tidak ada obat untuk tanaman terinfeksi. Pengendalian meliputi penggunaan benih bebas virus bersertifikat, varietas tahan/toleran, penanaman lebih awal, pengendalian kutu daun dengan insektisida, dan eliminasi gulma inang di sekitar lahan.',
      symptoms:
          'Daun mosaik hijau muda-tua, berkerut menggulung ke bawah, tanaman kerdil, biji belang coklat (mottled)',
      causes: 'Soybean Mosaic Virus (SMV), vektor: Aphis glycines',
      affectedPlants: ['Kedelai'],
    ),
    Disease(
      id: 'soybean_bacterial_pustule',
      name: 'Bacterial Pustule',
      nameIndonesia: 'Pustul Bakteri Kedelai',
      description:
          'Pustul Bakteri disebabkan oleh bakteri Xanthomonas axonopodis pv. glycines dan merupakan penyakit bakteri yang umum pada kedelai di daerah tropis hangat. Gejala khas berupa bercak kecil berwarna hijau pucat kekuningan dengan pusat yang sedikit menonjol (pustul) pada kedua permukaan daun. Pustul berisi massa bakteri dan sering pecah mengeluarkan eksudat. Bercak biasanya dikelilingi oleh halo kuning yang jelas (chlorotic halo). Pada serangan lanjut, bercak-bercak dapat menyatu membentuk area nekrotik besar berwarna coklat kemerahan dan menyebabkan robekan pada daun (tattered appearance). Bakteri menyebar melalui percikan air hujan, angin, dan benih terinfeksi. Kondisi hangat (30-33°C) dengan kelembaban tinggi sangat mendukung perkembangan penyakit. Pengendalian meliputi penggunaan varietas tahan, benih bebas penyakit, rotasi tanaman dengan non-kedelai selama 1-2 tahun, menghindari bekerja di lahan saat tanaman basah, dan aplikasi bakterisida berbasis tembaga pada serangan awal.',
      symptoms:
          'Bercak kecil dengan pustul menonjol di tengah, halo kuning, daun robek saat parah',
      causes: 'Bakteri Xanthomonas axonopodis pv. glycines',
      affectedPlants: ['Kedelai'],
    ),
    Disease(
      id: 'soybean_frogeye_leaf_spot',
      name: 'Frogeye Leaf Spot',
      nameIndonesia: 'Bercak Mata Katak Kedelai',
      description:
          'Bercak Mata Katak disebabkan oleh jamur Cercospora sojina (atau C. kikuchii untuk Purple Seed Stain). Penyakit ini dinamakan "mata katak" karena tampilan bercaknya yang khas. Gejala pada daun berupa bercak bulat hingga bersudut dengan diameter 1-5 mm. Ciri diagnostik adalah bagian pusat bercak berwarna abu-abu muda hingga coklat terang (seperti pupil mata) yang dikelilingi oleh tepi berwarna coklat tua hingga merah keunguan yang jelas (seperti iris mata). Bercak dapat menyerang daun, batang, polong, dan biji. Pada biji, infeksi menyebabkan bercak ungu keabu-abuan hingga gelap yang disebut Purple Seed Stain, menurunkan kualitas benih. Jamur bertahan pada sisa tanaman dan benih terinfeksi. Penyakit berkembang optimal pada suhu hangat (25-30°C) dengan kelembaban tinggi. Pengendalian meliputi penanaman varietas tahan, rotasi tanaman minimal 2 tahun, pengolahan tanah untuk membenamkan sisa tanaman, penggunaan benih bebas penyakit dengan perlakuan fungisida, dan aplikasi fungisida berbahan aktif benzimidazol atau strobilurin.',
      symptoms:
          'Bercak bundar dengan pusat abu-abu terang (mata) dan tepi coklat-ungu gelap (iris), Purple Seed Stain pada biji',
      causes: 'Jamur Cercospora sojina, C. kikuchii',
      affectedPlants: ['Kedelai'],
    ),
    Disease(
      id: 'soybean_charcoal_rot',
      name: 'Charcoal Rot',
      nameIndonesia: 'Busuk Arang Kedelai',
      description:
          'Busuk Arang disebabkan oleh jamur tanah Macrophomina phaseolina dan merupakan penyakit yang sangat parah terutama saat kondisi kekeringan dan suhu tinggi (>30°C). Jamur ini memiliki kisaran inang sangat luas (>500 spesies tanaman). Gejala biasanya muncul menjelang fase pengisian polong ketika tanaman mengalami stres air. Daun bagian atas tampak layu dan keabu-abuan, kemudian menguning dan mati. Ciri diagnostik yang sangat khas adalah ketika epidermis batang bagian bawah dikupas, terlihat jaringan di bawahnya berwarna abu-abu keperakan dengan banyak titik-titik hitam kecil sebesar butiran pasir (mikrosklerotia) yang tampak seperti debu arang. Akar dan pangkal batang membusuk dan tanaman mudah tercabut. Pengendalian sulit karena jamur sangat persisten di tanah. Strategi meliputi menghindari stres air dengan irigasi yang cukup, tidak menanam terlalu rapat, rotasi dengan tanaman non-inang (padi), dan penggunaan varietas dengan perakaran kuat.',
      symptoms:
          'Batang abu-abu dengan banyak mikrosklerotia hitam seperti arang, tanaman layu saat kekeringan, akar busuk',
      causes: 'Jamur Macrophomina phaseolina',
      affectedPlants: ['Kedelai', 'Jagung', 'Kacang Tanah', 'Sorgum'],
    ),
    Disease(
      id: 'soybean_sudden_death',
      name: 'Sudden Death Syndrome',
      nameIndonesia: 'Sindrom Mati Mendadak Kedelai',
      description:
          'Sindrom Mati Mendadak (SDS) disebabkan oleh jamur tanah Fusarium virguliforme (sebelumnya F. solani f.sp. glycines). Penyakit ini dinamakan demikian karena gejala daun muncul secara tiba-tiba menjelang fase pengisian polong. Gejala daun sangat khas: klorosis (penguningan) di antara tulang daun (interveinal chlorosis) yang kemudian berkembang menjadi nekrosis (kematian jaringan) coklat, sementara tulang daun tetap hijau. Daun yang terserang kemudian gugur prematur, namun tangkai daun tetap menempel di batang. Akar tunggang menunjukkan pembusukan coklat, namun berbeda dengan Busuk Arang, bagian empulur batang tetap putih (tidak ada mikrosklerotia). Penyakit berkembang pada kondisi tanah basah, suhu sejuk saat awal musim tanam, dan kemudian diperparah oleh kekeringan saat pengisian polong. Pengendalian meliputi penggunaan varietas toleran, perbaikan drainase, menghindari tanam terlalu dini pada tanah dingin dan basah, dan rotasi tanaman.',
      symptoms:
          'Klorosis intervenal (kuning di antara tulang daun), nekrosis coklat, daun gugur tangkai menempel, akar busuk coklat',
      causes: 'Jamur Fusarium virguliforme',
      affectedPlants: ['Kedelai'],
    ),
    Disease(
      id: 'soybean_downy_mildew',
      name: 'Downy Mildew',
      nameIndonesia: 'Bulai Kedelai',
      description:
          'Bulai Kedelai disebabkan oleh jamur Peronospora manshurica dan umumnya menyerang tanaman kedelai muda hingga menengah, terutama saat musim hujan dengan kelembaban tinggi. Sumber inokulum utama adalah benih terinfeksi (seed-borne) dan sisa tanaman. Gejala pada daun muda berupa bercak tidak beraturan berwarna kuning pucat hingga hijau pucat di permukaan atas daun. Di permukaan bawah daun pada lokasi yang sama, terlihat pertumbuhan spora jamur berwarna abu-abu keunguan seperti beludru atau tepung halus (tanda penyakit). Pada biji, infeksi menyebabkan lapisan putih keabu-abuan (encrustment) yang tidak bisa dihilangkan dan merupakan sumber inokulum untuk musim berikutnya. Penyakit berkembang optimal pada suhu sejuk (20-22°C) dengan embun pagi atau hujan. Pengendalian meliputi penggunaan benih sehat bebas penyakit, varietas toleran, perlakuan benih dengan fungisida sistemik (metalaksil), dan aplikasi fungisida saat kondisi cuaca mendukung.',
      symptoms:
          'Bercak kuning pucat di atas daun, spora abu-abu keunguan seperti tepung di bawah daun, biji berlapis putih',
      causes: 'Jamur Peronospora manshurica',
      affectedPlants: ['Kedelai'],
    ),

    // ========== PENYAKIT KACANG-KACANGAN (63-68) ==========
    Disease(
      id: 'peanut_leaf_spot',
      name: 'Cercospora Leaf Spot',
      nameIndonesia: 'Bercak Daun Kacang Tanah',
      description:
          'Bercak Daun Cercospora adalah penyakit daun utama pada kacang tanah yang disebabkan oleh dua spesies jamur: Cercospora arachidicola (Bercak Daun Awal) dan Cercosporidium personatum (Bercak Daun Akhir/Lambat). Bercak Daun Awal muncul 3-4 minggu setelah tanam dengan gejala bercak bulat berwarna coklat muda dikelilingi halo kuning yang jelas di permukaan atas daun, spora terlihat di permukaan atas. Bercak Daun Akhir muncul 6-8 minggu setelah tanam dengan bercak berwarna coklat gelap hingga kehitaman, hampir tanpa halo kuning, spora di permukaan bawah daun. Kedua penyakit sering muncul bersamaan. Pada serangan parah, bercak menyebar ke batang dan tangkai, daun menguning dan gugur prematur (defoliasi) menyebabkan tanaman gundul. Defoliasi berat dapat menurunkan hasil hingga 60%. Jamur bertahan pada sisa tanaman. Pengendalian meliputi rotasi tanaman minimal 2 tahun, sanitasi sisa tanaman, penggunaan varietas toleran, jarak tanam yang tidak terlalu rapat, dan aplikasi fungisida mankozeb atau klorotalonil secara preventif.',
      symptoms:
          'Bercak coklat bulat dengan halo kuning (awal), bercak hitam tanpa halo (akhir), defoliasi parah',
      causes:
          'Jamur Cercospora arachidicola (awal), Cercosporidium personatum (akhir)',
      affectedPlants: ['Kacang Tanah'],
    ),
    Disease(
      id: 'peanut_rust',
      name: 'Peanut Rust',
      nameIndonesia: 'Karat Kacang Tanah',
      description:
          'Karat Kacang Tanah disebabkan oleh jamur Puccinia arachidis dan merupakan penyakit penting terutama saat musim hujan dengan kelembaban tinggi. Gejala khas berupa pustula (bintil kecil) berwarna oranye hingga coklat kemerahan seperti karat besi yang tersusun acak terutama di permukaan bawah daun. Jika pustula pecah, akan mengeluarkan serbuk spora (uredospora) yang mudah terbang terbawa angin. Berbeda dengan bercak daun Cercospora yang berwarna gelap, pustula karat berwarna terang keoranyean dan menonjol. Daun yang terserang parah akan menguning dan mengering, namun uniknya daun cenderung tetap menempel di tangkai dan tidak mudah gugur seperti pada Cercospora. Serangan berat dapat menurunkan hasil hingga 60%, mempengaruhi jumlah polong, bobot biji, dan kandungan minyak. Penyakit berkembang optimal pada suhu 20-25°C dengan embun malam yang sering. Pengendalian meliputi penanaman varietas tahan (Kelinci, Jerapah), tanam di awal musim kemarau, dan aplikasi fungisida triazol atau mankozeb.',
      symptoms:
          'Pustula oranye-coklat kemerahan di bawah daun, spora seperti tepung karat, daun kering tapi tidak gugur',
      causes: 'Jamur Puccinia arachidis',
      affectedPlants: ['Kacang Tanah'],
    ),
    Disease(
      id: 'peanut_bacterial_wilt',
      name: 'Bacterial Wilt',
      nameIndonesia: 'Layu Bakteri Kacang Tanah',
      description:
          'Layu Bakteri pada kacang tanah disebabkan oleh Ralstonia solanacearum, bakteri yang sama yang menyerang tomat, cabai, dan pisang. Penyakit ini sangat merusak karena bakteri dapat bertahan lama di tanah. Gejala awal berupa layu satu atau beberapa cabang saat siang hari yang pulih di malam hari. Beberapa hari kemudian, seluruh tanaman layu permanen dan mati dengan cepat. Berbeda dengan layu Fusarium, daun tanaman yang terserang layu bakteri tidak kuning sebelum layu. Jika batang dipotong dan dicelupkan ke air jernih, terlihat aliran massa bakteri (bacterial ooze) berwarna putih susu keluar dari pembuluh. Akar membusuk berwarna coklat dan berbau. Bakteri menyebar melalui tanah, air irigasi, dan alat pertanian. Kondisi hangat lembab (>25°C) sangat mendukung. Pengendalian sulit karena tidak ada fungisida efektif. Strategi meliputi penggunaan varietas toleran, rotasi tanaman minimal 3-4 tahun dengan tanaman non-inang (padi sawah), perbaikan drainase, sanitasi ketat, dan aplikasi agen hayati (Trichoderma, Pseudomonas fluorescens).',
      symptoms:
          'Layu mendadak tanpa menguning, batang dan akar berlendir busuk, bacterial ooze dari potongan batang',
      causes: 'Bakteri Ralstonia solanacearum',
      affectedPlants: ['Kacang Tanah'],
    ),
    Disease(
      id: 'peanut_stem_rot',
      name: 'Sclerotium Stem Rot',
      nameIndonesia: 'Busuk Batang Sclerotium Kacang Tanah',
      description:
          'Busuk Batang Sclerotium disebabkan oleh jamur tanah Sclerotium rolfsii dan merupakan salah satu penyakit paling penting pada kacang tanah di Indonesia, dapat menyebabkan kehilangan hasil 50-80% pada serangan berat. Penyakit dapat menyerang dari fase pra-kecambah hingga menjelang panen, dengan fase kritis pada awal tumbuh. Gejala awal berupa lesi (bercak) basah berair berwarna coklat muda pada pangkal batang di dekat permukaan tanah yang berkembang menjadi coklat tua. Tanaman layu karena transportasi air dan nutrisi terganggu. Ciri diagnostik utama adalah munculnya miselium (benang jamur) berwarna putih seperti kapas yang menyebar di permukaan tanah dan pangkal batang terinfeksi. Kemudian terbentuk sklerotia berupa butiran kecil bulat berwarna kecoklatan hingga coklat tua yang keras seperti biji sawi. Jamur dapat menyerang dan membusukkan polong juga. Pengendalian meliputi pengolahan tanah dalam, rotasi dengan tanaman non-inang (padi), jarak tanam cukup, aplikasi Trichoderma sp., dan tidak menggunakan kompos yang mengandung material terinfeksi.',
      symptoms:
          'Lesi coklat basah pada pangkal batang, miselium putih kapas, sklerotia bulat coklat, tanaman layu mati',
      causes: 'Jamur Sclerotium rolfsii',
      affectedPlants: ['Kacang Tanah', 'Kedelai', 'Tomat'],
    ),
    Disease(
      id: 'mungbean_powdery_mildew',
      name: 'Powdery Mildew',
      nameIndonesia: 'Embun Tepung Kacang Hijau',
      description:
          'Embun Tepung pada kacang hijau dan kacang panjang disebabkan oleh jamur Erysiphe polygoni dan merupakan penyakit penting terutama di musim kemarau dengan kelembaban rendah-sedang dan suhu hangat. Berbeda dengan kebanyakan penyakit jamur yang suka kondisi basah, embun tepung justru berkembang baik pada kondisi kering dengan embun malam. Gejala khas berupa lapisan atau bercak tepung putih keabu-abuan yang menutupi permukaan daun, batang, dan polong. Lapisan ini terdiri dari miselium dan spora jamur. Pada serangan ringan, tepung muncul di permukaan atas daun tua di bagian bawah tanaman. Pada serangan berat, tepung menutupi hampir seluruh permukaan daun yang kemudian menguning, mengering, dan gugur. Defoliasi mengurangi pembentukan polong dan pengisian biji. Spora menyebar melalui angin. Penyakit berkembang optimal pada suhu 25-30°C dan kelembaban rendah (<80%). Pengendalian meliputi penggunaan varietas tahan/toleran, jarak tanam yang cukup untuk sirkulasi udara, dan aplikasi fungisida berbahan aktif sulfur atau triazol.',
      symptoms:
          'Lapisan tepung putih keabu-abuan di permukaan daun dan polong, daun menguning mengering',
      causes: 'Jamur Erysiphe polygoni',
      affectedPlants: ['Kacang Hijau', 'Kacang Panjang'],
    ),
    Disease(
      id: 'mungbean_cercospora_leaf_spot',
      name: 'Cercospora Leaf Spot',
      nameIndonesia: 'Bercak Daun Cercospora Kacang Hijau',
      description:
          'Bercak Daun Cercospora pada kacang hijau disebabkan oleh jamur Cercospora canescens dan merupakan penyakit daun penting terutama saat musim hujan dengan kelembaban tinggi. Gejala berupa bercak bulat hingga tidak teratur berwarna coklat keabu-abuan dengan tepi lebih gelap (coklat tua hingga merah kecoklatan). Pada kondisi lembab, terlihat spora keabu-abuan di permukaan bercak. Bercak dapat muncul pada daun, tangkai daun, batang, dan polong. Pada serangan berat, bercak-bercak menyatu menyebabkan area nekrotik besar dan daun menguning lalu gugur (defoliasi). Defoliasi mengurangi kemampuan fotosintesis dan berakibat pada penurunan jumlah dan ukuran polong. Jamur bertahan pada sisa tanaman dan benih terinfeksi. Penyakit berkembang optimal pada suhu hangat (25-30°C) dengan kelembaban tinggi dan hujan sering. Pengendalian meliputi rotasi tanaman, sanitasi sisa tanaman, penggunaan benih sehat, jarak tanam yang cukup untuk sirkulasi udara, dan aplikasi fungisida mankozeb atau klorotalonil saat gejala awal terlihat.',
      symptoms:
          'Bercak coklat keabu-abuan dengan tepi gelap kemerahan, daun menguning dan gugur',
      causes: 'Jamur Cercospora canescens',
      affectedPlants: ['Kacang Hijau'],
    ),
    Disease(
      id: 'longbean_rust',
      name: 'Long Bean Rust',
      nameIndonesia: 'Karat Kacang Panjang',
      description:
          'Karat Kacang Panjang disebabkan oleh jamur Uromyces appendiculatus dan merupakan penyakit umum pada kacang panjang dan kacang buncis terutama saat musim hujan. Penyakit ini relatif mudah dikenali dari pustula (bintil) karat yang khas. Gejala berupa pustula kecil berwarna coklat kemerahan hingga coklat tua yang tersebar terutama di permukaan bawah daun, namun juga bisa di permukaan atas, batang, dan polong. Pustula tampak menonjol dan jika disentuh, spora seperti tepung karat akan menempel di jari. Pada serangan parah, daun menguning, mengering, dan dapat gugur. Infeksi polong menyebabkan bercak coklat yang menurunkan kualitas dan penampilan. Spora menyebar melalui angin dan percikan air. Penyakit berkembang optimal pada suhu 17-27°C dengan kelembaban tinggi dan kondisi daun basah. Pengendalian meliputi penggunaan varietas tahan, menghindari penanaman terlalu rapat, menghindari irigasi overhead, rotasi tanaman, sanitasi, dan aplikasi fungisida berbahan aktif triazol atau mankozeb pada serangan awal.',
      symptoms:
          'Pustula coklat kemerahan seperti karat terutama di bawah daun, spora tepung, daun menguning',
      causes: 'Jamur Uromyces appendiculatus',
      affectedPlants: ['Kacang Panjang', 'Buncis'],
    ),

    // ========== PENYAKIT BUAH-BUAHAN (69-76) ==========
    Disease(
      id: 'banana_fusarium_wilt',
      name: 'Fusarium Wilt (Panama Disease)',
      nameIndonesia: 'Layu Fusarium Pisang (Penyakit Panama)',
      description:
          'Layu Fusarium atau Penyakit Panama adalah salah satu penyakit paling merusak dan ditakuti pada pisang di seluruh dunia, disebabkan oleh jamur tanah Fusarium oxysporum f.sp. cubense (FOC). Jamur menginfeksi akar dan menyumbat pembuluh xylem di dalam bonggol, mengganggu transportasi air dan nutrisi. Gejala awal berupa daun tua menguning dimulai dari tepian daun, kemudian menguning menyebar ke seluruh helaian dan menjalar ke daun yang lebih muda. Pelepah daun layu dan menggantung. Ciri diagnostik penting adalah batang semu (pseudostem) pecah membujur beberapa sentimeter di atas tanah, bahkan pada anakan muda. Jika bonggol atau batang dipotong melintang, terlihat perubahan warna pembuluh menjadi kuning kecoklatan hingga merah-coklat tua (diskolorasi vaskular). Buah tidak berkembang normal atau kecil dan matang prematur. Jamur dapat bertahan di tanah selama 20-30 tahun melalui klamidospora. Tidak ada fungisida efektif setelah infeksi. Pengendalian meliputi penggunaan bibit kultur jaringan bebas penyakit, varietas tahan (Pisang Kepok, Tanduk), sanitasi ketat (eradikasi dan bakar tanaman sakit), aplikasi Trichoderma sp., dan karantina.',
      symptoms:
          'Daun menguning dari tepi, pelepah layu menggantung, batang semu pecah membujur, pembuluh bonggol merah-coklat',
      causes: 'Jamur Fusarium oxysporum f.sp. cubense (FOC)',
      affectedPlants: ['Pisang'],
    ),
    Disease(
      id: 'banana_sigatoka',
      name: 'Black Sigatoka',
      nameIndonesia: 'Sigatoka Hitam Pisang (Bercak Daun Hitam)',
      description:
          'Sigatoka Hitam atau Bercak Daun Hitam adalah penyakit daun paling serius pada pisang di seluruh dunia, disebabkan oleh jamur Mycosphaerella fijiensis (anamorph: Pseudocercospora fijiensis). Penyakit ini lebih destruktif dibanding Sigatoka Kuning (M. musicola). Gejala awal berupa bintik-bintik kecil memanjang berwarna coklat kemerahan sejajar tulang daun di permukaan bawah daun. Bintik berkembang menjadi bercak memanjang dengan pusat yang mengering berwarna abu-abu kecoklatan (nekrotik) dikelilingi tepi coklat gelap hingga hitam dan sering dengan halo kuning cerah. Pada serangan parah, bercak menyatu menyebabkan hawar luas, daun mengering dan mati dengan cepat. Kehilangan daun fungsional mengurangi fotosintesis sehingga tandan buah kecil, buah tidak terisi penuh, dan matang prematur. Bahkan buah sehat sering menunjukkan bintik-bintik hitam di kulit. Kondisi hangat lembab (25-29°C, RH tinggi) sangat mendukung. Pengendalian meliputi pemangkasan daun terinfeksi dan dibakar, pengaturan jarak tanam tidak rapat, drainase baik, pemupukan berimbang, dan aplikasi fungisida sistemik (propikonazol, mankozeb) secara teratur.',
      symptoms:
          'Bercak memanjang coklat-hitam dengan pusat abu-abu dan halo kuning, daun mengering, buah kecil prematur',
      causes:
          'Jamur Mycosphaerella fijiensis (syn. Pseudocercospora fijiensis)',
      affectedPlants: ['Pisang'],
    ),
    Disease(
      id: 'banana_bunchy_top',
      name: 'Bunchy Top',
      nameIndonesia: 'Kerdil Pisang (Pucuk Bergerombol)',
      description:
          'Penyakit Kerdil Pisang atau Pucuk Bergerombol (Bunchy Top) adalah penyakit virus paling serius pada pisang di Asia dan Australia, disebabkan oleh Banana Bunchy Top Virus (BBTV). Virus ditularkan secara persisten oleh serangga vektor kutu daun pisang (Pentalonia nigronervosa) dan melalui bibit vegetatif terinfeksi. Gejala paling khas adalah pertumbuhan tanaman sangat kerdil (stunted) dengan daun-daun muda mengumpul di pucuk membentuk kumpulan padat seperti roset (bunchy top). Daun-daun lebih tegak dari normal, lebih pendek dan sempit dengan tangkai daun yang memendek, dan tepi daun menguning serta rapuh. Ciri diagnostik lain adalah garis-garis hijau tua sempit yang terputus-putus (dot-dash pattern) sejajar tulang daun, terutama terlihat jelas di pangkal daun muda. Juga terlihat vein clearing (tulang daun jernih). Tanaman yang terinfeksi tidak menghasilkan tandan buah atau buah sangat kecil dan cacat. Tanaman tidak dapat pulih. Pengendalian utama adalah penggunaan bibit bebas virus (kultur jaringan), eradikasi dan pemusnahan rumpun terinfeksi, pengendalian vektor kutu daun dengan insektisida, dan pengamatan rutin.',
      symptoms:
          'Daun mengumpul di pucuk (rosette), kerdil, daun sempit tegak tepi kuning, garis hijau tua terputus (dot-dash)',
      causes: 'Banana Bunchy Top Virus (BBTV), vektor: Pentalonia nigronervosa',
      affectedPlants: ['Pisang'],
    ),
    Disease(
      id: 'banana_moko',
      name: 'Moko Disease (Blood Disease)',
      nameIndonesia: 'Penyakit Moko (Penyakit Darah Pisang)',
      description:
          'Penyakit Moko atau Penyakit Darah Pisang adalah penyakit bakteri yang sangat merusak pada pisang di Indonesia dan Asia Tenggara, disebabkan oleh bakteri Ralstonia syzygii subsp. celebesensis (sebelumnya Ralstonia solanacearum Blood Disease Bacterium/BDB). Bakteri menyerang pembuluh batang melalui akar atau melalui bunga/jantung pisang yang dikunjungi serangga. Gejala pada daun berupa penguningan dan layu, dimulai dari daun muda atau tua tergantung titik masuk infeksi. Pelepah daun kehilangan kekuatan sehingga daun hijau menggantung (tidak patah). Ciri diagnostik utama adalah ketika bonggol atau batang dipotong melintang, terlihat perubahan warna pembuluh menjadi coklat kemerahan, dan sering keluar getah atau lendir berwarna kemerahan seperti darah. Jantung pisang juga mengering dan berwarna coklat. Buah yang terinfeksi mengerut, daging buah busuk berwarna coklat kemerahan dan berlendir, tidak layak konsumsi. Bakteri menyebar melalui serangga (terutama lalat dan lebah yang mengunjungi jantung), alat pertanian, dan bibit. Pengendalian meliputi pembungkusan jantung pisang dengan plastik segera setelah keluar, pemotongan jantung segera setelah sisir terakhir terbentuk, sterilisasi alat, eradikasi rumpun sakit, dan penggunaan bibit sehat.',
      symptoms:
          'Daun layu menggantung, pembuluh bonggol/batang coklat-merah darah, getah merah, buah busuk coklat berlendir',
      causes:
          'Bakteri Ralstonia syzygii subsp. celebesensis (Blood Disease Bacterium)',
      affectedPlants: ['Pisang'],
    ),
    Disease(
      id: 'mango_anthracnose',
      name: 'Mango Anthracnose',
      nameIndonesia: 'Antraknosa Mangga',
      description: 'Penyakit utama pada buah mangga.',
      symptoms: 'Bercak hitam pada buah, busuk buah, bunga rontok',
      causes: 'Jamur Colletotrichum gloeosporioides',
      affectedPlants: ['Mangga'],
    ),
    Disease(
      id: 'mango_powdery_mildew',
      name: 'Powdery Mildew',
      nameIndonesia: 'Embun Tepung Mangga',
      description: 'Penyakit yang menyerang bunga dan daun muda.',
      symptoms: 'Lapisan putih pada bunga dan daun muda, bunga gugur',
      causes: 'Jamur Oidium mangiferae',
      affectedPlants: ['Mangga'],
    ),
    Disease(
      id: 'papaya_ringspot',
      name: 'Papaya Ringspot',
      nameIndonesia: 'Bercak Cincin Pepaya',
      description: 'Penyakit virus utama pada pepaya.',
      symptoms:
          'Daun mosaik dan berkerut, bercak cincin pada buah, tanaman kerdil',
      causes: 'Papaya Ringspot Virus (PRSV)',
      affectedPlants: ['Pepaya'],
    ),
    Disease(
      id: 'watermelon_fusarium_wilt',
      name: 'Fusarium Wilt',
      nameIndonesia: 'Layu Fusarium Semangka',
      description: 'Penyakit layu serius pada semangka.',
      symptoms: 'Layu satu sisi, daun menguning, pembuluh coklat',
      causes: 'Jamur Fusarium oxysporum f.sp. niveum',
      affectedPlants: ['Semangka', 'Melon'],
    ),
    Disease(
      id: 'watermelon_anthracnose',
      name: 'Anthracnose',
      nameIndonesia: 'Antraknosa Semangka',
      description: 'Penyakit bercak yang menyerang daun dan buah.',
      symptoms: 'Bercak coklat pada daun, bercak cekung pada buah',
      causes: 'Jamur Colletotrichum orbiculare',
      affectedPlants: ['Semangka', 'Melon', 'Mentimun'],
    ),

    // ========== PENYAKIT SAYURAN LAIN (77-80) ==========
    Disease(
      id: 'cucumber_downy_mildew',
      name: 'Downy Mildew',
      nameIndonesia: 'Bulai Mentimun',
      description: 'Penyakit yang menyebar cepat saat lembab.',
      symptoms: 'Bercak kuning angular, spora keunguan di bawah daun',
      causes: 'Jamur Pseudoperonospora cubensis',
      affectedPlants: ['Mentimun', 'Melon', 'Semangka'],
    ),
    Disease(
      id: 'cucumber_powdery_mildew',
      name: 'Powdery Mildew',
      nameIndonesia: 'Embun Tepung Mentimun',
      description: 'Penyakit tepung putih yang sangat umum.',
      symptoms: 'Lapisan tepung putih pada daun, daun mengering',
      causes: 'Jamur Podosphaera xanthii',
      affectedPlants: ['Mentimun', 'Melon', 'Labu'],
    ),
    Disease(
      id: 'cabbage_black_rot',
      name: 'Black Rot',
      nameIndonesia: 'Busuk Hitam Kubis',
      description: 'Penyakit bakteri serius pada kubis.',
      symptoms: 'Bercak V dari tepi daun, pembuluh hitam, daun rontok',
      causes: 'Bakteri Xanthomonas campestris pv. campestris',
      affectedPlants: ['Kubis', 'Sawi', 'Brokoli'],
    ),
    Disease(
      id: 'cabbage_clubroot',
      name: 'Clubroot',
      nameIndonesia: 'Akar Gada Kubis',
      description: 'Penyakit yang menyebabkan akar membengkak.',
      symptoms: 'Akar membengkak seperti gada, tanaman layu saat panas',
      causes: 'Jamur Plasmodiophora brassicae',
      affectedPlants: ['Kubis', 'Sawi', 'Brokoli', 'Lobak'],
    ),
  ];

  // Get disease by ID
  static Disease? getById(String id) {
    try {
      return commonDiseases.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get diseases by plant
  static List<Disease> getByPlant(String plantName) {
    return commonDiseases
        .where(
          (d) => d.affectedPlants.any(
            (p) => p.toLowerCase().contains(plantName.toLowerCase()),
          ),
        )
        .toList();
  }

  // Search diseases
  static List<Disease> search(String query) {
    final lowerQuery = query.toLowerCase();
    return commonDiseases
        .where(
          (d) =>
              d.name.toLowerCase().contains(lowerQuery) ||
              d.nameIndonesia.toLowerCase().contains(lowerQuery) ||
              d.description.toLowerCase().contains(lowerQuery) ||
              d.symptoms.toLowerCase().contains(lowerQuery) ||
              d.causes.toLowerCase().contains(lowerQuery) ||
              d.affectedPlants.any((p) => p.toLowerCase().contains(lowerQuery)),
        )
        .toList();
  }

  // Get all unique plants
  static List<String> getAllPlants() {
    final plants = <String>{};
    for (final disease in commonDiseases) {
      plants.addAll(disease.affectedPlants);
    }
    return plants.toList()..sort();
  }

  // Get diseases count by plant
  static Map<String, int> getDiseasesCountByPlant() {
    final counts = <String, int>{};
    for (final plant in getAllPlants()) {
      counts[plant] = getByPlant(plant).length;
    }
    return counts;
  }
}
