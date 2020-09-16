class Word{

  static const String FRENCH = "french";
  static const String ENGLISH = "english";
  static const String NOUN = "Nomen";
  static const String PRONOUN = "Pronomen";
  static const String VERB = "Verb";
  static const String ADJECTIVE = "Adjektiv";
  static const String UNKNOWN = "unknown";
  static const String CONNECTOR = "Konnektor";
  static const String PREPOSITION = "Präprosition";
  static const String ARTICLE = "Artikel";

  String word;
  String pluralForm;
  // does it a verb, noun ?
  String type;
  // examples in the sentence
  List<String> examples;
  Map translation;
  String language;

  Word({this.word, this.pluralForm, this.type, this.examples, this.translation, this.language});
}