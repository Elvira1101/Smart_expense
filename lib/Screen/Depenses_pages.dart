import 'package:flutter/material.dart';

class DepensesPage extends StatefulWidget {
  const DepensesPage({super.key});

  @override
  State<DepensesPage> createState() => _DepensesPageState();
}

class _DepensesPageState extends State<DepensesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    "Alimentation",
    "Transport",
    "Shopping",
    "Loisirs",
    "Santé",
    "Factures",
    "Autres"
  ];

  Set<String> selectedCategories = {};

  List<Map<String, dynamic>> transactions = [
    {
      "title": "Transport",
      "date": "03 Fev 2026",
      "amount": 3000,
      "category": "Transport"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = transactions.where((transaction) {
      final matchesSearch = transaction["title"]
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      final matchesCategory = selectedCategories.isEmpty ||
          selectedCategories.contains(transaction["category"]);

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      /// ➕ BOUTON AJOUT DEPENSE
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5E9C8D),
        onPressed: () => _showAddTransactionDialog(),
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF5E9C8D),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Dépenses"),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${filteredTransactions.length} transactions",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 15),

              /// 🔎 RECHERCHE
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

              /// 📌 CATÉGORIES HORIZONTALES MULTI-SÉLECTION
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((category) {
                    final isSelected =
                    selectedCategories.contains(category);

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor:
                        const Color(0xFF5E9C8D).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF5E9C8D),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              /// 📋 LISTE DES TRANSACTIONS
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
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction["title"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction["date"],
                                style: const TextStyle(
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            "${transaction["amount"]} FCFA",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
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

  /// ➕ AJOUTER UNE NOUVELLE DEPENSE
  void _showAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = categories.first;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text("Ajouter une dépense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration:
              const InputDecoration(labelText: "Titre"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: "Montant"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: selectedCategory,
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                selectedCategory = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5E9C8D),
            ),
            onPressed: () {
              setState(() {
                transactions.add({
                  "title": titleController.text,
                  "date":
                  "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  "amount":
                  int.tryParse(amountController.text) ?? 0,
                  "category": selectedCategory,
                });
              });

              Navigator.pop(context);
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}