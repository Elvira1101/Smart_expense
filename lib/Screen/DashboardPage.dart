import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../shared/widgets/custom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  double totalMensuel = 3000;
  double moyenneJournaliere = 3000;
  int transactions = 1;
  int categories = 1;

  Map<String, double> repartition = {
    "Transport": 3000,
  };

  // 🔥 Controllers & variables modal
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedCategory;
  DateTime? _selectedDate;

  final List<String> _categories = [
    "Alimentation",
    "Transport",
    "Shopping",
    "Loisirs",
    "Santé",
    "Factures",
    "Education",
    "Autre",
  ];

  void _showAddExpenseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {

            bool isValid = _amountController.text.isNotEmpty &&
                _selectedCategory != null &&
                _selectedDate != null;

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.6,
              builder: (_, controller) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: ListView(
                    controller: controller,
                    children: [

                      const Text(
                        "Nouvelle dépense",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("Montant (FCFA)"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setModalState(() {}),
                        decoration: InputDecoration(
                          hintText: "3000.00",
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("Catégorie"),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _categories.map((cat) {
                          bool selected = _selectedCategory == cat;

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                _selectedCategory = cat;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFF6C9A8B)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF6C9A8B)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),

                      const Text("Date"),
                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            setModalState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? ""
                                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("Note (optionnel)"),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Annuler"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isValid
                                    ? const Color(0xFF6C9A8B)
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isValid
                                  ? () {
                                double amount =
                                double.parse(_amountController.text);

                                setState(() {
                                  totalMensuel += amount;
                                  transactions++;

                                  repartition[_selectedCategory!] =
                                      (repartition[_selectedCategory!] ?? 0) +
                                          amount;
                                });

                                Navigator.pop(context);

                                _amountController.clear();
                                _noteController.clear();
                                _selectedCategory = null;
                                _selectedDate = null;
                              }
                                  : null,
                              child: const Text("Ajouter"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C9A8B),
              Color(0xFF4E7C6E),
            ],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            _showAddExpenseModal(context);
          },
          child: const Icon(Icons.add),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                "Tableau de Bord",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _buildStatCard("Total Mensuel",
                      "${totalMensuel.toInt()} FCFA"),
                  const SizedBox(width: 10),
                  _buildStatCard("Moy. Journalière",
                      "${moyenneJournaliere.toInt()} FCFA"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return repartition.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        color: Colors.blue,
        showTitle: false,
        radius: 40,
      );
    }).toList();
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        )
      ],
    );
  }
}