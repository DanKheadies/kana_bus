import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  bool isHovering = false;
  bool isClicking = false;
  bool isLoading = false;
  FocusNode focusInput = FocusNode();
  GoogleTranslator translator = GoogleTranslator();
  KanaKit kanaKit = KanaKit();
  TextEditingController englishCont = TextEditingController();
  TextEditingController inputCont = TextEditingController();
  TextEditingController kanaCont = TextEditingController();
  TextEditingController romajiCont = TextEditingController();

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
                    // TODO: handle translating if the user saves before trans
                    // can complete
                    if (value != '') {
                      await translate(value);
                    } else {
                      clear();
                    }
                  },
                  onEditingComplete: () {
                    save();
                    closeKeyboard();
                    clear();
                  },
                  onSubmitted: (_) {},
                  onTap: () {
                    inputCont.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: inputCont.value.text.length,
                    );
                  },
                  textColor: Theme.of(context).colorScheme.surface,
                  focusInput: focusInput,
                  isDisabled: false,
                ),
              ),
              const SizedBox(height: 8, width: double.infinity),
              BusmPane(
                controller: englishCont,
                label: 'English Translation',
                onChanged: (_) {},
                onEditingComplete: () {},
                onSubmitted: (_) {},
                textColor: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 8, width: double.infinity),
              BusmPane(
                controller: kanaCont,
                label: 'Kana Translation',
                onChanged: (_) {},
                onEditingComplete: () {},
                onSubmitted: (_) {},
                textColor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8, width: double.infinity),
              BusmPane(
                controller: romajiCont,
                label: 'Romaji Translation',
                onChanged: (_) {},
                onEditingComplete: () {},
                onSubmitted: (_) {},
                textColor: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 20),
              // TODO: refactor as widget
              BlocBuilder<KanaBusBloc, KanaBusState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.currentRide.kanaBusms.length,
                      itemBuilder: (context, index) {
                        // TODO: copy the input; swipe left immediate
                        // TODO: delete the busm; swipe right w/ confirmation
                        return Slidable(
                          key: Key(
                            state.currentRide.kanaBusms[index].createdAt
                                .toString(),
                          ),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dismissible: DismissiblePane(onDismissed: () {}),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  String input =
                                      state.currentRide.kanaBusms[index].input;
                                  // setState(() {
                                  //   kanaBusms.removeAt(index);
                                  // });
                                  context.read<KanaBusBloc>().add(
                                    RemoveBusm(index: index),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..clearSnackBars()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$input has been removed.',
                                        ),
                                      ),
                                    );
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                              SlidableAction(
                                // Note: should share all 4 inputs (w/ labels)
                                onPressed: (context) => print('TODO: share'),
                                backgroundColor: Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.share,
                                label: 'Share',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                // An action can be bigger than the others.
                                flex: 2,
                                onPressed: (context) {
                                  String input =
                                      state.currentRide.kanaBusms[index].input;
                                  setState(() {
                                    inputCont.text = input;
                                  });
                                  translate(input);
                                  ScaffoldMessenger.of(context)
                                    ..clearSnackBars()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$input has been copied.',
                                        ),
                                      ),
                                    );
                                },
                                backgroundColor: Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.copy,
                                label: 'Copy',
                              ),
                              // SlidableAction(
                              //   onPressed: (context) => print('TODO: save'),
                              //   backgroundColor: Color(0xFF0392CF),
                              //   foregroundColor: Colors.white,
                              //   icon: Icons.save,
                              //   label: 'Save',
                              // ),
                            ],
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.currentRide.kanaBusms[index].input,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surfaceBright,
                                    ),
                                  ),
                                  Text(
                                    state.currentRide.kanaBusms[index].english,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                  ),
                                  Text(
                                    state.currentRide.kanaBusms[index].kana,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    state.currentRide.kanaBusms[index].romaji,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                  index !=
                                          state.currentRide.kanaBusms.length - 1
                                      ? Divider(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
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
