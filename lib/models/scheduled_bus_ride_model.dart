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
    mariExpressivePhrases,
    hardcorePhrases,
    mePronouns,
    youPronouns,
    himPronouns,
    herPronouns,
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
}
