class productDataModel{
  String? productName;
  String? productUrl;
  String? productRating;
  String? productDescription;

  productDataModel(
      {this.productName,
      this.productUrl,
      this.productRating,
      this.productDescription}
      );

  productDataModel.fromJson(Map<String, dynamic> json){

    productName = json['productName'];
    productUrl = json['productUrl'];
    productRating = json['productRating'];
    productDescription = json['productDescription'];
  }
}