// lưu cây thư mục lại cho tôi 
// FITFUSION/ 
// ├── .idea/ # Cấu hình IDE (Android Studio/IntelliJ) 
// │ ├── caches/ 
// │ ├── libraries/ 
// │ ├── .gitignore 
// │ ├── FITFUSION.iml 
// │ ├── misc.xml 
// │ ├── modules.xml 
// │ ├── vcs.xml 
// │ └── workspace.xml 
// │ 
// ├── fitfusion_backend/ # Backend Node.js 
// │ ├── config/ # Cấu hình DB/môi trường 
// │ ├── controller/ 
// │ │ └── user.controller.js # Xử lý logic API user 
// │ ├── model/ 
// │ │ ├── user.model.js # Schema User (Mongoose) 
// │ │ └── userinfo.model.js # Schema UserInfo 
// │ ├── node_modules/ # Thư viện npm 
// │ ├── routers/ # Định tuyến API
// │ │ └── user.router.js
// │ ├── services/ # Xử lý nghiệp vụ 
// │ │ └── user.service.js
// │ ├── app.js # Khởi tạo Express 
// │ ├── index.js # Entry point backend 
// │ ├── package-lock.json 
// │ └── package.json # Dependencies backend 
// │ 
// ├── fitfusion_frontend/ # Frontend Flutter 
// │ ├── android/ 
// │ ├── ios/ 
// │ ├── lib/ 
// │ │ ├── mock_data/ 
// │ │ │ ├── data.json
// │ │ ├── main.dart 
// │ │ ├── screen/ 
// │ │ │ ├── calories/ 
// │ │ │ │ ├── calories_screen.dart 
// │ │ │ │ └── calories_summary.dart 
// │ │ │ ├── home.dart
// │ │ │ ├── intro.dart 
// │ │ │ ├── login.dart # Kết nối với backend 
// │ │ │ ├── profile.dart
// │ │ │ ├── register.dart  
// │ │ ├── detail/
// │ │ ├── models/ 
// │ │ │ └── user_info_model.dart # Model đồng bộ với backend
// │ │ │ └── meal_model.dart 
// │ │ ├── theme/ 
// │ │ │ └── theme.dart
// │ │ └── widgets/ 
// │ │ └── gender.dart
// │ │ └── inputfield.dart
// │ │ └── tabbar.dart
// │ │ └── widget_home.dart
// │ ├── assets/ 
// │ │ ├── body_img/ 
// │ │ └── logo.png 
// │ └── pubspec.yaml 
// │ 
// └── README.md # Hướng dẫn tổng thể

// const userService = require('../services/user.service');
// const UserInfoModel = require('../model/userInfo.model'); // Import missing model

// // Register
// exports.register = async (req, res, next) => {
//     try {
//         const { username, password } = req.body;
//         const successRes = await userService.registerUser(username, password);
//         res.json({ status: true, success: "User registered successfully" });
//     } catch (error) {
//         return res.status(500).json({ status: false, error: error.message });
//     }
// };

// // Login
// exports.login = async (req, res, next) => {
//     try {
//         const { username, password } = req.body;
//         const user = await userService.checkUser(username);

//         if (!user) {
//             return res.status(404).json({ status: false, error: "User doesn't exist" });
//         }

//         const isMatch = await user.comparePassword(password);
//         if (!isMatch) {
//             return res.status(401).json({ status: false, error: "Password is incorrect" });
//         }

//         let tokenData = { _id: user._id, username: user.username };
//         const token = await userService.generateToken(tokenData, 'secretKey', '1h');

//         return res.status(200).json({ status: true, token });
//     } catch (error) {
//         return res.status(500).json({ status: false, error: error.message });
//     }
// };

// // Create User Info
// exports.createUserInfo = async (req, res, next) => {
//     try {
//         const newUserInfo = await userService.createUserInfo(req.body);
//         res.status(201).json({ status: true, message: "User info created successfully", data: newUserInfo });
//     } catch (error) {
//         res.status(500).json({ status: false, error: error.message });
//     }
// };

// // Update User Info
// exports.updateUserInfo = async (req, res, next) => {
//     try {
//         const { userId } = req.params;
//         const updatedUser = await userService.updateUserInfo(userId, req.body);

//         if (!updatedUser) {
//             return res.status(404).json({ status: false, error: "User not found" });
//         }

//         res.status(200).json({ status: true, message: "User info updated successfully", data: updatedUser });
//     } catch (error) {
//         res.status(500).json({ status: false, error: error.message });
//     }
// };
// exports.getUserInfo = async (req, res, next) => {
//     try {
//         const { userId } = req.body; // Lấy userId từ req.body

//         console.log("Received userId:", userId); // Debugging log

//         if (!userId) {
//             return res.status(400).json({ status: false, error: "Missing userId in request body" });
//         }

//         const displayUserInfo = await userService.showUserInfo(userId);

//         if (!displayUserInfo) {
//             return res.status(404).json({ status: false, error: "User not found" });
//         }

//         res.status(200).json({ status: true, data: displayUserInfo });
//     } catch (error) {
//         res.status(500).json({ status: false, error: error.message });
//     }
// };

// đây là code của user.controller.js

// const mongoose =  require('mongoose');
// const db = require('../config/db');
// const bcrypt = require('bcrypt');
// const { Schema } = mongoose;
// const { v4: uuidv4 } = require('uuid');

// const useSchema = new mongoose.Schema({
//     userId: { type: String, default: uuidv4 }, 
//     username: { type: String, required: true, unique: true },
//     password: { type: String, required: true },
// });
// useSchema.pre('save', async function (next) {
//     try {
//         if (!this.isModified("password")) return next();
        
//         const salt = await bcrypt.genSalt(10);
//         this.password = await bcrypt.hash(this.password, salt);
        
//         next();
//     } catch (error) {
//         next(error);
//     }
// });

// useSchema.methods.comparePassword = async function (userPassword) {
//     try {
//         return await bcrypt.compare(userPassword, this.password);
//     } catch (error) {
//         throw error;
//     }
// };

// const UserModel = db.model('user',useSchema);

// module.exports = UserModel;
// đây là code của user.model.js

// const mongoose = require('mongoose');
// const db = require('../config/db');
// const { v4: uuidv4 } = require('uuid');

// const userSchema = new mongoose.Schema({
//     userId: { type: String, required: true, unique: true, default: uuidv4 },
//     fullname: { type: String },
//     gender: { type: String, enum: ["Male", "Female", "Other"] },
//     weight: { type: Number },
//     height: { type: Number },
//     age: { type: Number },
//     status: { type: String },
//     finishDate: { type: Date },
//     startDate: { type: Date, default: Date.now },
//     aimWeight: { type: Number },
//     phone: { type: String }
// });

// const UserInfoModel = db.model('userInfo', userSchema);

// module.exports = UserInfoModel;
// đây là code của userinfo.model.js

// const UserModel = require('../model/user.model');
// const UserInfoModel = require('../model/userInfo.model'); // Import UserInfoModel
// const jwt = require('jsonwebtoken');
// const { v4: uuidv4 } = require('uuid');

// class userService {
//     // Register a new user
//     static async registerUser(username, password) {
//         try {
//             const createUser = new UserModel({ username, password });
//             return await createUser.save();
//         } catch (err) {
//             throw err;
//         }
//     }

//     // Check if a user exists
//     static async checkUser(username) {
//         try {
//             return await UserModel.findOne({ username });
//         } catch (err) {
//             throw err;
//         }
//     }

//     // Generate JWT Token
//     static async generateToken(tokenData, secretKey, jwt_expire) {
//         return jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
//     }

//     // Create User Info with UUID
//     static async createUserInfo(data) {
//         try {
//             data.userId = uuidv4(); // Generate UUID for userId
//             const newUserInfo = new UserInfoModel(data);
//             return await newUserInfo.save();
//         } catch (err) {
//             throw err;
//         }
//     }

//     // Update User Info
//     static async updateUserInfo(userId, updatedData) {
//         try {
//             return await UserInfoModel.findOneAndUpdate(
//                 { userId },
//                 updatedData,
//                 { new: true } // Returns the updated document
//             );
//         } catch (err) {
//             throw err;
//         }
//     }
//     static async showUserInfo(userId) {
//         try {
//             return await UserInfoModel.findOne({ userId });
//         } catch (error) {
//             throw error; // Fix: Throw 'error', not 'err'
//         }
//     }
    
// }

// module.exports = userService;
// đây là code của user.service.js

// const express = require('express');
// const body_paser = require('body-parser');
// const userRouter = require('./routers/user.router');

// const app = express();
// app.use(body_paser.json());

// app.use('/',userRouter);
// module.exports = app;
// đây là code của app.js

// const app = require('./app');
// const db = require('./config/db');
// const port = 3000;
// const UserModel = require('./model/user.model');
// app.listen(port,()=>{
//     console.log(Sever listening in port : ${port});
// });
// đây là code của index.js


// {
//     "success": true,
//     "data": {
//         "breakfast": {
//             "dishName": "Oatmeal with Berries and Nuts",
//             "ingredients": [
//                 "1/2 cup rolled oats",
//                 "1 cup unsweetened almond milk",
//                 "1/2 cup mixed berries (strawberries, blueberries, raspberries)",
//                 "1/4 cup chopped almonds",
//                 "1 tablespoon chia seeds",
//                 "Pinch of cinnamon"
//             ],
//             "instructions": "1. Combine oats and almond milk in a saucepan. 2. Bring to a boil, then reduce heat and simmer for 5-7 minutes, stirring occasionally. 3. Stir in chia seeds and cinnamon. 4. Top with berries and almonds. Serve warm.",
//             "calories": 400,
//             "macronutrients": {
//                 "protein": 15,
//                 "carbs": 55,
//                 "fats": 15
//             },
//             "note": "High in fiber and protein, keeps you full for longer and helps manage weight. The complex carbs provide sustained energy."
//         },
//         "lunch": {
//             "dishName": "Grilled Chicken Salad with Mixed Greens",
//             "ingredients": [
//                 "4 oz grilled chicken breast",
//                 "3 cups mixed greens (spinach, romaine, kale)",
//                 "1/2 cup sliced cucumber",
//                 "1/4 cup cherry tomatoes",
//                 "1/4 cup bell peppers (various colors)",
//                 "2 tablespoons olive oil and vinegar dressing",
//                 "Optional: 1/4 avocado"
//             ],
//             "instructions": "1. Grill or pan-fry the chicken breast until cooked through. Let it rest for a few minutes and then slice. 2. Combine mixed greens, cucumber, tomatoes, and bell peppers in a large bowl. 3. Add the sliced chicken. 4. Drizzle with olive oil and vinegar dressing. 5. Add avocado (optional).",
//             "calories": 450,
//             "macronutrients": {
//                 "protein": 40,
//                 "carbs": 20,
//                 "fats": 25
//             },
//             "note": "Lean protein source (chicken) paired with a large volume of vegetables.  The healthy fats from the avocado and olive oil dressing contribute to satiety."
//         },
//         "dinner": {
//             "dishName": "Baked Pork Tenderloin with Roasted Broccoli",
//             "ingredients": [
//                 "4 oz pork tenderloin",
//                 "1 cup broccoli florets",
//                 "1 tablespoon olive oil",
//                 "Salt and pepper to taste",
//                 "1/2 cup Quinoa cooked"
//             ],
//             "instructions": "1. Preheat oven to 400°F (200°C). 2. Toss broccoli florets with olive oil, salt, and pepper. Spread on a baking sheet. 3. Season pork tenderloin with salt and pepper. 4. Place pork tenderloin on the same baking sheet with the broccoli. 5. Bake for 20-25 minutes, or until pork is cooked through and broccoli is tender. 6. Serve with 1/2 cup cooked quinoa.",
//             "calories": 550,
//             "macronutrients": {
//                 "protein": 45,
//                 "carbs": 35,
//                 "fats": 25
//             },
//             "note": "Provides lean protein from pork tenderloin and fiber from broccoli and quinoa. Roasting minimizes added fats."
//         },
//         "nutrition": {
//             "calories": 1400,
//             "protein": 100,
//             "carbs": 110,
//             "fats": 65
//         }
//     }
// }
// đây là code của data.json

// class UserInfoModel {
//   final String fullname;
//   String? gender;
//   double? height;
//   double? weight;
//   double? aimWeight;
//   int? age;
//   double bmi = 0.0;
//   double bmiAim = 0.0;
//   String? goal;
//   double weightLossPercentage = 0.0;
//   DateTime? aimDate;
//   String? health;

//   UserInfoModel({
//     required this.fullname,
//     this.gender,
//     this.height,
//     this.weight,
//     this.aimWeight,
//     this.age,
//     this.goal,
//     this.aimDate,
//     this.health,
//   });

//   void calculateBMI() {
//     if (height != null && weight != null && height! > 0) {
//       bmi = weight! / ((height! / 100) * (height! / 100));
//     } else {
//       bmi = 0.0;
//     }
//   }

//   String get bmiStatus {
//     if (bmi < 18.5) {
//       return "Gầy";
//     } else if ((bmi >= 18.5) && (bmi <= 24.9)) {
//       return "Bình thường";
//     } else if ((bmi > 24.9) && (bmi <= 29.9)) {
//       return "Thừa cân";
//     } else if((bmi > 29.9) && (bmi <= 34.9)){
//       return "Béo phì";
//     } else {
//       return "Nguy hiểm";
//     }
//   }

//   void calculateBMIAim() {
//     if (height != null && aimWeight != null && height! > 0) {
//       bmiAim = aimWeight! / ((height! / 100) * (height! / 100));
//     } else {
//       bmiAim = 0.0;
//     }
//   }

//   void calculateWeightLossPercentage() {
//     if (weight != null && aimWeight != null && weight! > 0) {
//       weightLossPercentage = ((weight! - aimWeight!) / weight!) * 100;
//     } else {
//       weightLossPercentage = 0.0;
//     }
//   }

//   factory UserInfoModel.fromJson(Map<String, dynamic> json) {
//     return UserInfoModel(
//       fullname: json['fullname'],
//       gender: json['gender'],
//       height: (json['height'] as num?)?.toDouble(),
//       weight: (json['weight'] as num?)?.toDouble(),
//       aimWeight: (json['aimWeight'] as num?)?.toDouble(),
//       age: json['age'] as int?,
//       goal: json['goal'],
//       aimDate: json['aimDate'] != null ? DateTime.parse(json['aimDate']) : null,
//       health: json['health'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'fullname': fullname,
//       'gender': gender,
//       'height': height,
//       'weight': weight,
//       'aimWeight': aimWeight,
//       'age': age,
//       'goal': goal,
//       'weightLossPercentage': weightLossPercentage,
//       'aimDate': aimDate?.toIso8601String(),
//       'health': health,
//     };
//   }
// }
// đây là code của user_info_model.dart


// import 'package:fitfusion_frontend/models/user_info_model.dart';
// import 'package:flutter/material.dart';
// import 'package:fitfusion_frontend/theme/theme.dart';
// import 'calories_summary.dart';
// import 'package:flutter/services.dart';

// class CaloriesScreen extends StatefulWidget {
//   final UserInfoModel userInfo;

//   const CaloriesScreen({
//     super.key,
//     required this.userInfo,
//   });

//   @override
//   CaloriesScreenState createState() => CaloriesScreenState();
// }

// class CaloriesScreenState extends State<CaloriesScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<Map<String, dynamic>> _selectedFoods = [];
//   Map<String, dynamic>? _selectedFood;
//   int _quantity = 100;
//   bool _showAddPanel = false;
//   List<Map<String, dynamic>> _foodList = [];
//   List<Map<String, dynamic>> _filteredFoodList = [];
//   bool _showNotFound = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadFoodData();
//   }

//   Future<void> _loadFoodData() async {
//     final mockData = [
//       {
//         'name': 'Cơm',
//         'calories': 130,
//         'protein': 3,
//         'carb': 28,
//         'fats': 0.3,
//         'unit': 'bát',
//         'type': 'rice',
//         'baseUnit': 'bát',
//         'baseQuantity': 1,
//         'baseCalories': 130,
//       },
//       {
//         'name': 'Chuối',
//         'calories': 89,
//         'protein': 1.1,
//         'carb': 23,
//         'fats': 0.3,
//         'unit': 'trái',
//         'type': 'fruit',
//         'baseUnit': 'trái',
//         'baseQuantity': 1,
//         'baseCalories': 89,
//       },
//       {
//         'name': 'Thịt gà luộc',
//         'calories': 165,
//         'protein': 31,
//         'carb': 0,
//         'fats': 3.6,
//         'unit': '100g',
//         'type': 'meat',
//         'baseUnit': '100g',
//         'baseQuantity': 1,
//         'baseCalories': 165,
//       },
//       {
//         'name': 'Trứng gà',
//         'calories': 155,
//         'protein': 13,
//         'carb': 1.1,
//         'fats': 11,
//         'unit': 'quả',
//         'type': 'egg',
//         'baseUnit': 'quả',
//         'baseQuantity': 1,
//         'baseCalories': 155,
//       },
//       {
//         'name': 'Bánh mì sandwich',
//         'calories': 265,
//         'protein': 9,
//         'carb': 49,
//         'fats': 3.2,
//         'unit': 'ổ',
//         'type': 'bread',
//         'baseUnit': 'ổ',
//         'baseQuantity': 1,
//         'baseCalories': 265,
//       },
//       {
//         'name': 'Sữa tươi không đường',
//         'calories': 62,
//         'protein': 3.2,
//         'carb': 4.8,
//         'fats': 3.3,
//         'unit': '100ml',
//         'type': 'dairy',
//         'baseUnit': '100ml',
//         'baseQuantity': 1,
//         'baseCalories': 62,
//       },
//       {
//         'name': 'Cá hồi áp chảo',
//         'calories': 206,
//         'protein': 22,
//         'carb': 0,
//         'fats': 13,
//         'unit': '100g',
//         'type': 'fish',
//         'baseUnit': '100g',
//         'baseQuantity': 1,
//         'baseCalories': 206,
//       },
//       {
//         'name': 'Rau xà lách',
//         'calories': 15,
//         'protein': 1.4,
//         'carb': 2.9,
//         'fats': 0.2,
//         'unit': '100g',
//         'type': 'vegetable',
//         'baseUnit': '100g',
//         'baseQuantity': 1,
//         'baseCalories': 15,
//       },
//       {
//         'name': 'Táo',
//         'calories': 52,
//         'protein': 0.3,
//         'carb': 14,
//         'fats': 0.2,
//         'unit': 'trái',
//         'type': 'fruit',
//         'baseUnit': 'trái',
//         'baseQuantity': 1,
//         'baseCalories': 52,
//       },
//       {
//         'name': 'Phở bò',
//         'calories': 450,
//         'protein': 24,
//         'carb': 50,
//         'fats': 15,
//         'unit': 'tô',
//         'type': 'noodle',
//         'baseUnit': 'tô',
//         'baseQuantity': 1,
//         'baseCalories': 450,
//       },

//       // ... (thêm các món khác)
//     ];

//     setState(() {
//       _foodList = mockData;
//       _filteredFoodList = mockData;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'TÍNH CALORIES',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         centerTitle: true, // Đảm bảo tiêu đề ở giữa
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Ô tìm kiếm
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Tìm kiếm món ăn...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: _searchFood,
//                 ),
//                 filled: true,
//                 fillColor: AppColors.gray,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               inputFormatters: [
//                 FilteringTextInputFormatter.deny(
//                     RegExp(r'[0-9]')), // Không cho nhập số
//               ],
//               onChanged: (value) => _searchFood(),
//             ),
//             const SizedBox(height: 20),

//             // Thông báo không tìm thấy
//             if (_showNotFound)
//               const Text('Không tìm thấy món ăn phù hợp',
//                   style: TextStyle(color: Colors.red)),
//             const SizedBox(height: 10),

//             // Danh sách món ăn
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _filteredFoodList.length,
//                 itemBuilder: (context, index) {
//                   final food = _filteredFoodList[index];
//                   return Card(
//                     color: AppColors.background,
//                     margin: const EdgeInsets.only(bottom: 10),
//                     child: ListTile(
//                       title: Text(food['name'],
//                           style: AppTextStyles.little_title_1),
//                       subtitle:
//                           Text('${food['unit']} - ${food['calories']} calo'),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.add, color: AppColors.primary),
//                         onPressed: () => _showAddFoodPanel(food),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Panel thêm món
//             if (_showAddPanel && _selectedFood != null) ...[
//               _buildAddFoodPanel(),
//               const SizedBox(height: 10),
//             ],

//             // Nút tiếp tục
//             ElevatedButton(
//               style: ButtonStyles.buttonTwo,
//               onPressed: _selectedFoods.isNotEmpty ? _goToSummary : null,
//               child: const Text('TIẾP TỤC', style: AppTextStyles.textButtonTwo),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddFoodPanel() {
//     final food = _selectedFood!;
//     // final isRice = food['type'] == 'rice';
//     // final isFruit = food['type'] == 'fruit';

//     return Card(
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(food['name'], style: AppTextStyles.little_title_1),
//             const SizedBox(height: 10),

//             // Nhập số lượng theo đơn vị phù hợp
//             TextField(
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Số lượng ${food['baseUnit']}',
//                 border: const OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _quantity = int.tryParse(value) ?? 0;
//                 });
//               },
//             ),
//             const SizedBox(height: 10),

//             // Thông tin dinh dưỡng
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Calories: ${_calculateCalories()} calo'),
//                 Text('Protein: ${_calculateNutrient('protein')}g'),
//                 Text('Carb: ${_calculateNutrient('carb')}g'),
//                 Text('Fats: ${_calculateNutrient('fats')}g'),
//               ],
//             ),
//             const SizedBox(height: 10),

//             // Nút OK
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => setState(() => _showAddPanel = false),
//                   child: const Text('HỦY'),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: _addFoodToMenu,
//                   style: ButtonStyles.buttonOne,
//                   child: const Text('OK'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   double _calculateNutrient(String nutrient) {
//     if (_selectedFood == null || _quantity <= 0) return 0;
//     return (_selectedFood![nutrient] *
//         _quantity /
//         _selectedFood!['baseQuantity']);
//   }

//   int _calculateCalories() {
//     if (_selectedFood == null || _quantity <= 0) return 0;
//     return (_selectedFood!['baseCalories'] * _quantity).round();
//   }

//   void _searchFood() {
//     final query = _searchController.text.trim().toLowerCase();
//     if (query.isEmpty) {
//       setState(() {
//         _filteredFoodList = _foodList;
//         _showNotFound = false;
//       });
//       return;
//     }

//     final normalizedQuery = _removeVietnameseAccent(query);
//     final results = _foodList.where((food) {
//       final foodName = food['name'].toLowerCase();
//       return _removeVietnameseAccent(foodName).contains(normalizedQuery) ||
//           foodName.contains(query);
//     }).toList();

//     setState(() {
//       _filteredFoodList = results;
//       _showNotFound = results.isEmpty;
//     });
//   }

//   String _removeVietnameseAccent(String str) {
//     str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a');
//     str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e');
//     str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), 'i');
//     str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o');
//     str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u');
//     str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y');
//     str = str.replaceAll(RegExp(r'[đ]'), 'd');
//     return str;
//   }

//   void _showAddFoodPanel(Map<String, dynamic> food) {
//     setState(() {
//       _selectedFood = food;
//       _showAddPanel = true;
//       _quantity = 100;
//     });
//   }

//   void _addFoodToMenu() {
//     if (_selectedFood == null || _quantity <= 0) return;

//     setState(() {
//       _selectedFoods.add({
//         ..._selectedFood!,
//         'selected_quantity': _quantity,
//         'total_calories': _calculateCalories(),
//         'total_protein': _calculateNutrient('protein'),
//         'total_carb': _calculateNutrient('carb'),
//         'total_fats': _calculateNutrient('fats'),
//       });
//       _showAddPanel = false;
//     });
//   }

//   void _goToSummary() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CaloriesSummaryScreen(
//           selectedFoods: _selectedFoods,
//           userInfo: widget.userInfo,
//         ),
//       ),
//     );
//   }
// }
// // đây là code của calories_screen.dart

// import 'package:flutter/material.dart';
// import 'package:fitfusion_frontend/theme/theme.dart';
// import 'nutrition_summary.dart';
// import 'package:fitfusion_frontend/models/user_info_model.dart';

// class CaloriesSummaryScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> selectedFoods;
//   final UserInfoModel userInfo;

//   const CaloriesSummaryScreen({
//     super.key,
//     required this.selectedFoods,
//     required this.userInfo,
//   });

//   // Hàm gộp các món ăn cùng loại
//   List<Map<String, dynamic>> get _groupedFoods {
//     final Map<String, Map<String, dynamic>> foodMap = {};

//     for (final food in selectedFoods) {
//       final name = food['name'];
//       if (foodMap.containsKey(name)) {
//         // Cộng dồn nếu đã có món này
//         foodMap[name]!['selected_quantity'] += food['selected_quantity'];
//         foodMap[name]!['total_calories'] += food['total_calories'];
//         foodMap[name]!['total_protein'] += food['total_protein'];
//         foodMap[name]!['total_carb'] += food['total_carb'];
//         foodMap[name]!['total_fats'] += food['total_fats'];
//       } else {
//         // Thêm mới nếu chưa có
//         foodMap[name] = {...food};
//       }
//     }

//     return foodMap.values.toList();
//   }

//   // Hàm xóa món ăn
//   void _removeFood(int index, BuildContext context) {
//     //xóa toàn bộ món cùng loại
//     final foodName = _groupedFoods[index]['name'];
//     selectedFoods.removeWhere((food) => food['name'] == foodName);

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CaloriesSummaryScreen(
//           selectedFoods: selectedFoods,
//           userInfo: userInfo,
//         ),
//       ),
//     );
//   }

//   int get _totalCalories {
//     return selectedFoods.fold(
//         0, (sum, item) => sum + (item['total_calories'] as int));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final groupedFoods = _groupedFoods;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'TÍNH CALORIES',
//             style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         backgroundColor: AppColors.primary,
//         centerTitle: true, // Đảm bảo tiêu đề ở giữa
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text('Danh sách món ăn:',
//                 style: AppTextStyles.little_title_1),
//             const SizedBox(height: 10),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: groupedFoods.length,
//                 itemBuilder: (context, index) {
//                   final food = groupedFoods[index];
//                   return Dismissible(
//                     key: Key(food['name'] + index.toString()),
//                     background: Container(color: Colors.red),
//                     onDismissed: (direction) => _removeFood(index, context),
//                     child: ListTile(
//                       title: Text(
//                         food['name'],
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold, // Thêm dòng này
//                           fontSize: 18, // Tăng kích thước chữ nếu cần
//                         ),
//                       ),
//                       subtitle: Text(
//                         '${food['selected_quantity']} ${food['baseUnit']} - ${food['total_calories']} calo',
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16), // Làm chữ to hơn
//                       ),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () => _removeFood(index, context),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Nút Tổng Calo
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 textStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 5,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NutritionSummaryScreen(
//                       totalCalories: _totalCalories,
//                       foods: selectedFoods,
//                       userInfo: userInfo,
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('TỔNG CALO'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// đây là code của calories_summary.dart

// import 'package:flutter/material.dart';
// import 'package:fitfusion_frontend/theme/theme.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../home.dart';
// import 'package:fitfusion_frontend/models/user_info_model.dart';

// class NutritionSummaryScreen extends StatelessWidget {
//   final int totalCalories;
//   final List<Map<String, dynamic>> foods;
//   final UserInfoModel userInfo;

//   const NutritionSummaryScreen({
//     super.key,
//     required this.totalCalories,
//     required this.foods,
//     required this.userInfo,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Calculate total nutrients
//     double totalProtein = foods.fold(0, (sum, food) => sum + (food['total_protein'] ?? 0));
//     double totalCarb = foods.fold(0, (sum, food) => sum + (food['total_carb'] ?? 0));
//     double totalFats = foods.fold(0, (sum, food) => sum + (food['total_fats'] ?? 0));

//     // Calculate percentages
//     double proteinPercentage = (totalProtein * 4 / totalCalories * 100);
//     double carbPercentage = (totalCarb * 4 / totalCalories * 100);
//     double fatsPercentage = (totalFats * 9 / totalCalories * 100);

//     // Warning conditions
//     bool showCalorieWarning = totalCalories > 700;
//     bool showFatWarning = totalFats > 20;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Tổng dinh dưỡng', style: AppTextStyles.little_title),
//         backgroundColor: AppColors.primary,
//       ),
//       body: Column(
//         children: [
//           // Total calories section
//           Container(
//             height: MediaQuery.of(context).size.height * 0.3,
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Tổng calo:',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black54,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '$totalCalories calo',
//                   style: const TextStyle(
//                     fontSize: 42,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 // Calorie warning
//                 if (showCalorieWarning)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text(
//                       'Cảnh báo: Lượng calo vượt mức tiêu chuẩn!',
//                       style: TextStyle(
//                         color: AppColors.primary,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 // Fat warning (shown here if you want it with calories)
//                 if (showFatWarning)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text(
//                       'Cảnh báo: Lượng chất béo (${totalFats.toStringAsFixed(1)}g) vượt 20g!',
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
          
//           // Nutrition details section
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Text(
//                     'Bảng thành phần dinh dưỡng',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
                  
//                   // Nutrition info row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildNutrientInfo('Protein', proteinPercentage, Colors.blue),
//                       _buildNutrientInfo('Carb', carbPercentage, Colors.green),
//                       _buildNutrientInfo('Fats', fatsPercentage, Colors.orange),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // Pie chart
//                   SizedBox(
//                     height: 200,
//                     child: PieChart(
//                       PieChartData(
//                         sections: [
//                           PieChartSectionData(
//                             value: proteinPercentage,
//                             color: Colors.blue,
//                             title: 'Protein\n${proteinPercentage.toStringAsFixed(1)}%',
//                             radius: 50,
//                             titleStyle: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           PieChartSectionData(
//                             value: carbPercentage,
//                             color: Colors.green,
//                             title: 'Carb\n${carbPercentage.toStringAsFixed(1)}%',
//                             radius: 50,
//                             titleStyle: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           PieChartSectionData(
//                             value: fatsPercentage,
//                             color: Colors.orange,
//                             title: 'Fats\n${fatsPercentage.toStringAsFixed(1)}%',
//                             radius: 50,
//                             titleStyle: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
                  
//                   // Fat warning (alternative position - shown here if you prefer)
//                   if (showFatWarning)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16),
//                       child: Text(
//                         'Cảnh báo: Lượng chất béo (${totalFats.toStringAsFixed(1)}g) vượt 20g!',
//                         style: const TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
                  
//                   const Spacer(),
                  
//                   // Home button
//                   ElevatedButton(
//                     style: ButtonStyles.buttonTwo,
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HomeScreen(userInfo: userInfo),
//                         ),
//                         (Route<dynamic> route) => false,
//                       );
//                     },
//                     child: const Text('TRANG CHỦ', style: AppTextStyles.textButtonTwo),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper widget for nutrition info
//   Widget _buildNutrientInfo(String name, double percentage, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 20,
//           height: 20,
//           color: color,
//         ),
//         const SizedBox(height: 5),
//         Text(
//           name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Text('${percentage.toStringAsFixed(1)}%'),
//       ],
//     );
//   }
// }
// đây là code của nutrition_summary.dart

// import 'package:flutter/material.dart';
// import '../models/user_info_model.dart';
// import '../theme/theme.dart';
// import '../widgets/tabbar.dart';
// import '../widgets/widget_home.dart';
// // import '../screens/coach_screen.dart';
// // import '../screens/calories_screen.dart';
// // import '../screens/workout_screen.dart';
// // import '../screens/nutrition_screen.dart';
// import 'calories/calories_screen.dart';

// class HomeScreen extends StatelessWidget {
//   final UserInfoModel userInfo;

//   const HomeScreen({super.key, required this.userInfo});

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(gradient: appGradient),
//         child: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(height: screenHeight * 0.03),
//               AppBarCustomHeader(fullname: userInfo.fullname),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       UserImageWidget(
//                           userInfo: userInfo,
//                           screenWidth: screenWidth,
//                           screenHeight: screenHeight),
//                       SizedBox(height: screenHeight * 0.02),
//                       FeatureButton(
//                         title: "HLV Cá nhân",
//                         image: "assets/coach.png",
//                         gradientColors: [Color(0xFF54CAF7), Colors.white],
//                         isTextLeft: true,
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => CoachScreen()),
//                           // );
//                         },
//                       ),
//                       FeatureButton(
//                         title: "Tính Calories",
//                         image: "assets/calories.png",
//                         gradientColors: [Colors.white, Color(0xFFF7C818)],
//                         isTextLeft: false,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const CaloriesScreen()),
//                           );
//                         },
//                       ),
//                       FeatureButton(
//                         title: "Bài tập tại nhà",
//                         image: "assets/workout.png",
//                         gradientColors: [Color(0xFF9CB327), Colors.white],
//                         isTextLeft: true,
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => WorkoutScreen()),
//                           // );
//                         },
//                       ),
//                       FeatureButton(
//                         title: "Chế độ dinh dưỡng",
//                         image: "assets/nutrition.png",
//                         gradientColors: [Colors.white, Color(0xFFF48221)],
//                         isTextLeft: false,
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => NutritionScreen()),
//                           // );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// đây là code của home.dart

// import 'package:flutter/material.dart';
// import '../theme/theme.dart';
// import 'login.dart';
// import 'register.dart';

// class IntroApp extends StatelessWidget {
//   const IntroApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(                                                                                                
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: appGradient, // Áp dụng gradient từ theme.dart
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
//           children: [
//             // Hình ảnh logo
//             Image.asset(
//               'assets/logo.png',
//               width: 300, // Điều chỉnh kích thước ảnh
//             ),

//             // Phần chữ và nút bấm
//             Column(
//               children: [
//                 const Text("FITFUSION", style: AppTextStyles.title),
//                 const SizedBox(height: 8),
//                 const Text("SỐNG CÂN BẰNG, SỐNG TỐT", style: AppTextStyles.subtitle),
//                 const SizedBox(height: 40),

//                 // Nút Đăng Nhập
//                 ElevatedButton(
//                   style: ButtonStyles.buttonOne,
//                   onPressed: () {
//                     Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>LoginScreen()), 
//                 );
//                   }, // Xử lý đăng nhập
//                   child: const Text("ĐĂNG NHẬP", style: AppTextStyles.textButtonOne),
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   style: ButtonStyles.buttonTwo,
//                   onPressed: () {
//                      Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterScreen()), 
//                 );
//                   }, // Xử lý đăng ký
//                   child: const Text("ĐĂNG KÝ", style: AppTextStyles.textButtonTwo),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: TextButton(
//                 onPressed: () {}, // Xử lý khi bấm quên mật khẩu
//                 child: const Text("Forgot your password?", style: AppTextStyles.forgotPassword),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 
// đây là code của intro.dart

// import 'package:fitfusion_frontend/widgets/tabbar.dart';
// import 'package:flutter/material.dart';
// import '../theme/theme.dart'; // Import theme
// import '../widgets/inputfield.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: appGradient,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const AppBarCustom(),
//               const SizedBox(height: 20),
//               Image.asset(
//                 'assets/logo.png',
//                 width: 250,
//               ),
//               const SizedBox(height: 30),
//               const InputField(label: "Tên đăng nhập"),
//               const SizedBox(height: 10),
//               const InputField(label: "Mật khẩu", isPassword: true),
//               const SizedBox(height: 40),
//               // Button ĐĂNG NHẬP
//               ElevatedButton(
//                 style: ButtonStyles.buttonTwo,
//                 onPressed: () {}, // Xử lý đăng nhập
//                 child: const Text(
//                   "ĐĂNG NHẬP",
//                   style: AppTextStyles.textButtonTwo,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // "Quên mật khẩu"
//               Center(
//                 child: TextButton(
//                   onPressed: () {}, // Xử lý khi bấm quên mật khẩu
//                   child: const Text(
//                     "Forgot your password?",
//                     style: AppTextStyles.forgotPassword,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// đây là code của login.dart

// import '../widgets/tabbar.dart';
// import 'package:flutter/material.dart';
// import '../theme/theme.dart'; // Import theme
// import '../widgets/inputfield.dart';

// class setProfile extends StatelessWidget {
//   const setProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: appGradient,
//         ),
//       )
//     );
//   }
// }
// đây là code của profile.dart

// import 'package:flutter/material.dart';
// import '../models/user_info_model.dart';
// import '../widgets/tabbar.dart';
// import '../theme/theme.dart';
// import '../widgets/inputfield.dart';
// import 'detail/detail_gender.dart';

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController fullnameController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     fullnameController.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: appGradient,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const AppBarCustom(),
//               const SizedBox(height: 20),

//               Image.asset(
//                 'assets/logo.png',
//                 width: 200,
//               ),
//               const SizedBox(height: 10),

//               InputField(label: "Họ và tên", controller: fullnameController),
//               const SizedBox(height: 10),

//               InputField(label: "Tên đăng nhập", controller: usernameController),
//               const SizedBox(height: 10),

//               InputField(label: "Mật khẩu", controller: passwordController, isPassword: true),
//               const SizedBox(height: 10),

//               InputField(label: "Nhập lại mật khẩu", controller: confirmPasswordController, isPassword: true),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                 style: ButtonStyles.buttonTwo,
//                 onPressed: () {
//                   if (passwordController.text == confirmPasswordController.text) {
//                     UserInfoModel userInfo = UserInfoModel(
//                       fullname: fullnameController.text,
//                     );

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => GenderSelectionScreen(userInfo: userInfo),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Mật khẩu không khớp!")),
//                     );
//                   }
//                 },
//                 child: const Text("ĐĂNG KÝ", style: AppTextStyles.textButtonTwo),
//               ),

//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// } 
// đây là code của register.dart

// import 'package:flutter/material.dart';

// class AppColors {
//   static const Color primary = Color(0xFFB3261E); // Màu chính (đỏ)
//   static const Color primaryHalf = Color(0x7FB3261E); // Màu chính mờ (50%)
//   static const Color secondary = Color(0xFFD78C88); // Màu phụ
//   static const Color background = Color(0xFFFFFFFF); // Màu nền trắng
//   static const Color textPrimary = Color(0xFFFFFFFF); // Màu chữ chính (trắng)
//   static const Color textSecondary = Color(0xFFB3261E); // Màu chữ phụ (xám)
//   static const Color buttonBg = Color(0x7FB3261E); // Nền button đỏ mờ
//   static const Color buttonText = Color(0xFFFFFFFF); // Chữ trên button
//   static const Color text = Color.fromARGB(255, 0, 0, 0); // Chữ trên button
// }

// class AppTextStyles {
//   static const TextStyle title = TextStyle(
//     fontSize: 40,
//     fontWeight: FontWeight.w900,
//     color: AppColors.textPrimary,
//   );
//   static const TextStyle subtitle = TextStyle(
//     fontSize: 25,
//     fontWeight: FontWeight.bold,
//     fontStyle: FontStyle.italic, // Chữ nghiêng
//     color: AppColors.textSecondary,
//   );
//   static const TextStyle little_title = TextStyle( 
//     fontSize: 20,
//     fontWeight: FontWeight.w900,
//     color: AppColors.textPrimary,
//   );
//     static const TextStyle little_title_1 = TextStyle( 
//     fontSize: 20,
//     fontWeight: FontWeight.w900,
//     color: AppColors.text,
//   );
//   static const TextStyle textButtonOne = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: AppColors.textSecondary,
//   );
//   static const TextStyle textButtonTwo = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: AppColors.textPrimary,
//   );
//   static const TextStyle forgotPassword = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.bold,
//     color: AppColors.textSecondary,
//     decoration: TextDecoration.underline,
//   );
//   static const TextStyle text = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: AppColors.textPrimary,
//   );
//   static const TextStyle normal = TextStyle(
//     fontSize: 10,
//     fontWeight: FontWeight.normal,
//     color: Color.fromARGB(255, 0, 0, 0),
//   );
// }
// class ButtonStyles {
//   static final ButtonStyle buttonOne = ElevatedButton.styleFrom(
//     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//     minimumSize: const Size(200, 50),
//   );
//   static final ButtonStyle buttonTwo = ElevatedButton.styleFrom(
//     backgroundColor: AppColors.primary, 
//     minimumSize: const Size(200, 50),
//   );
// }
// ///background
// const LinearGradient appGradient = LinearGradient(
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   colors: [AppColors.primary, AppColors.secondary, AppColors.background],
// );

// const LinearGradient boxGradient = LinearGradient(
//   begin: Alignment.topCenter,
//   end: Alignment.bottomCenter,
//   colors:[ Color(0xFF999999), AppColors.background],
//   );
// đây là code của theme.dart

// import 'package:flutter/material.dart';
// import '../theme/theme.dart';

// class GenderOptionWidget extends StatelessWidget {
//   final String gender;
//   final String imagePath;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const GenderOptionWidget({
//     super.key,
//     required this.gender,
//     required this.imagePath,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//   child: GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isSelected ? (gender == "Nam" ? Colors.blue : Colors.pink) : Colors.transparent,
//           width: 3,
//         ),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(
//             imagePath,
//             width: MediaQuery.of(context).size.width * 0.35,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             gender,
//             style: isSelected ? AppTextStyles.textButtonOne : AppTextStyles.textButtonTwo,
//           ),
//         ],
//       ),
//     ),
//   ),
// );

//   }
// }
// đây là code của gender.dart

// import 'package:flutter/material.dart';
// import '../theme/theme.dart';
// import 'package:flutter/services.dart';


// class InputField extends StatelessWidget {
//   final String label;
//   final bool isPassword;
//   final double? width;
//   final double? height;
//   final TextEditingController? controller;
//   final bool isNumeric;//dành cho các ô cần nhập số

//   const InputField({
//     super.key,
//     required this.label,
//     this.isPassword = false,
//     this.width,
//     this.height,
//     this.controller, // Nhận controller
//     this.isNumeric = false, // Mặc định không chặn chữ

//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: AppTextStyles.text),
//         const SizedBox(height: 5),
//         Container(
//           width: width ?? 270,
//           height: height ?? 50,
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: TextField(
//             controller: controller,
//             keyboardType: isNumeric ? TextInputType.number : TextInputType.text, // Kiểm tra nếu cần nhập số
//               inputFormatters: isNumeric
//                   ? [FilteringTextInputFormatter.digitsOnly] // chặn chữ khi isNumeric = true
//                   : [],
//             obscureText: isPassword,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(horizontal: 15),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// đây là code của inputfield.dart

// import 'package:fitfusion_frontend/screen/intro.dart';
// import 'package:fitfusion_frontend/screen/profile.dart';
// import 'package:flutter/material.dart';
// import '../theme/theme.dart';

// class AppBarCustom extends StatelessWidget {
//   final VoidCallback? onBackPressed;

//   const AppBarCustom({
//     Key? key,
//     this.onBackPressed,
//   }) : super(key: key);
//   void _showMenu(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Stack(
//           children: [
//             Positioned(
//               top: 70, // Điều chỉnh vị trí dọc
//               right: 10, // Điều chỉnh vị trí ngang
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   width: 220, // Điều chỉnh kích thước
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildMenuItem( context,Icons.person, "Cơ bản", "Thông tin cá nhân",
//                       onTap: () {
//                           Navigator.pop(context); // Đóng menu trước
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => setProfile()), // Chuyển đến màn hình IntroApp
//                           );
//                         },
//                       ),
//                       Divider(),
//                       _buildMenuItem( context,Icons.help, "Trợ giúp","Yêu cầu trợ giúp"),
//                       Divider(),
//                       _buildMenuItem( context,Icons.info,"Giới thiệu",  "Về chúng tôi"),
//                       Divider(),
//                       _buildMenuItem(
//                         context,
//                         Icons.account_circle,
//                         "Tài Khoản",
//                         "Đăng xuất",
//                         onTap: () {
//                           Navigator.pop(context); // Đóng menu trước
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => IntroApp()), // Chuyển đến IntroApp
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 12)) : null,
//       onTap: onTap ?? () {}, // Nếu có onTap thì dùng, không thì để trống
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.chevron_left, color: Colors.white, size: 50),
//           onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
//         ),
//         const Text(
//           "FITFUSION",
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.menu, color: Colors.white, size: 50),
//           onPressed: () => _showMenu(context),
//         ),
//       ],
//     );
//   }
// }
// class AppBarCustomHeader extends StatelessWidget {
//   final String fullname;
//   final VoidCallback? onBackPressed;

//   const AppBarCustomHeader({
//     super.key,
//     required this.fullname,
//     this.onBackPressed,
//   });

//   void _showMenu(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Stack(
//           children: [
//             Positioned(
//               top: 70,
//               right: 10,
//               child: Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   width: 220,
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildMenuItem(context, 
//                       Icons.person, 
//                       "Cơ bản", 
//                       "Thông tin cá nhân",
//                        onTap: () {
//                           Navigator.pop(context); // Đóng menu trước
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => IntroApp()), // Chuyển đến màn hình IntroApp
//                           );
//                         },
//                       ),
//                       Divider(),
//                       _buildMenuItem(context, Icons.help, "Trợ giúp", "Yêu cầu trợ giúp"),
//                       Divider(),
//                       _buildMenuItem(
//                       context,
//                       Icons.info,
//                       "Giới thiệu",  
//                       "Về chúng tôi",
//                       onTap: () {
//                           Navigator.pop(context); // Đóng menu trước
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => setProfile()), // Chuyển đến màn hình IntroApp
//                           );
//                         },
//                       ),
//                       Divider(),
//                       _buildMenuItem(
//                         context,
//                         Icons.account_circle,
//                         "Tài Khoản",
//                         "Đăng xuất",
//                         onTap: () {
//                           Navigator.pop(context); // Đóng menu trước
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(builder: (context) => IntroApp()), // Chuyển đến màn hình IntroApp
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 12)) : null,
//       onTap: onTap ?? () {},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.chevron_left, color: Colors.white, size: 50),
//               onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
//             ),
//             const Text(
//               "FITFUSION",
//               style: AppTextStyles.title,
//             ),
//             IconButton(
//               icon: const Icon(Icons.menu, color: Colors.white, size: 50),
//               onPressed: () => _showMenu(context),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(
//                 text: "Fit",
//                 style: AppTextStyles.title.copyWith(
//                   shadows: const [
//                     Shadow(
//                       offset: Offset(1.5, 1.5),
//                       blurRadius: 0,
//                       color: Color(0xFFB3261E),
//                     ),
//                   ],
//                 ),
//               ),
//               TextSpan(
//                 text: "AI",
//                 style: AppTextStyles.title.copyWith(
//                   color: const Color(0xFFB3261E),
//                   shadows: const [
//                     Shadow(
//                       offset: Offset(1.5, 1.5),
//                       blurRadius: 0,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
// đây là code của tabbar.dart

// import 'package:flutter/material.dart';
// import '../models/user_info_model.dart';
// import 'package:fitfusion_frontend/theme/theme.dart';

// // Bảng màu theo ảnh body
// final Map<String, Color> imageColorMap = {
//   "assets/body_img/male_underweight.png": Color(0xFF54CAF7),
//   "assets/body_img/male_normal.png": Color(0xFF9CB327),
//   "assets/body_img/male_overweight.png": Color(0xFFF48221),
//   "assets/body_img/male_obese.png": Color(0xFFE64638),
//   "assets/body_img/male_extreme.png": Color(0xFFBD3C8C),
//   "assets/body_img/female_underweight.png": Color(0xFF54CAF7),
//   "assets/body_img/female_normal.png": Color(0xFF9CB327),
//   "assets/body_img/female_overweight.png": Color(0xFFF7C818),
//   "assets/body_img/female_obese.png": Color(0xFFF48221),
//   "assets/body_img/female_extreme.png": Color(0xFFE64638),
// };

// // Widget hiển thị body
// class UserImageWidget extends StatelessWidget {
//   final UserInfoModel userInfo;
//   final double screenWidth;
//   final double screenHeight;

//   const UserImageWidget({super.key, required this.userInfo, required this.screenWidth, required this.screenHeight});

//   @override
//   Widget build(BuildContext context) {
//     String imagePath = _getImagePath();
//     Color bmiColor = imageColorMap[imagePath] ?? Colors.grey;

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Image.asset(imagePath, width: screenWidth * 0.3, height: screenHeight * 0.5),
//         Positioned(
//           bottom: 10,
//           child: Column(
//             children: [
//               Container(
//                 width: 150,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//                   color: bmiColor,
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Text(
//                   "BMI : ${userInfo.bmi.toStringAsFixed(1)}",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 height: 50,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
//                   color: Colors.white,
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Text(
//                   userInfo.bmiStatus,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: bmiColor, fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _getImagePath() {
//     Map<String, Map<String, String>> imagePaths = {
//       "Nam": {
//         "Gầy": "assets/body_img/male_underweight.png",
//         "Bình thường": "assets/body_img/male_normal.png",
//         "Thừa cân": "assets/body_img/male_overweight.png",
//         "Béo phì": "assets/body_img/male_obese.png",
//         "Nguy hiểm": "assets/body_img/male_extreme.png",
//       },
//       "Nữ": {
//         "Gầy": "assets/body_img/female_underweight.png",
//         "Bình thường": "assets/body_img/female_normal.png",
//         "Thừa cân": "assets/body_img/female_overweight.png",
//         "Béo phì": "assets/body_img/female_obese.png",
//         "Nguy hiểm": "assets/body_img/female_extreme.png",
//       }
//     };

//     return imagePaths[userInfo.gender]?[userInfo.bmiStatus] ?? "assets/body_img/default.png";
//   }
// }

// // Widget nút chức năng
// class FeatureButton extends StatelessWidget {
//   final String title;
//   final String image;
//   final List<Color> gradientColors;
//   final bool isTextLeft;
//   final VoidCallback onTap; // Hàm callback khi click

//   const FeatureButton({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.gradientColors,
//     required this.isTextLeft,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.80, 
//           height: 100,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: gradientColors,
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: Colors.black, width: 2),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: isTextLeft
//                 ? _buildLeftTextLayout()  // chiều xuôi
//                 : _buildRightTextLayout(), // chiều ngược
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildLeftTextLayout() {
//     return [
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 15),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               title,
//               style: AppTextStyles.little_title
//             ),
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(right: 25),
//         child: Image.asset(image, height: 100, width: 100), // Giảm kích thước ảnh
//       ),
//     ];
//   }

//   List<Widget> _buildRightTextLayout() {
//     return [
//       Padding(
//         padding: const EdgeInsets.only(left: 15),
//         child: Image.asset(image, height: 100, width: 100), // Giảm kích thước ảnh
//       ),
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.only(right: 15),
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               title,
//               style: AppTextStyles.little_title
//             ),
//           ),
//         ),
//       ),
//     ];
//   }
// }
// đây là code của widget_home.dart

// import 'package:flutter/material.dart';
// import 'package:fitfusion_frontend/screen/intro.dart';

// void main() {
//   runApp(FitFusionApp());
// }

// class FitFusionApp extends StatelessWidget {
//   const FitFusionApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: IntroApp(), // Đặt màn hình khởi động đúng
//     );
//   }
// }
// đây là code của main.dart

// name: fitfusion_frontend
// description: "A new Flutter project."
// # The following line prevents the package from being accidentally published to
// # pub.dev using `flutter pub publish`. This is preferred for private packages.
// publish_to: 'none' # Remove this line if you wish to publish to pub.dev

// # The following defines the version and build number for your application.
// # A version number is three numbers separated by dots, like 1.2.43
// # followed by an optional build number separated by a +.
// # Both the version and the builder number may be overridden in flutter
// # build by specifying --build-name and --build-number, respectively.
// # In Android, build-name is used as versionName while build-number used as versionCode.
// # Read more about Android versioning at https://developer.android.com/studio/publish/versioning
// # In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
// # Read more about iOS versioning at
// # https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
// # In Windows, build-name is used as the major, minor, and patch parts
// # of the product and file versions while build-number is used as the build suffix.
// version: 1.0.0+1

// environment:
//   sdk: ^3.5.4

// # Dependencies specify other packages that your package needs in order to work.
// # To automatically upgrade your package dependencies to the latest versions
// # consider running `flutter pub upgrade --major-versions`. Alternatively,
// # dependencies can be manually updated by changing the version numbers below to
// # the latest version available on pub.dev. To see which dependencies have newer
// # versions available, run `flutter pub outdated`.
// dependencies:
//   flutter:
//     sdk: flutter




//   # The following adds the Cupertino Icons font to your application.
//   # Use with the CupertinoIcons class for iOS style icons.
//   cupertino_icons: ^1.0.8




// dev_dependencies:
//   flutter_test:
//     sdk: flutter

//   # The "flutter_lints" package below contains a set of recommended lints to
//   # encourage good coding practices. The lint set provided by the package is
//   # activated in the `analysis_options.yaml` file located at the root of your
//   # package. See that file for information about deactivating specific lint
//   # rules and activating additional ones.
//   flutter_lints: ^4.0.0

// # For information on the generic Dart part of this file, see the
// # following page: https://dart.dev/tools/pub/pubspec

// # The following section is specific to Flutter packages.
// flutter:

//   # The following line ensures that the Material Icons font is
//   # included with your application, so that you can use the icons in
//   # the material Icons class.
//   uses-material-design: true

//   # To add assets to your application, add an assets section, like this:
//   # assets:
//   #   - images/a_dot_burr.jpeg
//   #   - images/a_dot_ham.jpeg
//   assets:
//     # - assets/mock_data/data.json
//     - assets/calories.png
//     - assets/coach.png
//     - assets/workout.png
//     - assets/nutrition.png
//     - assets/logo.png
//     - assets/male.png
//     - assets/female.png
//     - assets/measure_height.png
//     - assets/BMI.png
//     - assets/body_img/




//   # An image asset can refer to one or more resolution-specific "variants", see
//   # https://flutter.dev/to/resolution-aware-images

//   # For details regarding adding assets from package dependencies, see
//   # https://flutter.dev/to/asset-from-package

//   # To add custom fonts to your application, add a fonts section here,
//   # in this "flutter" section. Each entry in this list should have a
//   # "family" key with the font family name, and a "fonts" key with a
//   # list giving the asset and other descriptors for the font. For
//   # example:
//   # fonts:
//   #   - family: Schyler
//   #     fonts:
//   #       - asset: fonts/Schyler-Regular.ttf
//   #       - asset: fonts/Schyler-Italic.ttf
//   #         style: italic
//   #   - family: Trajan Pro
//   #     fonts:
//   #       - asset: fonts/TrajanPro.ttf
//   #       - asset: fonts/TrajanPro_Bold.ttf
//   #         weight: 700
//   #
//   # For details regarding fonts from package dependencies,
//   # see https://flutter.dev/to/font-from-package
// đây là code của pubspec.yaml