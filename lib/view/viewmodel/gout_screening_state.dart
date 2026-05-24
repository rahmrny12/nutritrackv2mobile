class GoutScreeningState {
  // Risk Factor
  String? riwayatKeluarga;
  String? pernahAsamUrat;
  String? konsumsiPurin;
  String? minumanManis;
  String? beratBadan;
  String? hipertensiGinjal;
  String? alkohol;

  // Symptom
  String? nyeriSendi;
  String? bengkakSendi;
  String? nyeriIbuJari;

  bool get isCompleted =>
      riwayatKeluarga != null &&
      pernahAsamUrat != null &&
      konsumsiPurin != null &&
      minumanManis != null &&
      beratBadan != null &&
      hipertensiGinjal != null &&
      alkohol != null &&
      nyeriSendi != null &&
      bengkakSendi != null &&
      nyeriIbuJari != null;

  Map<String, dynamic> toAnswersJson() {
    return {
      'riwayat_keluarga': riwayatKeluarga,
      'pernah_asam_urat': pernahAsamUrat,
      'konsumsi_purin': konsumsiPurin,
      'minuman_manis': minumanManis,
      'berat_badan': beratBadan,
      'hipertensi_ginjal': hipertensiGinjal,
      'alkohol': alkohol,
      'nyeri_sendi': nyeriSendi,
      'bengkak_sendi': bengkakSendi,
      'nyeri_ibu_jari': nyeriIbuJari,
    };
  }
}