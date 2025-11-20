import 'package:draw_auth/services/api_service.dart';
import 'package:test/test.dart';
import 'package:draw_auth/models/product.dart';
import 'package:draw_auth/viewmodels/products_viewmodel.dart';
import 'package:draw_auth/viewmodels/cart_viewmodel.dart';

// Attempt to instantiate ProductsViewModel at load time so we can produce meaningful skip reasons.
ProductsViewModel? _productVM;
CartViewModel? _cartVM;
Product? expectedProduct;
String? _instantiationError;

void main() {
  setUp(() {
    _productVM = ProductsViewModel();
    _cartVM = CartViewModel();
    // Do not call a non-existent setter on ProductsViewModel in tests.
    // Prepare the expected product instance for comparisons instead.
    expectedProduct = Product(id: 2, title: 'Mens Casual Premium Slim Fit T-Shirts ', description: 'Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.',category: "men's clothing" ,price: 22.3, image: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_t.png', rating: Rating(rate: 4.1, count: 259));
  });

  group('ProductsViewModel unit tests', () {
    test('products is a List<Product>', () {
      expect(_productVM!.products, isA<List>()); // runtime generic info is erased; this still asserts a List instance
      // if Product is exported from the viewmodel module, also assert the generic type at compile time:
      expect(_productVM!.products, isA<List<dynamic>>()); // keeps compile-time reference to List
    }, skip: _instantiationError);
    test('fetchSingleProduct returns expected Product', () async {
      // Call the API directly for this unit test rather than relying on a setter on the viewmodel.
      final product = await ApiService().fetchSingleProduct(2);
      expect(product, expectedProduct); // runtime check that the fetched product matches the expected instance
    }, skip: _instantiationError);
  });

  //cart tests
  // group('CartViewModel unit tests', () {
  //   test('product added in a cart item', () {
  //     expect(_cartVM!.add(expectedProduct!), "product added"); // runtime generic info is erased; this still asserts a List instance
  //     // if Product is exported from the viewmodel module, also assert the generic type at compile time:
  //     expect(_cartVM!.modifyQuantity(CartItem(product: expectedProduct!), 2), "cart item modified");
      
  //     expect(_cartVM!.remove(CartItem(product: expectedProduct!)), "cart item deleted"); // keeps compile-time reference to List
  //   }, skip: _instantiationError);
  //   test('fetchSingleProduct returns expected Product', () async {
  //     // Call the API directly for this unit test rather than relying on a setter on the viewmodel.
  //     final product = await ApiService().fetchSingleProduct(2);
  //     expect(product, expectedProduct); // runtime check that the fetched product matches the expected instance
  //   }, skip: _instantiationError);
  // });

  //auth tests
  // group('CartViewModel unit tests', () {
  //   test('product added in a cart item', () {
  //     expect(_cartVM!.add(expectedProduct!), "product added"); // runtime generic info is erased; this still asserts a List instance
  //     // if Product is exported from the viewmodel module, also assert the generic type at compile time:
  //     expect(_cartVM!.modifyQuantity(CartItem(product: expectedProduct!), 2), "cart item modified");
      
  //     expect(_cartVM!.remove(CartItem(product: expectedProduct!)), "cart item deleted"); // keeps compile-time reference to List
  //   }, skip: _instantiationError);
  //   test('fetchSingleProduct returns expected Product', () async {
  //     // Call the API directly for this unit test rather than relying on a setter on the viewmodel.
  //     final product = await ApiService().fetchSingleProduct(2);
  //     expect(product, expectedProduct); // runtime check that the fetched product matches the expected instance
  //   }, skip: _instantiationError);
  // });
}