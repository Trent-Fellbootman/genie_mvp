import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/named_tuple.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/string_data.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/array_data.dart';
import 'package:genie_mvp/data_models/mini_app_data_items/data_item.dart';
import 'package:genie_mvp/data_models/mini_app_specification_data.dart';
import 'package:genie_mvp/data_models/data_types/integer_data.dart';
import 'package:genie_mvp/ui/data_input_widgets/data_item_input_widget.dart';
import 'package:genie_mvp/ui/data_input_widgets/array_input_widget.dart';
import 'package:genie_mvp/ui/data_input_widgets/named_tuple_input_widget.dart';
import 'package:genie_mvp/ui/mini_app_search_view.dart';
import 'package:genie_mvp/ui/mini_app_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 0, 255),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: const MiniAppSearchResultDisplayView(searchSessionToken: "",),
//           child: MiniAppView(appSpecification: MiniAppSpecification(
//             inputOutputSpecification: MiniAppInputOutputSpecification(
//               inputTypeDeclaration: DataItemType(
//                 basicDataItemType: BasicDataItemType.array,
//                 arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
//                   itemType: DataItemType(
//                     basicDataItemType: BasicDataItemType.string,
//                   )
//                 )
//               ),
//               outputTypeDeclaration: DataItemType(
//                 basicDataItemType: BasicDataItemType.string
//               ),
//             ),
//             metadata: MiniAppSpecificationMetadata(
//               name: "随机选择器",
//               description:
// """随机选择器，选择困难症的福音！
//
// 从输入的多个句子中随机选一个输出。
// """,
//               likes: IntegerData(value: 1),
//               dislikes: IntegerData(value: 0),
//             )
//           ),),
//           child: const Markdown(
//               data:
// """# Koalas are so cute!
//
// ## Koalas are so adorable!
//
// test
// test
// test
//
// - Testing
// - adorable
// """),
          // child: DataItemInputWidget(
          //   dataItem: DataItem(
          //       dataItemType: DataItemType(
          //           basicDataItemType: BasicDataItemType.namedTuple,
          //           namedTupleAuxiliaryTypeData: NamedTupleAuxiliaryTypeData(
          //             elementTypeConfig: {
          //               "value 1": DataItemType(
          //                 basicDataItemType: BasicDataItemType.array,
          //                 arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
          //                   itemType: DataItemType(
          //                       basicDataItemType: BasicDataItemType.namedTuple,
          //                       namedTupleAuxiliaryTypeData:
          //                           NamedTupleAuxiliaryTypeData(
          //                               elementTypeConfig: {
          //                             "value 1": DataItemType(
          //                               basicDataItemType:
          //                                   BasicDataItemType.string,
          //                             ),
          //                             "value 2": DataItemType(
          //                                 basicDataItemType:
          //                                     BasicDataItemType.array,
          //                                 arrayAuxiliaryTypeData:
          //                                     ArrayAuxiliaryTypeData(
          //                                         itemType: DataItemType(
          //                                             basicDataItemType:
          //                                                 BasicDataItemType
          //                                                     .string)))
          //                           })),
          //                 ),
          //               ),
          //               "value 2": DataItemType(
          //                 basicDataItemType: BasicDataItemType.string,
          //               )
          //             },
          //           )),
          //       namedTupleData: NamedTupleData(elementTypeConfig: {
          //         "value 1": DataItemType(
          //             basicDataItemType: BasicDataItemType.array,
          //             arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
          //                 itemType: DataItemType(
          //                     basicDataItemType: BasicDataItemType.namedTuple,
          //                     namedTupleAuxiliaryTypeData:
          //                         NamedTupleAuxiliaryTypeData(
          //                             elementTypeConfig: {
          //                           "value 1": DataItemType(
          //                             basicDataItemType:
          //                                 BasicDataItemType.string,
          //                           ),
          //                           "value 2": DataItemType(
          //                               basicDataItemType:
          //                                   BasicDataItemType.array,
          //                               arrayAuxiliaryTypeData:
          //                                   ArrayAuxiliaryTypeData(
          //                                       itemType: DataItemType(
          //                                           basicDataItemType:
          //                                               BasicDataItemType
          //                                                   .string)))
          //                         })))),
          //         "value 2": DataItemType(
          //           basicDataItemType: BasicDataItemType.string,
          //         )
          //       }, elements: {
          //         "value 1": DataItem(
          //             dataItemType: DataItemType(
          //                 basicDataItemType: BasicDataItemType.array,
          //                 arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
          //                     itemType: DataItemType(
          //                         basicDataItemType:
          //                             BasicDataItemType.namedTuple,
          //                         namedTupleAuxiliaryTypeData:
          //                             NamedTupleAuxiliaryTypeData(
          //                                 elementTypeConfig: {
          //                               "value 1": DataItemType(
          //                                 basicDataItemType:
          //                                     BasicDataItemType.string,
          //                               ),
          //                               "value 2": DataItemType(
          //                                   basicDataItemType:
          //                                       BasicDataItemType.array,
          //                                   arrayAuxiliaryTypeData:
          //                                       ArrayAuxiliaryTypeData(
          //                                           itemType: DataItemType(
          //                                               basicDataItemType:
          //                                                   BasicDataItemType
          //                                                       .string)))
          //                             })))),
          //             arrayData: ArrayData(
          //                 list: [],
          //                 itemType: DataItemType(
          //                     basicDataItemType:
          //                     BasicDataItemType.namedTuple,
          //                     namedTupleAuxiliaryTypeData:
          //                     NamedTupleAuxiliaryTypeData(
          //                         elementTypeConfig: {
          //                           "value 1": DataItemType(
          //                             basicDataItemType:
          //                             BasicDataItemType.string,
          //                           ),
          //                           "value 2": DataItemType(
          //                               basicDataItemType:
          //                               BasicDataItemType.array,
          //                               arrayAuxiliaryTypeData:
          //                               ArrayAuxiliaryTypeData(
          //                                   itemType: DataItemType(
          //                                       basicDataItemType:
          //                                       BasicDataItemType
          //                                           .string)))
          //                         }))
          //             )),
          //         "value 2": DataItem(
          //             dataItemType: DataItemType(
          //                 basicDataItemType: BasicDataItemType.string),
          //             stringData: StringData(data: "world"))
          //       })),
          // ),
        ),
      ),
    );
  }
}
