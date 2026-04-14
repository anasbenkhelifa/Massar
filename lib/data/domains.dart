class DomainOption {
  final String id;
  final String labelEn;
  final String labelFr;
  final String labelAr;
  final String icon;

  const DomainOption({
    required this.id,
    required this.labelEn,
    required this.labelFr,
    required this.labelAr,
    required this.icon,
  });
}

const List<DomainOption> kInterestDomains = [
  DomainOption(id: 'technology',    labelEn: 'Technology',      labelFr: 'Technologie',     labelAr: 'تكنولوجيا',       icon: '💻'),
  DomainOption(id: 'medicine',      labelEn: 'Medicine',        labelFr: 'Médecine',        labelAr: 'طب',              icon: '🏥'),
  DomainOption(id: 'law',           labelEn: 'Law',             labelFr: 'Droit',           labelAr: 'قانون',           icon: '⚖️'),
  DomainOption(id: 'engineering',   labelEn: 'Engineering',     labelFr: 'Ingénierie',      labelAr: 'هندسة',           icon: '🔧'),
  DomainOption(id: 'business',      labelEn: 'Business',        labelFr: 'Commerce',        labelAr: 'أعمال',           icon: '💼'),
  DomainOption(id: 'arts',          labelEn: 'Arts',            labelFr: 'Arts',            labelAr: 'فنون',            icon: '🎨'),
  DomainOption(id: 'education',     labelEn: 'Education',       labelFr: 'Éducation',       labelAr: 'تعليم',           icon: '📚'),
  DomainOption(id: 'science',       labelEn: 'Science',         labelFr: 'Sciences',        labelAr: 'علوم',            icon: '🔬'),
  DomainOption(id: 'agriculture',   labelEn: 'Agriculture',     labelFr: 'Agriculture',     labelAr: 'فلاحة',           icon: '🌿'),
  DomainOption(id: 'architecture',  labelEn: 'Architecture',    labelFr: 'Architecture',    labelAr: 'عمارة',           icon: '🏛️'),
  DomainOption(id: 'sport_science', labelEn: 'Sport Science',   labelFr: 'STAPS',           labelAr: 'علوم رياضية',     icon: '⚽'),
  DomainOption(id: 'journalism',    labelEn: 'Journalism',      labelFr: 'Journalisme',     labelAr: 'إعلام',           icon: '📰'),
];

const List<DomainOption> kWorkStyles = [
  DomainOption(id: 'solo',        labelEn: 'Solo',          labelFr: 'Seul',            labelAr: 'منفرد',    icon: '🧍'),
  DomainOption(id: 'team',        labelEn: 'Team',          labelFr: 'Équipe',          labelAr: 'فريق',     icon: '👥'),
  DomainOption(id: 'creative',    labelEn: 'Creative',      labelFr: 'Créatif',         labelAr: 'إبداعي',   icon: '✨'),
  DomainOption(id: 'analytical',  labelEn: 'Analytical',    labelFr: 'Analytique',      labelAr: 'تحليلي',   icon: '📊'),
  DomainOption(id: 'hands_on',    labelEn: 'Hands-on',      labelFr: 'Pratique',        labelAr: 'تطبيقي',   icon: '🛠️'),
  DomainOption(id: 'research',    labelEn: 'Research',      labelFr: 'Recherche',       labelAr: 'بحثي',     icon: '🔍'),
  DomainOption(id: 'management',  labelEn: 'Management',    labelFr: 'Management',      labelAr: 'تسيير',    icon: '📋'),
];

const List<DomainOption> kEnvironments = [
  DomainOption(id: 'office',    labelEn: 'Office',    labelFr: 'Bureau',     labelAr: 'مكتب',      icon: '🏢'),
  DomainOption(id: 'field',     labelEn: 'Field',     labelFr: 'Terrain',    labelAr: 'ميدان',     icon: '🌄'),
  DomainOption(id: 'lab',       labelEn: 'Lab',       labelFr: 'Laboratoire',labelAr: 'مختبر',     icon: '🧪'),
  DomainOption(id: 'remote',    labelEn: 'Remote',    labelFr: 'Télétravail', labelAr: 'عن بعد',   icon: '🏠'),
  DomainOption(id: 'hospital',  labelEn: 'Hospital',  labelFr: 'Hôpital',    labelAr: 'مستشفى',   icon: '🏥'),
  DomainOption(id: 'school',    labelEn: 'School',    labelFr: 'École',       labelAr: 'مدرسة',   icon: '🏫'),
  DomainOption(id: 'outdoor',   labelEn: 'Outdoor',   labelFr: 'Plein air',  labelAr: 'خارجي',    icon: '🌳'),
];
