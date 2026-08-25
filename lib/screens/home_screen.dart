import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kana_bus/barrel.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:translator/translator.dart';
import 'package:uuid/v4.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool inputIsEnglish = false; // elseIs Kanji or Romanji
  bool isClicking = false;
  bool isFirstCome = true;
  bool isHovering = false;
  bool isInputting = false;
  bool isLoading = false;
  FocusNode focusInput = FocusNode();
  GoogleTranslator translator = GoogleTranslator();
  KanaKit kanaKit = KanaKit();
  TextEditingController englishCont = TextEditingController();
  TextEditingController inputCont = TextEditingController();
  TextEditingController kanaCont = TextEditingController();
  TextEditingController romajiCont = TextEditingController();

  @override
  void initState() {
    super.initState();

    isFirstCome = context.read<SettingsCubit>().state.isFirstCome;
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
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      drawer: BusRidesDrawer(
        clearBus: () => context.read<KanaBusBloc>().add(
          RemoveBusm(index: 0, removeAll: true),
        ),
        toggleOrder: () {
          context.read<SettingsCubit>().toggleOrder();
          setState(() {
            isFirstCome = !isFirstCome;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () => setState(() {
                  inputIsEnglish = !inputIsEnglish;
                }),
                child: BusmPane(
                  controller: inputCont,
                  label:
                      'Input (${inputIsEnglish ? 'English' : 'Kan/Romanji'})',
                  onChanged: (value) async {
                    setState(() {
                      isInputting = true;
                    });
                    await Future.delayed(Duration(milliseconds: 420));
                    // print('cachedValue: $cachedValue');
                    // print('value: $value');
                    // print('inputCont: ${inputCont.text}');
                    if (inputCont.text == value) {
                      print('should translate now');
                      if (value != '') {
                        await translate(value);
                      } else {
                        clear();
                      }
                      setState(() {
                        isInputting = false;
                      });
                    }
                  },
                  onEditingComplete: () {
                    if (isInputting) {
                      KanaBusHelper.sendSnack(
                        context,
                        'Translating.. One second.',
                      );
                    } else {
                      save();
                      closeKeyboard();
                      clear();
                    }
                  },
                  onSubmitted: (_) {},
                  onTap: () {
                    inputCont.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: inputCont.value.text.length,
                    );
                  },
                  // textColor: Theme.of(context).colorScheme.surface,
                  focusInput: focusInput,
                ),
              ),
              const SizedBox(height: 8, width: double.infinity),
              BusmPane(
                controller: englishCont,
                isDisabled: true,
                label: 'English Translation',
                onChanged: (_) {},
                onEditingComplete: () {},
                onSubmitted: (_) {},
                textColor: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 8, width: double.infinity),
              BusmPane(
                controller: kanaCont,
                isDisabled: true,
                label: 'Kana Translation',
                onChanged: (_) {},
                onEditingComplete: () {},
                onSubmitted: (_) {},
                textColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8, width: double.infinity),
              BusmPane(
                controller: romajiCont,
                isDisabled: true,
                label: 'Romaji Translation',
                onChanged: (_) {},
                onEditingComplete: () {},
                onSubmitted: (_) {},
                textColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 20),
              BlocBuilder<KanaBusBloc, KanaBusState>(
                builder: (context, state) {
                  String rideTitle = state.currentRide.title ?? 'This Ride';
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            print('current: ${state.currentRide.title}');
                            return EditBusRideModal(
                              currentRide: state.currentRide,
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 30,
                        // color: Colors.red.shade100,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Divider(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              rideTitle,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              // Icons.rebase_edit,
                              Icons.edit_note,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<KanaBusBloc, KanaBusState>(
                builder: (context, state) {
                  List<Busm> busmList = state.currentRide.kanaBusms.toList();
                  if (isFirstCome) {
                    busmList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                  } else {
                    busmList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  }

                  return Expanded(
                    child: ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // padding: const EdgeInsets.only(top: 20),
                      separatorBuilder: (context, index) =>
                          index != busmList.length - 1
                          ? Divider(
                              color: Theme.of(context).colorScheme.surface,
                              // height: 50,
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
                              RemoveBusm(index: index),
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
                            });
                            translate(input);
                            KanaBusHelper.sendSnack(
                              context,
                              '$input has been put in the input.',
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> translate(String input) async {
    if (input != '') {
      if (inputIsEnglish) {
        setState(() {
          isLoading = true;
        });

        var translation = await translator.translate(
          input,
          from: 'en',
          to: 'ja',
        );

        if (translation.text != '') {
          String kana = kanaKit.toKana(translation.text);
          setState(() {
            englishCont.text = input;
            kanaCont.text = kana;
            romajiCont.text = kanaKit.toRomaji(kana);
            isLoading = false;
          });
        }
      } else {
        setState(() {
          kanaCont.text = kanaKit.toKana(input);
          romajiCont.text = kanaKit.toRomaji(input);
          isLoading = true;
        });

        // await Future.delayed(Duration(seconds: 3));
        var translation = await translator.translate(
          kanaCont.text,
          from: 'ja', // 'auto'
          to: 'en',
        );

        // print(translation);
        if (input != '' && inputCont.text != '') {
          setState(() {
            englishCont.text = translation.text;
            isLoading = false;
          });
        }
      }
    }
  }

  void clear() {
    inputCont.clear();
    englishCont.clear();
    kanaCont.clear();
    romajiCont.clear();
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
    return Tooltip(
      message: isLoading
          ? 'Loading'
          : inputCont.text == ''
          ? 'Focus Input'
          : 'Take a Seat',
      child: GestureDetector(
        onTap: isLoading
            ? null
            : () async {
                print('tap');
                setState(() {
                  isClicking = true;
                });
                if (inputCont.text == '') {
                  focusInput.requestFocus();
                } else {
                  if (inputCont.text != '') {
                    await translate(inputCont.text);
                    save();
                    closeKeyboard();
                    clear();
                  } else {
                    clear();
                  }
                }
              },
        onDoubleTap: isLoading
            ? null
            : () => setState(() {
                inputIsEnglish = !inputIsEnglish;
              }),
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
                  ? Theme.of(context).colorScheme.surfaceBright.withAlpha(200)
                  : Theme.of(context).primaryColor.withAlpha(255),
              borderRadius: BorderRadius.circular(50),
            ),
            child: isLoading
                ? CircularProgressIndicator()
                : Icon(
                    Icons.text_fields,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
          ),
        ),
      ),
    );
  }
}
