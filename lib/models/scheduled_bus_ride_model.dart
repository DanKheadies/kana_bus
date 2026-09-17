import 'package:kana_bus/barrel.dart';

class ScheduledBusRide {
  final List<Busm> busms;
  final String subtitle;
  final String title;

  const ScheduledBusRide({
    required this.busms,
    required this.subtitle,
    required this.title,
  });

  static final List<ScheduledBusRide> allScheduledRides = [
    mariBasics,
    asamiBasics,
    mochiBasics,
    mariExpressivePhrases,
    hardcorePhrases,
    mePronouns,
    youPronouns,
    himPronouns,
    herPronouns,
    commonFillers,
    listeningReactionFillers,
    thinkingHesitatingFillers,
    agreementResponseFillers,
    emotionalCasualFillers,
    thankYouVariations,
    moreThanArigato,
  ];

  static final ScheduledBusRide mariBasics = ScheduledBusRide(
    title: 'Traveling Japan Basics',
    subtitle: 'via ask_mari_japanese',
    busms: BusRideBasics.mariBasics,
  );

  static final ScheduledBusRide asamiBasics = ScheduledBusRide(
    title: 'Traveling Japan Basics',
    subtitle: 'via asami_san111',
    busms: BusRideBasics.asamiBasics,
  );

  static final ScheduledBusRide mochiBasics = ScheduledBusRide(
    title: 'Traveling Japan Basics',
    subtitle: 'via mochi.sensei.japanese',
    busms: BusRideBasics.mochiBasics,
  );

  static final ScheduledBusRide mariExpressivePhrases = ScheduledBusRide(
    title: 'Anime Phrases',
    subtitle: 'via ask_mari_japanese',
    busms: BusRidePhrases.mariExpressivePhrases,
  );

  static final ScheduledBusRide hardcorePhrases = ScheduledBusRide(
    title: 'BOLD Phrases',
    subtitle: 'via Airlearn',
    busms: BusRidePhrases.hardcorePhrases,
  );

  static final ScheduledBusRide mePronouns = ScheduledBusRide(
    title: 'Pronouns - Me',
    subtitle: 'via arika_nihongo',
    busms: BusRidePronouns.mePronouns,
  );

  static final ScheduledBusRide youPronouns = ScheduledBusRide(
    title: 'Pronouns - You',
    subtitle: 'via arika_nihongo',
    busms: BusRidePronouns.youPronouns,
  );

  static final ScheduledBusRide himPronouns = ScheduledBusRide(
    title: 'Pronouns - He',
    subtitle: 'via arika_nihongo',
    busms: BusRidePronouns.himPronouns,
  );

  static final ScheduledBusRide herPronouns = ScheduledBusRide(
    title: 'Pronouns - She',
    subtitle: 'via arika_nihongo',
    busms: BusRidePronouns.herPronouns,
  );

  static final ScheduledBusRide commonFillers = ScheduledBusRide(
    title: 'Common Fillers',
    subtitle: 'via nihongo_note',
    busms: BusRideFillers.commonFillers,
  );

  static final ScheduledBusRide listeningReactionFillers = ScheduledBusRide(
    title: 'Listening / Reaction Fillers',
    subtitle: 'via nihongo_note',
    busms: BusRideFillers.listeningReactionFillers,
  );

  static final ScheduledBusRide thinkingHesitatingFillers = ScheduledBusRide(
    title: 'Thinking / Hesitating Fillers',
    subtitle: 'via nihongo_note',
    busms: BusRideFillers.thinkingHesitatingFillers,
  );

  static final ScheduledBusRide agreementResponseFillers = ScheduledBusRide(
    title: 'Agreement / Response Fillers',
    subtitle: 'via nihongo_note',
    busms: BusRideFillers.agreementResponseFillers,
  );

  static final ScheduledBusRide emotionalCasualFillers = ScheduledBusRide(
    title: 'Emotional / Casual Fillers',
    subtitle: 'via nihongo_note',
    busms: BusRideFillers.emotionalCasualFillers,
  );

  static final ScheduledBusRide thankYouVariations = ScheduledBusRide(
    title: 'Thank You Variations (Formal to Casual)',
    subtitle: 'via mochi.sensei.japanese',
    busms: BusRideThanks.thankYouVariations,
  );

  static final ScheduledBusRide moreThanArigato = ScheduledBusRide(
    title: 'There\'s More ',
    subtitle: 'via learnjapanesewithkoyu',
    busms: BusRideThanks.moreThanArigato,
  );
}
