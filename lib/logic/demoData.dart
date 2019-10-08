class OfflineDisease {
  static List<String> diabetes = [
    's_310',
    's_215',
    's_311',
    's_285',
    's_119',
    's_540',
  ];

  static List<String> depression = [
    's_120',
    's_4',
    's_660',
    's_169',
    's_916',
    's_205',
    's_632',
    's_287',
    's_646',
    's_917',
    's_540',
  ];

  static List<String> anxiety = [
    's_120',
    's_540',
    's_631',
    's_119',
    's_205',
    's_632',
    's_287',
    's_646',
    's_583',
    's_917',
    's_540',
    's_216',
    's_582',
  ];

  static List<String> hemorrhoid = [
    's_249',
    's_631',
    's_1242',
    's_1393',
    's_112',
    's_287',
  ];

  static List<String> yeastInfection = [
    's_324',
    's_1586',
    's_64',
    's_1569',
    's_112',
    's_287',
  ];

  static List<String> lupus = [
    's_98',
    's_1586',
    's_623',
    's_1547',
    's_417',
    's_171',
    's_30',
  ];

  static List<String> shingles = [
    's_324',
    's_1165',
    's_1915',
    's_1807',
    's_400',
  ];

  static List<String> psoriasis = [
    's_384',
    's_1165',
    's_385',
    's_254',
    's_623',
  ];

  static List<String> schizophrenia = [
    's_686',
    's_682',
    's_685',
    's_683',
    's_684',
    's_681',
    's_244',
    's_1139',
    's_1140',
  ];

  static List<String> lyme = [
    's_1870',
    's_1535',
    's_418',
    's_417',
    's_1292',
    's_575',
    's_171',
    's_1156',
    's_110',
    's_2002',
  ];

  static List<String> hpv = [
    's_254',
  ];

  static List<String> herpes = [
    's_221',
    's_253',
    's_249',
    's_1807',
    's_672',
  ];

  static List<String> pneumonia = [
    's_30',
    's_102',
    's_104',
    's_1807',
    's_98',
    's_81',
    's_88',
    's_1462',
    's_1601',
    's_30',
    's_284',
    's_356',
    's_156',
    's_305',
  ];

  static List<String> fibromyalgia = [
    's_44',
    's_1656',
    's_634',
    's_1807',
    's_319',
    's_631',
    's_316',
    's_120',
    's_169',
    's_258',
    's_83',
    's_555',
    's_156',
    's_1899',
    's_1900',
    's_125',
    's_518',
    's_21',
  ];

  static List<String> scabies = [
    's_400',
    's_417',
    's_672',
    's_245',
    's_319',
  ];

  static List<String> chlamydia = [
    's_39',
    's_417',
    's_33',
    's_32',
    's_1802',
    's_1591',
    's_328',
    's_366',
    's_510',
    's_1217',
    's_115',
  ];

  static List<String> endometriosis = [
    's_59',
    's_32',
    's_1393',
    's_593',
  ];

  static List<String> strepThroat = [
    's_59',
    's_32',
    's_509',
    's_1498',
    's_962',
    's_139',
    's_664',
    's_220',
    's_1733',
  ];

  static List<String> diverticulitis = [
    's_1854',
    's_156',
    's_305',
    's_98',
    's_1514',
    's_329',
    's_664',
    's_8',
  ];

  static List<String> bronchitis = [
    's_102',
    's_526',
    's_119',
    's_88',
    's_98',
    's_81',
    's_50',
  ];

  static List<String> listOfDisease() {
   
    List<String> tempList = [];
   
    tempList.addAll(diabetes);
    tempList.addAll(depression);
    tempList.addAll(anxiety);
    tempList.addAll(hemorrhoid);
    tempList.addAll(yeastInfection);
    tempList.addAll(lupus);
    tempList.addAll(shingles);
    tempList.addAll(psoriasis);
    tempList.addAll(schizophrenia);
    tempList.addAll(lyme);
    tempList.addAll(hpv);
    tempList.addAll(herpes);
    tempList.addAll(pneumonia);
    tempList.addAll(fibromyalgia);
    tempList.addAll(scabies);
    tempList.addAll(chlamydia);
    tempList.addAll(endometriosis);
    tempList.addAll(strepThroat);
    tempList.addAll(diverticulitis);
    tempList.addAll(bronchitis);

    return tempList.toSet().toList();
  }
}
