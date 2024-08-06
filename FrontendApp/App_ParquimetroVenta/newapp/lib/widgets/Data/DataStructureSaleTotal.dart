class TotalSale {
  final List<CardTotalSale> data;

  TotalSale({required this.data});

  factory TotalSale.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<CardTotalSale> cardTotalSales = dataList.map((e) => CardTotalSale.fromJson(e)).toList();
    return TotalSale(data: cardTotalSales);
  }
}

class CardTotalSale {
  final int saleTotal;
  final String saleType;

  CardTotalSale({required this.saleTotal, required this.saleType});

  factory CardTotalSale.fromJson(Map<String, dynamic> json) {
    return CardTotalSale(
      saleTotal: json['sale_total'] ??  0.0,

      saleType: json['sale_type'] ??   '',

    );
  }
}
