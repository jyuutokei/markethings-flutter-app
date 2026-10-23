class SellerProductEntity {
  final int id;
  final String title;
  final String sellerId;
  final String? mainImageUrl;
  final double price;
  final bool isActive;

  const SellerProductEntity({
    required this.id,
    required this.title,
    required this.sellerId,
    required this.mainImageUrl,
    required this.price,
    required this.isActive,
  });

  SellerProductEntity copyWith({bool? isActive}) {
    return SellerProductEntity(
      id: id,
      title: title,
      sellerId: sellerId,
      mainImageUrl: mainImageUrl,
      price: price,
      isActive: isActive ?? this.isActive,
    );
  }
}
