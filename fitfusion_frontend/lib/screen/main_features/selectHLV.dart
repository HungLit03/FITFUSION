import 'package:fitfusion_frontend/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:fitfusion_frontend/theme/theme.dart';

class selectHLV extends StatefulWidget {
  const selectHLV({super.key});

  @override
  _selectHLVState createState() => _selectHLVState();
}

class _selectHLVState extends State<selectHLV> {
  double _age = 25; // Default age value
  String _selectedGender = "Tất cả";
  String _selectedField = "Tất cả";
  String _selectedRegion = "Tất cả";

  // Sample list of coaches
  final List<Map<String, String>> _allCoaches = [
    {
      "name": "Nguyễn Hồng Tôn",
      "gender": "Nam",
      "age": "24",
      "field": "Yoga",
      "region": "Hà Nội"
    },
    {
      "name": "Trần Thị Bích",
      "gender": "Nữ",
      "age": "30",
      "field": "Gym",
      "region": "Hồ Chí Minh"
    },
    {
      "name": "Lê Văn An",
      "gender": "Nam",
      "age": "28",
      "field": "Calisthenics",
      "region": "Đà Nẵng"
    },
    {
      "name": "Phạm Thị Hoa",
      "gender": "Nữ",
      "age": "26",
      "field": "Cardio",
      "region": "Hà Nội"
    },
    // Add more coaches as needed
  ];

  List<Map<String, String>> _filteredCoaches = [];

  @override
  void initState() {
    super.initState();
    _filteredCoaches = _allCoaches; // Initialize with all coaches
  }

  void _showFilterModal() {
    double tempAge = _age;
    String tempGender = _selectedGender;
    String tempField = _selectedField;
    String tempRegion = _selectedRegion;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bộ lọc",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Age filter
                  const Text("Tuổi"),
                  Slider(
                    value: tempAge,
                    min: 18,
                    max: 60,
                    divisions: 42,
                    label: tempAge.round().toString(),
                    onChanged: (value) {
                      setModalState(() {
                        tempAge = value;
                      });
                    },
                  ),

                  // Gender filter
                  const Text("Giới tính"),
                  DropdownButton<String>(
                    value: tempGender,
                    isExpanded: true,
                    items: ["Tất cả", "Nam", "Nữ"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setModalState(() {
                        tempGender = newValue!;
                      });
                    },
                  ),

                  // Field filter
                  const Text("Lĩnh vực"),
                  DropdownButton<String>(
                    value: tempField,
                    isExpanded: true,
                    items: ["Tất cả", "Gym", "Yoga", "Calisthenics", "Cardio"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setModalState(() {
                        tempField = newValue!;
                      });
                    },
                  ),

                  // Region filter
                  const Text("Khu vực"),
                  DropdownButton<String>(
                    value: tempRegion,
                    isExpanded: true,
                    items: ["Tất cả", "Hà Nội", "Hồ Chí Minh", "Đà Nẵng"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setModalState(() {
                        tempRegion = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // Apply filter button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _age = tempAge;
                          _selectedGender = tempGender;
                          _selectedField = tempField;
                          _selectedRegion = tempRegion;
                          _filterCoaches(); // Call filter function
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Áp dụng",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _filterCoaches() {
    setState(() {
      _filteredCoaches = _allCoaches.where((coach) {
        bool matchesAge = true;
        bool matchesGender = true;
        bool matchesField = true;
        bool matchesRegion = true;

        if (_selectedGender != "Tất cả") {
          matchesGender = coach["gender"] == _selectedGender;
        }

        if (_selectedField != "Tất cả") {
          matchesField = coach["field"] == _selectedField;
        }

        if (_selectedRegion != "Tất cả") {
          matchesRegion = coach["region"] == _selectedRegion;
        }

        matchesAge = double.parse(coach["age"]!) <= _age; // Check age condition

        return matchesAge && matchesGender && matchesField && matchesRegion;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: appGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const AppBarCustom(),
            // Title + Filter Icon
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Danh sách",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white, size: 30),
                    onPressed: _showFilterModal,
                  ),
                ],
              ),
            ),

            // Coaches list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredCoaches.length, // Dynamic item count
                itemBuilder: (context, index) {
                  final coach = _filteredCoaches[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green[300],
                          child: const Icon(Icons.person,
                              size: 40, color: Colors.white),
                        ),
                        const SizedBox(width: 12),

                        // Coach information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coach["name"]!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text("${coach["gender"]}, ${coach["age"]} tuổi",
                                  style: const TextStyle(fontSize: 14)),
                              Text("Lĩnh vực : ${coach["field"]}",
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                        // Arrow icon
                        const Icon(Icons.chevron_right, size: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
            // "Show more" button
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Show more",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
