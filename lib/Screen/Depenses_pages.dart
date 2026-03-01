import 'package:flutter/material.dart';
import '../shared/widgets/custom_nav.dart';

class DepensesPage extends StatefulWidget {
  const DepensesPage({super.key});

  @override
  State<DepensesPage> createState() => _DepensesPageState();
}

class _DepensesPageState extends State<DepensesPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  List<Map<String, dynamic>> transactions = [
    {
      "title": "Transport",
      "date": "03/02/2026",
      "amount": 3000,
      "category": "Transport",
      "note": "",
    },
  ];

  final List<String> categories = [
    "Alimentation",
    "Transport",
    "Shopping",
    "Loisirs",
    "Santé",
    "Factures",
    "Autres"
  ];

  String? _selectedCategory;
  DateTime? _selectedDate;
  Set<String> selectedFilters = {};

  // ------------------- MODAL AJOUT / MODIFICATION -------------------
  void _showAddOrEditExpenseModal(BuildContext context,
      {Map<String, dynamic>? transaction}) {
    if (transaction != null) {
      _amountController.text = transaction["amount"].toString();
      _selectedCategory = transaction["category"];
      _selectedDate = transaction["date"] != null
          ? DateTime.parse(transaction["dateRaw"] ??
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}")
          : DateTime.now();
      _noteController.text = transaction["note"] ?? "";
      _searchController.text = transaction["title"];
    } else {
      _amountController.clear();
      _noteController.clear();
      _selectedCategory = null;
      _selectedDate = null;
      _searchController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            bool isValid = _amountController.text.isNotEmpty &&
                _selectedCategory != null &&
                _selectedDate != null &&
                _searchController.text.isNotEmpty;

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.6,
              builder: (_, controller) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      Text(
                        transaction == null ? "Nouvelle dépense" : "Modifier dépense",
                        style: const TextStyle(
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
                          hintText: "3000",
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
                        children: categories.map((cat) {
                          bool selected = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                _selectedCategory = cat;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFF6C9A8B) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selected ? const Color(0xFF6C9A8B) : Colors.grey.shade300,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: TextStyle(color: selected ? Colors.white : Colors.black87),
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
                            initialDate: _selectedDate ?? DateTime.now(),
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
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(_selectedDate == null
                              ? ""
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
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
                              onPressed: () {
                                Navigator.pop(context);
                                _amountController.clear();
                                _noteController.clear();
                                _selectedCategory = null;
                                _selectedDate = null;
                              },
                              child: const Text("Annuler"),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isValid ? const Color(0xFF6C9A8B) : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isValid
                                  ? () {
                                setState(() {
                                  if (transaction == null) {
                                    // AJOUT
                                    transactions.add({
                                      "title": _searchController.text,
                                      "amount": int.tryParse(_amountController.text) ?? 0,
                                      "category": _selectedCategory!,
                                      "date":
                                      "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                      "note": _noteController.text,
                                    });
                                  } else {
                                    // MODIFICATION
                                    transaction["title"] = _searchController.text;
                                    transaction["amount"] = int.tryParse(_amountController.text) ?? 0;
                                    transaction["category"] = _selectedCategory!;
                                    transaction["date"] =
                                    "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
                                    transaction["note"] = _noteController.text;
                                  }
                                });

                                Navigator.pop(context);

                                _amountController.clear();
                                _noteController.clear();
                                _selectedCategory = null;
                                _selectedDate = null;
                              }
                                  : null,
                              child: Text(transaction == null ? "Ajouter" : "Modifier"),
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
// ------------------- CONFIRMATION SUPPRESSION -------------------
  void _confirmDelete(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text("Confirmation"),
          content: const Text(
            "Voulez-vous vraiment supprimer cette dépense ?",
          ),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                setState(() {
                  transactions.remove(transaction);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // ------------------- BUILD -------------------
  @override
  Widget build(BuildContext context) {
    final filteredTransactions = transactions.where((tx) {
      final matchesSearch =
      tx["title"].toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesCategory =
          selectedFilters.isEmpty || selectedFilters.contains(tx["category"]);
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C9A8B), Color(0xFF4E7C6E)],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            _showAddOrEditExpenseModal(context);
          },
          child: const Icon(Icons.add),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${filteredTransactions.length} transactions",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Recherche...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((category) {
                    final isSelected = selectedFilters.contains(category);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: const Color(0xFF5E9C8D).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF5E9C8D),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedFilters.add(category);
                            } else {
                              selectedFilters.remove(category);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showAddOrEditExpenseModal(context, transaction: transaction);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction["title"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transaction["date"],
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${transaction["amount"]} FCFA",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _confirmDelete(transaction);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}