// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kana_bus/barrel.dart';

// class EditRideModal extends StatefulWidget {
//   final BusRide currentRide;

//   const EditRideModal({super.key, required this.currentRide});

//   @override
//   State<EditRideModal> createState() => _EditRideModalState();
// }

// class _EditRideModalState extends State<EditRideModal> {
//   bool hasChanged = false;
//   TextEditingController flagCont = TextEditingController();
//   TextEditingController titleCont = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     titleCont.text = widget.currentRide.title ?? '';
//   }

//   @override
//   void dispose() {
//     titleCont.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // double screenWidth = MediaQuery.of(context).size.width;

//     return AnimatedKanaBusModal(
//       child: Padding(
//         // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
//         padding: EdgeInsets.zero,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Row(
//             //   crossAxisAlignment: CrossAxisAlignment.center,
//             //   children: [
//             //     // CustomBlockHeader(text: 'Log In', isLarge: true),
//             //     Text('Edit Modal'),
//             //     const Spacer(),
//             //     IconButton(
//             //       icon: Icon(
//             //         Icons.close,
//             //         color: Theme.of(context).colorScheme.primary,
//             //       ),
//             //       onPressed: () => Navigator.of(context).pop(),
//             //       onLongPress: () {},
//             //     ),
//             //   ],
//             // ),
//             // const SizedBox(height: 10),
//             BusmPane(
//               controller: titleCont,
//               label: 'This Ride',
//               onChanged: (value) {
//                 setState(() {
//                   hasChanged = true;
//                 });
//               },
//               isDisabled: false,
//             ),
//             Container(
//               // padding: rowPadding,
//               // width: widget.width < 850 ? widget.width : 500,
//               width: 450,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Flexible(
//                         flex: 1,
//                         child: BusmPane(
//                           controller: flagCont,
//                           label: 'Flags',
//                           onChanged: (value) {},
//                           // onEnter: (_) =>
//                           // onEditingComplete: () =>
//                           //     addTitleHints(context, state.newStory),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       IconButton(
//                         icon: Icon(Icons.add),
//                         onPressed: () => print('addTitleHints'),
//                         // addTitleHints(context, state.newStory),
//                       ),
//                     ],
//                   ),
//                   if (state.newStory.titleHints != null) ...[
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: state.newStory.titleHints!.length,
//                       itemBuilder: (context, index) => ListTile(
//                         title: Text(state.newStory.titleHints![index]),
//                         trailing: IconButton(
//                           icon: Icon(Icons.remove),
//                           onPressed: () {
//                             List<String> titleHintsList = state
//                                 .newStory
//                                 .titleHints!
//                                 .toList();
//                             titleHintsList.remove(
//                               state.newStory.titleHints![index],
//                             );

//                             context.read<StoryBloc>().add(
//                               UpdateNewStory(
//                                 newStory: state.newStory.copyWith(
//                                   titleHints: titleHintsList,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         contentPadding: const EdgeInsets.only(left: 16),
//                         onLongPress: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return EditModal(
//                                 content: state.newStory.titleHints![index],
//                                 index: index,
//                                 // isMulti: true,
//                                 newStory: state.newStory,
//                                 onUpdate: (newValue) {
//                                   List<String> updatedChapters = state
//                                       .newStory
//                                       .chapters
//                                       .toList();
//                                   updatedChapters[index] = newValue;
//                                   context.read<StoryBloc>().add(
//                                     UpdateNewStory(
//                                       newStory: state.newStory.copyWith(
//                                         chapters: updatedChapters,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(height: 18),
//             ElevatedButton(
//               onPressed:
//                   // (widget.currentRide.title == titleCont.text ||
//                   titleCont.text == '' || !hasChanged
//                   ? null
//                   : () {
//                       context.read<KanaBusBloc>().add(
//                         UpdateBusRide(title: titleCont.text),
//                       );
//                       setState(() {
//                         hasChanged = false;
//                       });
//                     },
//               child: Text('Update'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
