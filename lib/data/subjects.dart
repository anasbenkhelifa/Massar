class SubjectOption {
  final String id;
  final String labelEn;
  final String labelFr;
  final String labelAr;

  const SubjectOption({
    required this.id,
    required this.labelEn,
    required this.labelFr,
    required this.labelAr,
  });
}

const List<SubjectOption> kSubjects = [
  SubjectOption(id: 'maths',          labelEn: 'Mathematics',    labelFr: 'Mathématiques',  labelAr: 'رياضيات'),
  SubjectOption(id: 'physics',        labelEn: 'Physics',        labelFr: 'Physique',        labelAr: 'فيزياء'),
  SubjectOption(id: 'arabic',         labelEn: 'Arabic',         labelFr: 'Arabe',           labelAr: 'عربية'),
  SubjectOption(id: 'french',         labelEn: 'French',         labelFr: 'Français',        labelAr: 'فرنسية'),
  SubjectOption(id: 'english',        labelEn: 'English',        labelFr: 'Anglais',         labelAr: 'إنجليزية'),
  SubjectOption(id: 'history',        labelEn: 'History',        labelFr: 'Histoire',        labelAr: 'تاريخ'),
  SubjectOption(id: 'biology',        labelEn: 'Biology',        labelFr: 'Biologie',        labelAr: 'علوم طبيعية'),
  SubjectOption(id: 'chemistry',      labelEn: 'Chemistry',      labelFr: 'Chimie',          labelAr: 'كيمياء'),
  SubjectOption(id: 'philosophy',     labelEn: 'Philosophy',     labelFr: 'Philosophie',     labelAr: 'فلسفة'),
  SubjectOption(id: 'economics',      labelEn: 'Economics',      labelFr: 'Économie',        labelAr: 'اقتصاد'),
  SubjectOption(id: 'computer_science', labelEn: 'Computer Science', labelFr: 'Informatique', labelAr: 'إعلام آلي'),
];

const List<String> kBacStreams = [
  'math',
  'sciences',
  'tech_math',
  'literature',
  'languages',
  'management',
  'islamic',
];

const Map<String, String> kBacStreamLabels = {
  'math':        'Mathématiques',
  'sciences':    'Sciences de la Nature',
  'tech_math':   'Technologie',
  'literature':  'Lettres & Philosophie',
  'languages':   'Langues Étrangères',
  'management':  'Gestion & Économie',
  'islamic':     'Sciences Islamiques',
};

const Map<String, String> kBacStreamIcons = {
  'math':        '🔢',
  'sciences':    '🔬',
  'tech_math':   '⚙️',
  'literature':  '📖',
  'languages':   '🌍',
  'management':  '📊',
  'islamic':     '☪️',
};

/// Returns bac mention label from average
String bacMentionLabel(double average) {
  if (average < 10) return 'Invalid';
  if (average < 12) return 'Passable';
  if (average < 14) return 'Assez Bien';
  if (average < 16) return 'Bien';
  if (average < 18) return 'Très Bien';
  return 'Félicitations';
}
