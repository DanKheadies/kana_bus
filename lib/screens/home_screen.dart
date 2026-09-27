import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';
import 'package:uuid/v4.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isClicking = false;
  bool isNewestAtTop = true;
  bool isHovering = false;
  bool isInputting = false;
  FocusNode focusInput = FocusNode();
  String cachedInput = '';
  TextEditingController englishCont = TextEditingController();
  TextEditingController inputCont = TextEditingController();
  TextEditingController kanaCont = TextEditingController();
  TextEditingController romajiCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    isNewestAtTop = context.read<SettingsCubit>().state.isNewestAtTop;
  }

  @override
  void dispose() {
    englishCont.dispose();
    focusInput.dispose();
    inputCont.dispose();
    kanaCont.dispose();
    romajiCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KanaBusBloc, KanaBusState>(
      listenWhen: (previous, current) =>
          previous.status == KanaBusStatus.translating &&
          current.status == KanaBusStatus.loaded,
      listener: (context, state) {
        // print('done translating');
        if (state.translation != null) {
          // print('update state');
          setState(() {
            englishCont.text = state.translation!.english;
            kanaCont.text = state.translation!.japanese;
            romajiCont.text = state.translation!.romaji;
          });
          if (state.translation!.english == state.translation!.japanese ||
              state.translation!.english == state.translation!.romaji) {
            KanaBusHelper.sendSnack(context, 'Check your input and type.');
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(clearInputs: clear, isHome: true),
        bottomNavigationBar: CustomBottomAppBar(),
        drawer: BusRidesDrawer(
          clearBus: () =>
              context.read<KanaBusBloc>().add(LoadCurrentRide(id: '')),
          toggleOrder: () {
            context.read<SettingsCubit>().toggleOrder();
            setState(() {
              isNewestAtTop = !isNewestAtTop;
            });
          },
        ),
        endDrawer: CustomDrawer(),
        floatingActionButton: inputButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<KanaBusBloc, KanaBusState>(
              builder: (context, state) {
                List<Busm> busmList = state.currentRide.kanaBusms.toList();
                String rideTitle = state.currentRide.title == ''
                    ? 'This Ride'
                    : state.currentRide.title;

                if (isNewestAtTop) {
                  busmList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                } else {
                  busmList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onDoubleTap: () =>
                          context.read<KanaBusBloc>().add(CycleType()),
                      child: BusmPane(
                        controller: inputCont,
                        labelWidget: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceBright.withAlpha(200),
                                ),
                            children: [
                              TextSpan(text: 'Input ('),
                              TextSpan(
                                text: KanaBusHelper.showTranslationType(
                                  state.currentType,
                                ),
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color: getInputColor(context, state),
                                    ),
                              ),
                              TextSpan(text: ')'),
                            ],
                          ),
                        ),
                        label:
                            'Input (${KanaBusHelper.showTranslationType(state.currentType)})',
                        autocorrect: false,
                        isDisabled: state.status == KanaBusStatus.translating,
                        onChanged: (value) => setState(() {
                          cachedInput = value;
                        }),
                        onEditingComplete: () {
                          context.read<KanaBusBloc>().add(
                            Translate(
                              input: inputCont.text,
                              type: state.currentType,
                            ),
                          );
                          closeKeyboard();
                        },
                        onSubmitted: (_) {
                          setState(() {
                            inputCont.text = cachedInput;
                          });
                          if (inputCont.text == '') {
                            clear();
                          }
                        },
                        onTap: () {
                          inputCont.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: inputCont.value.text.length,
                          );
                        },
                        focusInput: focusInput,
                      ),
                    ),
                    const SizedBox(height: 8, width: double.infinity),
                    GestureDetector(
                      onTap: () {
                        context.read<KanaBusBloc>().add(
                          CycleType(type: TranslationType.english),
                        );
                      },
                      onLongPress: () async {
                        if (englishCont.text.isNotEmpty) {
                          await Clipboard.setData(
                            ClipboardData(text: englishCont.text),
                          );
                          if (context.mounted) {
                            KanaBusHelper.sendSnack(
                              context,
                              '"${englishCont.text}" copied.',
                            );
                          }
                        }
                      },
                      child: BusmPane(
                        controller: englishCont,
                        isDisabled: true,
                        labelWidget: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceBright.withAlpha(200),
                                ),
                            children: [
                              TextSpan(
                                text: 'English',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color:
                                          state.currentType !=
                                              TranslationType.english
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.tertiary
                                          : Theme.of(context)
                                                .colorScheme
                                                .surfaceBright
                                                .withAlpha(200),
                                    ),
                              ),
                              TextSpan(text: ' Translation'),
                            ],
                          ),
                        ),
                        label: 'English Translation',
                        onChanged: (_) {},
                        onEditingComplete: () {},
                        onSubmitted: (_) {},
                        textColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 8, width: double.infinity),
                    GestureDetector(
                      onTap: () {
                        context.read<KanaBusBloc>().add(
                          CycleType(type: TranslationType.japanese),
                        );
                      },
                      onLongPress: () async {
                        if (kanaCont.text.isNotEmpty) {
                          await Clipboard.setData(
                            ClipboardData(text: kanaCont.text),
                          );
                          if (context.mounted) {
                            KanaBusHelper.sendSnack(
                              context,
                              '"${kanaCont.text}" copied.',
                            );
                          }
                        }
                      },
                      child: BusmPane(
                        controller: kanaCont,
                        isDisabled: true,
                        labelWidget: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceBright.withAlpha(200),
                                ),
                            children: [
                              TextSpan(
                                text: 'Kana/ji',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color:
                                          state.currentType !=
                                              TranslationType.japanese
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context)
                                                .colorScheme
                                                .surfaceBright
                                                .withAlpha(200),
                                    ),
                              ),
                              TextSpan(text: ' Translation'),
                            ],
                          ),
                        ),
                        label: 'Kana/ji Translation',
                        onChanged: (_) {},
                        onEditingComplete: () {},
                        onSubmitted: (_) {},
                        textColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8, width: double.infinity),
                    GestureDetector(
                      onTap: () {
                        context.read<KanaBusBloc>().add(
                          CycleType(type: TranslationType.romaji),
                        );
                      },
                      onLongPress: () async {
                        if (romajiCont.text.isNotEmpty) {
                          await Clipboard.setData(
                            ClipboardData(text: romajiCont.text),
                          );
                          if (context.mounted) {
                            KanaBusHelper.sendSnack(
                              context,
                              '"${romajiCont.text}" copied.',
                            );
                          }
                        }
                      },
                      child: BusmPane(
                        controller: romajiCont,
                        isDisabled: true,
                        labelWidget: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.surfaceBright.withAlpha(200),
                                ),
                            children: [
                              TextSpan(
                                text: 'Romaji',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color:
                                          state.currentType !=
                                              TranslationType.romaji
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.secondary
                                          : Theme.of(context)
                                                .colorScheme
                                                .surfaceBright
                                                .withAlpha(200),
                                    ),
                              ),
                              TextSpan(text: ' Translation'),
                            ],
                          ),
                        ),
                        label: 'Romaji Translation',
                        onChanged: (_) {},
                        onEditingComplete: () {},
                        onSubmitted: (_) {},
                        textColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClickableDivider(
                      text: rideTitle,
                      icon: Icons.edit_note,
                      onTap: () async {
                        var didUpdate = await showDialog(
                          context: context,
                          builder: (context) {
                            return EditBusRideModal(
                              currentRide: state.currentRide,
                            );
                          },
                        );
                        if (didUpdate && context.mounted) {
                          KanaBusHelper.sendSnack(
                            context,
                            'Your changes have been saved.',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            index != busmList.length - 1
                            ? Divider(
                                color: Theme.of(context).colorScheme.surface,
                              )
                            : const SizedBox(),
                        itemCount: busmList.length,
                        itemBuilder: (context, index) {
                          Busm busm = busmList[index];

                          return BusmRow(
                            busm: busm,
                            busmListLength: busmList.length,
                            index: index,
                            onDelete: (context) {
                              String input = busm.input;
                              context.read<KanaBusBloc>().add(
                                RemoveBusm(
                                  index: isNewestAtTop
                                      ? index
                                      : busmList.length - 1 - index,
                                ),
                              );
                              KanaBusHelper.sendSnack(
                                context,
                                '$input has been removed.',
                              );
                            },
                            onPhoto: (context) => KanaBusHelper.sendSnack(
                              context,
                              'TODO: add photo',
                            ),
                            onShare: (context) => KanaBusHelper.sendSnack(
                              context,
                              'TODO: share inputs',
                            ),
                            toInput: (context) {
                              String input = busm.input;
                              setState(() {
                                inputCont.text = input;
                                cachedInput = input;
                              });
                              context.read<KanaBusBloc>().add(
                                Translate(
                                  input: input,
                                  type: state.currentType,
                                ),
                              );
                              KanaBusHelper.sendSnack(
                                context,
                                '$input has been put in the input.',
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  bool hasMatchingTranslations(BuildContext context) {
    TranslationType type = context.read<KanaBusBloc>().state.currentType;
    return type == TranslationType.english
        ? cachedInput == englishCont.text
        : type == TranslationType.japanese
        ? cachedInput == kanaCont.text
        : type == TranslationType.romaji
        ? cachedInput == romajiCont.text
        : false;
  }

  bool isNonsensical(BuildContext context) {
    TranslationType type = context.read<KanaBusBloc>().state.currentType;
    return type == TranslationType.english
        ? englishCont.text != '' &&
              (englishCont.text == kanaCont.text ||
                  englishCont.text == romajiCont.text)
        : type == TranslationType.japanese
        ? kanaCont.text != '' &&
              (kanaCont.text == englishCont.text ||
                  kanaCont.text == romajiCont.text)
        : type == TranslationType.romaji
        ? romajiCont.text != '' &&
              (romajiCont.text == englishCont.text ||
                  romajiCont.text == kanaCont.text)
        : false;
  }

  Color getInputColor(BuildContext context, KanaBusState state) {
    return state.currentType == TranslationType.english
        ? Theme.of(context).colorScheme.tertiary
        : state.currentType == TranslationType.japanese
        ? Theme.of(context).colorScheme.primary
        : state.currentType == TranslationType.romaji
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.surfaceBright;
  }

  void clear() {
    inputCont.clear();
    englishCont.clear();
    kanaCont.clear();
    romajiCont.clear();
    setState(() {
      cachedInput = '';
    });
  }

  void closeKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void save() {
    if (inputCont.text.isNotEmpty) {
      Busm newBusm = Busm(
        createdAt: DateTime.now(),
        english: englishCont.text,
        id: UuidV4().generate(),
        input: inputCont.text,
        kana: kanaCont.text,
        romaji: romajiCont.text,
      );

      context.read<KanaBusBloc>().add(AddBusm(newBusm: newBusm));
    }
  }

  Widget inputButton(BuildContext context) {
    bool isNonsense = isNonsensical(context);
    bool shouldSave =
        inputCont.text != '' &&
        inputCont.text == cachedInput &&
        !isNonsense &&
        hasMatchingTranslations(context);
    bool shouldTranslate =
        !shouldSave && (inputCont.text != '' && !isNonsense) ||
        (inputCont.text != cachedInput && !isNonsense);

    return BlocBuilder<KanaBusBloc, KanaBusState>(
      builder: (context, state) {
        bool isTranslating = state.status == KanaBusStatus.translating;

        return Tooltip(
          message: isTranslating
              ? 'Loading'
              : inputCont.text == ''
              ? 'Focus Input'
              : isNonsense
              ? 'Clear'
              : shouldTranslate
              ? 'Translate'
              : 'Take a Seat',
          child: GestureDetector(
            onTap: isTranslating
                ? null
                : () async {
                    setState(() {
                      isClicking = true;
                    });

                    if (inputCont.text == '') {
                      focusInput.requestFocus();
                    } else {
                      if (shouldSave) {
                        save();
                        closeKeyboard();
                        clear();
                      } else if (shouldTranslate) {
                        context.read<KanaBusBloc>().add(
                          Translate(
                            input: inputCont.text,
                            type: state.currentType,
                          ),
                        );
                      } else if (isNonsense) {
                        clear();
                      }
                    }
                  },
            onDoubleTap: isTranslating
                ? null
                : () {
                    context.read<KanaBusBloc>().add(CycleType());
                    setState(() {});
                  },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() {
                isHovering = true;
              }),
              onExit: (_) => setState(() {
                isClicking = false;
                isHovering = false;
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isClicking
                      ? Theme.of(context).primaryColor.withAlpha(255)
                      : isHovering
                      ? Theme.of(
                          context,
                        ).colorScheme.surfaceBright.withAlpha(200)
                      : Theme.of(context).primaryColor.withAlpha(255),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: isTranslating
                    ? CircularProgressIndicator()
                    : Icon(
                        inputCont.text == ''
                            ? Icons.text_fields
                            : shouldTranslate
                            ? Icons.translate
                            : isNonsense
                            ? Icons.backspace
                            : Icons.save_alt,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
