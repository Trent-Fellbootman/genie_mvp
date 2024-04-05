import 'package:flutter/material.dart';
import 'package:genie_mvp/data_models/mini_app/mini_app_data_items/file_data.dart';
import 'package:genie_mvp/ui/pages/ai_mini_app_generation_page.dart';
import 'package:genie_mvp/ui/pages/login_page.dart';
import 'package:genie_mvp/ui/pages/mini_app_search_page.dart';
import 'package:genie_mvp/ui/pages/setup_token_page.dart';
import 'package:genie_mvp/ui/widgets/ai_app_generation_view.dart';
import 'package:genie_mvp/ui/widgets/data_input_widgets/data_item_input_widget.dart';
import 'package:genie_mvp/ui/widgets/data_input_widgets/file_input_widget.dart';
import 'package:genie_mvp/ui/widgets/mini_app_search_view.dart';

import 'data_models/mini_app/mini_app_data_items/array_data.dart';
import 'data_models/mini_app/mini_app_data_items/data_item.dart';
import 'data_models/mini_app/mini_app_data_items/named_tuple.dart';
import 'data_models/mini_app/mini_app_data_items/string_data.dart';

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
      routes: {
        '/': (context) => const SetUpTokenPage(),
        '/home': (context) => const MiniAppSearchPage(),
        '/login': (context) => const LoginPage(),
        '/ai_app_generation_page': (context) =>
            const AIMiniAppGenerationPage(),
      },
      // home: Scaffold(
      //   body: SafeArea(
      //     child: FileInputWidget(
      //       fileDataInstance: FileData(),
      //     ),
      //   ),
      // ),
      // home: const Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 255, 0, 255),
      // ),
      // body: SafeArea(
      // child: AIMiniAppGenerationView(),
      // child: MiniAppSearchView(),
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
//           child: DataItemInputWidget(
//             dataItem: DataItem(
//                 dataItemType: DataItemType(
//                     basicDataItemType: BasicDataItemType.namedTuple,
//                     namedTupleAuxiliaryTypeData: NamedTupleAuxiliaryTypeData(
//                       elementTypeConfig: {
//                         "value 1": DataItemType(
//                           basicDataItemType: BasicDataItemType.array,
//                           arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
//                             itemType: DataItemType(
//                                 basicDataItemType: BasicDataItemType.namedTuple,
//                                 namedTupleAuxiliaryTypeData:
//                                     NamedTupleAuxiliaryTypeData(
//                                         elementTypeConfig: {
//                                       "value 1": DataItemType(
//                                         basicDataItemType:
//                                             BasicDataItemType.string,
//                                       ),
//                                       "value 2": DataItemType(
//                                           basicDataItemType:
//                                               BasicDataItemType.array,
//                                           arrayAuxiliaryTypeData:
//                                               ArrayAuxiliaryTypeData(
//                                                   itemType: DataItemType(
//                                                       basicDataItemType:
//                                                           BasicDataItemType
//                                                               .string)))
//                                     })),
//                           ),
//                         ),
//                         "value 2": DataItemType(
//                           basicDataItemType: BasicDataItemType.string,
//                         )
//                       },
//                     )),
//                 namedTupleData: NamedTupleData(elementTypeConfig: {
//                   "value 1": DataItemType(
//                       basicDataItemType: BasicDataItemType.array,
//                       arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
//                           itemType: DataItemType(
//                               basicDataItemType: BasicDataItemType.namedTuple,
//                               namedTupleAuxiliaryTypeData:
//                                   NamedTupleAuxiliaryTypeData(
//                                       elementTypeConfig: {
//                                     "value 1": DataItemType(
//                                       basicDataItemType:
//                                           BasicDataItemType.string,
//                                     ),
//                                     "value 2": DataItemType(
//                                         basicDataItemType:
//                                             BasicDataItemType.array,
//                                         arrayAuxiliaryTypeData:
//                                             ArrayAuxiliaryTypeData(
//                                                 itemType: DataItemType(
//                                                     basicDataItemType:
//                                                         BasicDataItemType
//                                                             .string)))
//                                   })))),
//                   "value 2": DataItemType(
//                     basicDataItemType: BasicDataItemType.string,
//                   )
//                 }, elements: {
//                   "value 1": DataItem(
//                       dataItemType: DataItemType(
//                           basicDataItemType: BasicDataItemType.array,
//                           arrayAuxiliaryTypeData: ArrayAuxiliaryTypeData(
//                               itemType: DataItemType(
//                                   basicDataItemType:
//                                       BasicDataItemType.namedTuple,
//                                   namedTupleAuxiliaryTypeData:
//                                       NamedTupleAuxiliaryTypeData(
//                                           elementTypeConfig: {
//                                         "value 1": DataItemType(
//                                           basicDataItemType:
//                                               BasicDataItemType.string,
//                                         ),
//                                         "value 2": DataItemType(
//                                             basicDataItemType:
//                                                 BasicDataItemType.array,
//                                             arrayAuxiliaryTypeData:
//                                                 ArrayAuxiliaryTypeData(
//                                                     itemType: DataItemType(
//                                                         basicDataItemType:
//                                                             BasicDataItemType
//                                                                 .string)))
//                                       })))),
//                       arrayData: ArrayData(
//                           list: [],
//                           itemType: DataItemType(
//                               basicDataItemType:
//                               BasicDataItemType.namedTuple,
//                               namedTupleAuxiliaryTypeData:
//                               NamedTupleAuxiliaryTypeData(
//                                   elementTypeConfig: {
//                                     "value 1": DataItemType(
//                                       basicDataItemType:
//                                       BasicDataItemType.string,
//                                     ),
//                                     "value 2": DataItemType(
//                                         basicDataItemType:
//                                         BasicDataItemType.array,
//                                         arrayAuxiliaryTypeData:
//                                         ArrayAuxiliaryTypeData(
//                                             itemType: DataItemType(
//                                                 basicDataItemType:
//                                                 BasicDataItemType
//                                                     .string)))
//                                   }))
//                       )),
//                   "value 2": DataItem(
//                       dataItemType: DataItemType(
//                           basicDataItemType: BasicDataItemType.string),
//                       stringData: StringData(data: "world"))
//                 })),
//           ),
//         ),
//       ),
    );
  }
}
