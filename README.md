#### Exercise 1

Demonstrates encapsulation by separating the `StringManager` class that formats post from the `Post` itself.
`StringManager` converts the Int value of `likes` to a localized String. `Post.display` displays the post.

#### Exercise 2

Demonstrates Singleton pattern and composition using Protocols.

Protocol `DiscountStrategy` uses an Enum `DiscountOption` to choose between percentage and noDiscount strategies.
Class `PriceRounder` singleton rounds prices to 2 decimal points.
Class `Discount` conforms to `DiscountStrategy` to calculate discounted price using method `priceFromDiscountStrategy.`
Class `Product` takes `name` and `price` constants of type Double, and a variable property `quantity` of type Int. Prudct conforms to Hashable in order to use it in `ShoppingCartSingleton`'s `products` property of type Set<Product>.
Singleton class `ShoppingCartSingleton` also has the following methods:
  - `addProduct(product: Product, quantity: Int, discountOption: DiscountOption`
  - `removeProduct(product: Product)` (decrements `product` by 1 and removes if 0)
  - `removeEveryProduct(product: Product)` (gets rid of all of one product)
  - clearCart() (removes all products)
  - getTotalPrice() -> Double (returns total price based on product prices, discount and quantities)

Demo cases for adding products with different names, quantities and discountOptions are included in the exercise, as is a demo of `getTotalPrice`

#### Exercise 3

`enum PaymentError: Error` creates a custom error type with cases for the following: 
  - insufficientFunds
  - billsAreCounterfeit
  - invalidNameOnCard
  - invalidEmailAddress
  - invalidCreditCardNumber
  - invalidExpirationDate
  - invalidCVC
  - invalidZipCode
  - case unknownError
