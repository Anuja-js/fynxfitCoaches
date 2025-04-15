// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fynxfitcoaches/bloc/category/category_bloc.dart';
//
// import '../customs/custom_text.dart';
//
// class CategoryDropdown extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoryBloc, CategoryState>(
//       builder: (context, state) {
//         if (state is CategoryLoading) {
//           return CircularProgressIndicator();
//         } else if (state is CategoryError) {
//           return CustomText(text: "Error: ${state.message}");
//         } else if (state is CategoryLoaded) {
//           return DropdownButtonFormField<String>(
//             value: state.selectedCategory,
//             hint: CustomText(text: "Select Category", color: Colors.white),
//             dropdownColor: Colors.grey[800], // Dark dropdown background
//             items: state.categories.map((String category) {
//               return DropdownMenuItem<String>(
//                 value: category,
//                 child: CustomText(text: category, fontSize: 13.sp, color: Colors.white),
//               );
//             }).toList(),
//             onChanged: (newValue) {
//               if (newValue != null) {
//                 context.read<CategoryBloc>().add(SelectCategory(newValue));
//               }
//             },
//             icon: Icon(Icons.arrow_drop_down, color: Colors.white), // White arrow icon
//             style: TextStyle(color: Colors.white), // White text style
//           );
//         }
//         return Container(); // Default empty state
//       },
//     );
//   }
// }
