class NTBRegions {
  /// Mapping: Kabupaten -> Kecamatan -> Kode adm4 (desa pertama di kecamatan)
  static const Map<String, Map<String, String>> regions = {
    // ==========================================
    // KOTA MATARAM (52.71)
    // ==========================================
    'Kota Mataram': {
      'Ampenan': '52.71.01.1004', // Ampenan Selatan
      'Mataram': '52.71.02.1001', // Pagesangan
      'Cakranegara': '52.71.03.1004', // Cakranegara Selatan
      'Sekarbela': '52.71.04.1001', // Karang Pule
      'Selaparang': '52.71.05.1001', // Mataram Barat
      'Sandubaya': '52.71.06.1001', // Dasan Cermen
    },

    // ==========================================
    // KAB. LOMBOK BARAT (52.01)
    // ==========================================
    'Lombok Barat': {
      'Gerung': '52.01.01.1001', // Gerung Utara
      'Kediri': '52.01.02.2001', // Kediri
      'Narmada': '52.01.03.2001', // Lembuak
      'Sekotong': '52.01.07.2001', // Sekotong Tengah
      'Labuapi': '52.01.08.2001', // Bengkel
      'Gunungsari': '52.01.09.2001', // Gunungsari
      'Lingsar': '52.01.12.2001', // Lingsar
      'Lembar': '52.01.13.2001', // Lembar
      'Batu Layar': '52.01.14.2001', // Batulayar
      'Kuripan': '52.01.15.2001', // Kuripan
    },

    // ==========================================
    // KAB. LOMBOK TENGAH (52.02)
    // ==========================================
    'Lombok Tengah': {
      'Praya': '52.02.01.1001', // Praya
      'Jonggat': '52.02.02.2001', // Barejulat
      'Batukliang': '52.02.03.2001', // Bujak
      'Pujut': '52.02.04.2001', // Sengkol
      'Praya Barat': '52.02.05.2001', // Bonder
      'Praya Timur': '52.02.06.2001', // Bilelando
      'Janapria': '52.02.07.2001', // Janapria
      'Kopang': '52.02.08.2001', // Kopang
      'Praya Tengah': '52.02.09.2001', // Pengadang
      'Pringgarata': '52.02.10.2001', // Pringgarata
      'Batukliang Utara': '52.02.11.2001', // Karang Sidemen
      'Praya Barat Daya': '52.02.12.2001', // Montong Sapah
    },

    // ==========================================
    // KAB. LOMBOK TIMUR (52.03)
    // ==========================================
    'Lombok Timur': {
      'Selong': '52.03.01.1001', // Selong
      'Labuhan Haji': '52.03.02.2001', // Labuhan Haji
      'Pringgasela': '52.03.03.2001', // Pringgasela
      'Aikmel': '52.03.04.2001', // Aikmel
      'Wanasaba': '52.03.05.2001', // Wanasaba
      'Sembalun': '52.03.06.2001', // Sembalun Bumbung
      'Pringgabaya': '52.03.07.2001', // Pringgabaya
      'Suela': '52.03.08.2001', // Suela
      'Sakra': '52.03.09.2001', // Sakra
      'Keruak': '52.03.10.2001', // Keruak
      'Jerowaru': '52.03.11.2001', // Jerowaru
      'Sakra Barat': '52.03.12.2001', // Sakra Barat
      'Sakra Timur': '52.03.13.2001', // Sakra Timur
      'Terara': '52.03.14.2001', // Terara
      'Montong Gading': '52.03.15.2001', // Montong Gading
      'Sikur': '52.03.16.2001', // Sikur
      'Masbagik': '52.03.17.2001', // Masbagik Selatan
      'Sukamulia': '52.03.18.2001', // Sukamulia
      'Suralaga': '52.03.19.2001', // Suralaga
      'Lenek': '52.03.20.2001', // Lenek
      'Labuhan Lombok': '52.03.21.2001', // Labuhan Lombok
    },

    // ==========================================
    // KAB. LOMBOK UTARA (52.08)
    // ==========================================
    'Lombok Utara': {
      'Tanjung': '52.08.01.2001', // Tanjung
      'Gangga': '52.08.02.2001', // Gangga
      'Kayangan': '52.08.03.2001', // Kayangan
      'Bayan': '52.08.04.2001', // Bayan
      'Pemenang': '52.08.05.2001', // Pemenang Barat
    },

    // ==========================================
    // KAB. SUMBAWA (52.04)
    // ==========================================
    'Sumbawa': {
      'Sumbawa': '52.04.01.1001', // Sumbawa
      'Labuhan Badas': '52.04.02.2001', // Labuhan Badas
      'Unter Iwes': '52.04.03.2001', // Kerekeh
      'Moyo Hilir': '52.04.04.2001', // Moyo Hilir
      'Moyo Utara': '52.04.05.2001', // Batu Tering
      'Lape': '52.04.06.2001', // Lape
      'Lopok': '52.04.07.2001', // Lopok
      'Plampang': '52.04.08.2001', // Plampang
      'Empang': '52.04.09.2001', // Empang
      'Alas': '52.04.10.2001', // Alas
      'Alas Barat': '52.04.11.2001', // Alas Barat
      'Buer': '52.04.12.2001', // Buer
      'Utan': '52.04.13.2001', // Utan
      'Rhee': '52.04.14.2001', // Rhee
      'Batulanteh': '52.04.15.2001', // Batulanteh
      'Moyo Hulu': '52.04.16.2001', // Moyo Hulu
      'Ropang': '52.04.17.2001', // Ropang
      'Lenangguar': '52.04.18.2001', // Lenangguar
      'Lantung': '52.04.19.2001', // Lantung
      'Lunyuk': '52.04.20.2001', // Lunyuk
      'Orong Telu': '52.04.21.2001', // Orong Telu
      'Tarano': '52.04.22.2001', // Tarano
      'Maronge': '52.04.23.2001', // Maronge
      'Labangka': '52.04.24.2001', // Labangka
    },

    // ==========================================
    // KAB. SUMBAWA BARAT (52.07)
    // ==========================================
    'Sumbawa Barat': {
      'Taliwang': '52.07.01.2001', // Taliwang
      'Seteluk': '52.07.02.2001', // Seteluk
      'Poto Tano': '52.07.03.2001', // Poto Tano
      'Brang Rea': '52.07.04.2001', // Brang Rea
      'Brang Ene': '52.07.05.2001', // Brang Ene
      'Jereweh': '52.07.06.2001', // Jereweh
      'Maluk': '52.07.07.2001', // Maluk
      'Sekongkang': '52.07.08.2001', // Sekongkang Bawah
    },

    // ==========================================
    // KAB. DOMPU (52.05)
    // ==========================================
    'Dompu': {
      'Dompu': '52.05.01.1001', // Dompu
      'Woja': '52.05.02.2001', // Woja
      'Kilo': '52.05.03.2001', // Kilo
      'Kempo': '52.05.04.2001', // Kempo
      'Hu\'u': '52.05.05.2001', // Hu\'u
      'Pajo': '52.05.06.2001', // Pajo
      'Pekat': '52.05.07.2001', // Pekat
      'Manggelewa': '52.05.08.2001', // Manggelewa
    },

    // ==========================================
    // KOTA BIMA (52.72)
    // ==========================================
    'Kota Bima': {
      'Rasanae Barat': '52.72.01.1001', // Paruga
      'Rasanae Timur': '52.72.02.1004', // Kumbe
      'Asakota': '52.72.03.1001', // Melayu
      'Raba': '52.72.04.1001', // Penaraga
      'Mpunda': '52.72.05.1001', // Monggonao
    },

    // ==========================================
    // KAB. BIMA (52.06)
    // ==========================================
    'Kabupaten Bima': {
      'Bolo': '52.06.01.2001', // Bolo
      'Monta': '52.06.02.2001', // Monta
      'Woha': '52.06.03.2001', // Woha
      'Belo': '52.06.04.2001', // Belo
      'Palibelo': '52.06.05.2001', // Palibelo
      'Wawo': '52.06.06.2001', // Wawo
      'Langgudu': '52.06.07.2001', // Langgudu
      'Lambitu': '52.06.08.2001', // Lambitu
      'Sape': '52.06.09.2001', // Sape
      'Lambu': '52.06.10.2001', // Lambu
      'Wera': '52.06.11.2001', // Wera
      'Ambalawi': '52.06.12.2001', // Ambalawi
      'Donggo': '52.06.13.2001', // Donggo
      'Soromandi': '52.06.14.2001', // Soromandi
      'Sanggar': '52.06.15.2001', // Sanggar
      'Tambora': '52.06.16.2001', // Tambora
      'Madapangga': '52.06.17.2001', // Madapangga
      'Parado': '52.06.18.2001', // Parado
    },
  };

  /// Daftar semua kabupaten/kota di NTB
  static List<String> getKabupatenList() {
    return regions.keys.toList();
  }

  /// Daftar kecamatan dalam satu kabupaten
  static List<String> getKecamatanList(String kabupaten) {
    return regions[kabupaten]?.keys.toList() ?? [];
  }

  /// Ambil kode adm4 untuk BMKG API
  static String? getAdm4Code(String kabupaten, String kecamatan) {
    return regions[kabupaten]?[kecamatan];
  }

  /// Cari kabupaten dari nama kecamatan
  static String? findKabupatenByKecamatan(String kecamatan) {
    for (var entry in regions.entries) {
      if (entry.value.containsKey(kecamatan)) {
        return entry.key;
      }
    }
    return null;
  }
}
