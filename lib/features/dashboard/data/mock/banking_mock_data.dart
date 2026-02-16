import '../../domain/entities/transaction.dart';
import '../models/account_model.dart';
import '../models/card_model.dart';
import '../models/transaction_model.dart';

/// Mock banking data for dashboard
class BankingMockData {
  BankingMockData._();

  /// Static account data
  static const AccountModel account = AccountModel(
    accountNumber: '**** **** **** 3456',
    accountType: 'Savings Account',
    balance: 12450.50,
    availableBalance: 12450.50,
    accountHolderName: 'SAYED MOATAZ',
  );

  /// Static card data
  static const CardModel card = CardModel(
    cardNumber: '1234 5678 9012 3456',
    cardHolderName: 'SAYED MOATAZ',
    expiryDate: '12/26',
    cardType: 'Visa',
    cardColor: '#1565C0',
  );

  /// All 20 mock transactions
  static final List<TransactionModel> _allTransactions = [
    // Today
    TransactionModel(
      id: '1',
      merchant: 'Carrefour Maadi',
      amount: -245.50,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(minutes: 53)), // 53 mins ago
      status: 'Completed',
    ),
    TransactionModel(
      id: '2',
      merchant: 'Uber Trip',
      amount: -35.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(hours: 2)), // 2 hours ago
      status: 'Completed',
    ),
    TransactionModel(
      id: '3',
      merchant: 'Starbucks',
      amount: -85.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'Completed',
    ),

    // Yesterday
    TransactionModel(
      id: '4',
      merchant: 'Salary Deposit',
      amount: 15000.00,
      category: TransactionCategory.deposit,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '5',
      merchant: 'Netflix Subscription',
      amount: -165.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      status: 'Completed',
    ),

    // 2 days ago
    TransactionModel(
      id: '6',
      merchant: 'Electricity Bill',
      amount: -450.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '7',
      merchant: 'ATM Withdrawal',
      amount: -1000.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      status: 'Completed',
    ),

    // 3 days ago
    TransactionModel(
      id: '8',
      merchant: 'Transfer to Ahmed',
      amount: -500.00,
      category: TransactionCategory.transfer,
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '9',
      merchant: 'KFC',
      amount: -180.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '10',
      merchant: 'Zara',
      amount: -890.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      status: 'Completed',
    ),

    // 4 days ago
    TransactionModel(
      id: '11',
      merchant: 'Cinema Tickets',
      amount: -250.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '12',
      merchant: 'Uber Eats',
      amount: -120.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 4, hours: 5)),
      status: 'Completed',
    ),

    // 5 days ago
    TransactionModel(
      id: '13',
      merchant: 'Water Bill',
      amount: -120.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '14',
      merchant: 'Metro Maadi',
      amount: -350.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 5, hours: 3)),
      status: 'Completed',
    ),

    // 6 days ago
    TransactionModel(
      id: '15',
      merchant: 'Transfer from Sara',
      amount: 200.00,
      category: TransactionCategory.receive,
      date: DateTime.now().subtract(const Duration(days: 6)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '16',
      merchant: 'Taxi',
      amount: -50.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 6, hours: 4)),
      status: 'Completed',
    ),

    // 7 days ago
    TransactionModel(
      id: '17',
      merchant: 'Spotify Premium',
      amount: -99.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: 'Completed',
    ),
    TransactionModel(
      id: '18',
      merchant: 'McDonald\'s',
      amount: -95.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 7, hours: 6)),
      status: 'Completed',
    ),

    // 8 days ago
    TransactionModel(
      id: '19',
      merchant: 'ATM Withdrawal',
      amount: -500.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 8)),
      status: 'Completed',
    ),

    // 9 days ago
    TransactionModel(
      id: '20',
      merchant: 'Internet Bill',
      amount: -300.00,
      category: TransactionCategory.withdraw,
      date: DateTime.now().subtract(const Duration(days: 9)),
      status: 'Completed',
    ),
  ];

  /// Get paginated transactions
  static List<TransactionModel> getTransactions(int offset, int limit) {
    if (offset >= _allTransactions.length) {
      return [];
    }

    final end = (offset + limit).clamp(0, _allTransactions.length);
    return _allTransactions.sublist(offset, end);
  }

  /// Check if there are more transactions
  static bool hasMoreTransactions(int currentCount) {
    return currentCount < _allTransactions.length;
  }

  /// Total number of transactions
  static int get totalTransactionsCount => _allTransactions.length;
}
