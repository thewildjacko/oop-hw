HW Complete!

#### Exercise 1

Demonstrates encapsulation by separating the `StringManager` class that formats post from the `Post` itself.
`StringManager` converts the Int value of `likes` to a localized String. `Post.display` displays the post.

#### Exercise 2

Demonstrates Singleton pattern and composition using Protocols.

Protocol `DiscountStrategy` uses an Enum `DiscountOption` to choose between percentage and noDiscount strategies.

Class `PriceRounder` singleton rounds prices to 2 decimal points.

Class `Discount` conforms to `DiscountStrategy` to calculate discounted price using method `priceFromDiscountStrategy.`

Class `Product` takes `name` and `price` constants of type Double, and a variable property `quantity` of type Int. 
Product conforms to Hashable in order to use it in `ShoppingCartSingleton`'s `products` property of type Set<Product>.
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

protocol `PaymentProcessor` defines a func processPayment(amount: Double, purchasePrice: Double)`

singleton class `CreditCardRegexMatcherSingleton` defines Regexes to match for different validation functions

classes `CreditCardNameValidator`, `CreditCardEmailValidator`, `CreditCardNumberValidator`, `CreditCardExpirationValidator`, `CreditCardCVCValidator`, `CreditCardZipCodeValidator` each validate a piece of credit card information.

singleton class CreditCardValidator takes the individual validators as constants and uses method `validate(name: String, email: String, number: String, expiration: String, cvc: String, zip: String) -> [(passed: Bool, error: PaymentError)]` to return an array of validations.

class `PaymentAmountFormatter` formats `amount` Doubles to dollar amount Strings with 2 decimal places

class `CreditCardProcessor: PaymentProcessor` takes credit card info and uses the `CreditCardValidator` singleton to validate the information. Method `processPayment(amount: Double, purchasePrice: Double) throws` takes the amount paid and the purchase price and throws an error if the amount is too low or if the credit card fails validation, and otherwise prints a success message.

class `CashProcessor: PaymentProcessor` takes a variable Bool property `billsAreCounterfeit`. Method `processPayment(amount: Double, purchasePrice: Double) throws` takes the amount paid and the purchase price and throws an error if the amount is too low or if billsAreCounterfeit is true, and otherwise prints a success message.

functions `handleCreditCardPayments(amount: Double, purchasePrice: Double, paymentProcessor: PaymentProcessor)` and `func handleCashPayments(amount: Double, purchasePrice: Double, paymentProcessor: PaymentProcessor)` use do-try-catch blocks to try processing Credit Card and Cash payments, respectively, catching errors and printing out relevant messages if caught, or printing `processPayment`'s success message if no errors are thrown.

The rest of the exercise demos different success and failure cases for Cash and Credit Card payments.
