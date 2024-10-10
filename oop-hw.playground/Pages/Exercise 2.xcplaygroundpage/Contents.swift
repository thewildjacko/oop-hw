//: [Previous](@previous)
// Exercise 2

import Foundation

enum DiscountOption {
  case noDiscountStrategy
  case percentageDiscountStrategy(percentage: Double)
}

protocol DiscountStrategy {
  func priceFromDiscountStrategy(price: Double, strategy: DiscountOption) -> Double
}

class PriceRounder {
  private static var sharedInstance: PriceRounder?
  
  public class func singleton() -> PriceRounder {
    if sharedInstance == nil {
      sharedInstance = PriceRounder()
    }
    return sharedInstance!
  }
  
  static func roundPrice(price: Double) -> Double {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    let roundedPriceString = formatter.string(from: NSNumber(floatLiteral: price)) ?? ""
    return Double(roundedPriceString) ?? price
  }
}

class Discount: DiscountStrategy {
  func priceFromDiscountStrategy(price: Double, strategy: DiscountOption) -> Double {
    switch strategy {
    case .noDiscountStrategy:
      return PriceRounder.roundPrice(price: price)
    case .percentageDiscountStrategy(let percentage):
      return PriceRounder.roundPrice(price: price * percentage)
    }
  }
}

class Product {
  let name: String
  let price: Double
  var quantity: Int
  
  init(name: String, price: Double, quantity: Int) {
    self.name = name
    self.price = PriceRounder.roundPrice(price: price)
    self.quantity = quantity
  }
}

extension Product: Hashable {
  static func == (lhs: Product, rhs: Product) -> Bool {
    return lhs.name == rhs.name && lhs.price == rhs.price
  }
  
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(price)
  }
}

public class ShoppingCartSingleton {
  private var products: Set<Product> = []
  private var discount: DiscountStrategy = Discount()
  
  private static var sharedInstance: ShoppingCartSingleton?
  
  private init() {
    self.products = []
  }
  
  public class func singleton() -> ShoppingCartSingleton {
    if sharedInstance == nil {
      sharedInstance = ShoppingCartSingleton()
    }
    return sharedInstance!
  }
  
  func addProduct(product: Product, quantity: Int, discountOption: DiscountOption) {
    let productPrice = discount.priceFromDiscountStrategy(price: product.price, strategy: discountOption)
    
    let productsToAdd = Product(name: product.name, price: productPrice, quantity: quantity)
    
    products.insert(productsToAdd)
  }
  
  func removeProduct(product: Product) {
    if let index = products.firstIndex(of: product) {
      products[index].quantity -= 1
      if products[index].quantity == 0 {
        products.remove(product)
      }
    }
  }
  
  func removeEvery(product: Product) {
    products.remove(product)
  }
  
  func clearCart() {
    products.removeAll()
  }
  
  func getTotalPrice() -> Double {
    return products.map { PriceRounder.roundPrice(price: $0.price * Double($0.quantity)) }.reduce(0, { x, y in
      x + y
    })
  }
}

let apple = Product(name: "Apple", price: 2.39, quantity: 1)
let orange = Product(name: "Orange", price: 1.87, quantity: 1)

ShoppingCartSingleton.singleton().addProduct(product: apple, quantity: 5, discountOption: .percentageDiscountStrategy(percentage: 0.8))
ShoppingCartSingleton.singleton().addProduct(product: orange, quantity: 7, discountOption: .noDiscountStrategy)

ShoppingCartSingleton.singleton().getTotalPrice()

//: [Next](@next)
