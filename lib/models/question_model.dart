class QuestionModel {
  const QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.test,
  });

  final String id;
  final String text;
  final String type;
  final String test;
}

const List<QuestionModel> riasecQuestions = [
  QuestionModel(
    id: 'riasec_r1',
    type: 'Realistic',
    text: 'Bozuk elektronik aletleri tamir etmeyi severim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_r4',
    type: 'Realistic',
    text: 'Makinelerin nasıl çalıştığını incelemek ilgimi çeker.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_r5',
    type: 'Realistic',
    text: 'Ellerimi kullanarak somut işler yapmayı tercih ederim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_i1',
    type: 'Investigative',
    text: 'Bilimsel teorileri ve neden-sonuç ilişkilerini araştırmayı severim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_i2',
    type: 'Investigative',
    text:
        'Karmaşık problemleri çözmek için zihinsel çaba harcamaktan hoşlanırım.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_i5',
    type: 'Investigative',
    text: 'Matematiksel veya mantıksal bulmacaları çözmekten keyif alırım.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_a3',
    type: 'Artistic',
    text:
        'Yaratıcı ve kuralları esnek olan ortamlarda çalışmayı tercih ederim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_a4',
    type: 'Artistic',
    text: 'Estetik ve tasarıma önem veririm.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_a5',
    type: 'Artistic',
    text: 'Özgün ve yenilikçi fikirler üretmekten hoşlanırım.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_s2',
    type: 'Social',
    text: 'Bir gruba liderlik etmekten çok, öğretmeyi ve geliştirmeyi severim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_s4',
    type: 'Social',
    text:
        'İnsanlarla iletişim kurabileceğim meslekleri, makine veya verilerle çalışmaya tercih ederim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_s5',
    type: 'Social',
    text: 'Empati kurma yeteneğimin güçlü olduğunu düşünürüm.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_e1',
    type: 'Enterprising',
    text: 'Bir projeyi yönetmek ve insanları organize etmekten keyif alırım.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_e2',
    type: 'Enterprising',
    text: 'İnsanları ikna etmek ve fikirlerimi sunmak konusunda iyiyimdir.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_e4',
    type: 'Enterprising',
    text: 'Girişimcilik ve iş dünyasıyla ilgili konular ilgimi çeker.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_c1',
    type: 'Conventional',
    text: 'Düzenli, planlı ve kuralları belli olan işleri severim.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_c2',
    type: 'Conventional',
    text: 'Verileri kaydetmek, arşivlemek veya hesap yapmak bana uygun gelir.',
    test: 'RIASEC',
  ),
  QuestionModel(
    id: 'riasec_c3',
    type: 'Conventional',
    text: 'Detaylara dikkat ederim ve hataları bulmakta iyiyimdir.',
    test: 'RIASEC',
  ),
];

const List<QuestionModel> oceanQuestions = [
  QuestionModel(
    id: 'big5_o1',
    type: 'Openness',
    text: 'Yeni deneyimlere ve maceralara atılmaktan keyif alırım.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_o2',
    type: 'Openness',
    text: 'Hayal gücüm geniştir ve sanatsal konular ilgimi çeker.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_c1',
    type: 'Conscientiousness',
    text: 'İşlerimi her zaman planlı ve düzenli bir şekilde yaparım.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_c2',
    type: 'Conscientiousness',
    text: 'Sorumluluklarımı zamanında yerine getirmek benim için önemlidir.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_e1',
    type: 'Extraversion',
    text:
        'Yeni insanlarla tanışmak ve sosyal ortamlarda bulunmak beni canlandırır.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_e2',
    type: 'Extraversion',
    text: 'Genellikle konuşkan ve enerjik biriyimdir.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_a1',
    type: 'Agreeableness',
    text: 'İnsanlara karşı genellikle nazik ve güven doluyumdur.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_a2',
    type: 'Agreeableness',
    text: 'Başkalarıyla iş birliği yapmayı severim, çatışmadan kaçınırım.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_n1',
    type: 'Neuroticism',
    text: 'Stresli durumlarda kolayca endişelenir veya gerilirim.',
    test: 'OCEAN',
  ),
  QuestionModel(
    id: 'big5_n2',
    type: 'Neuroticism',
    text: 'Duygusal durumum gün içinde sık sık değişebilir.',
    test: 'OCEAN',
  ),
];
