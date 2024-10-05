import SwiftUI

// Exercise 1

class StringManager {
  class func toLocalizedValue(num: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en-US")
    let localizedLikes = formatter.string(from: NSNumber(integerLiteral: num))!
    return localizedLikes
  }
}

class Post {
  let author: String
  let content: String
  let likes: Int
  
  init(author: String, content: String, likes: Int) {
    self.author = author
    self.content = content
    self.likes = likes
  }
  
  func display() {
    let formattedLikes = StringManager.toLocalizedValue(num: likes)
    let post = """
    \(author)
    
    \(content)

    Likes: \(formattedLikes)
    """
    print(post)
  }
}

let post1 = Post(author: "Jake Smolowe", content: "What is everybody listening to today? I'm listening to one of the baddest pianists nobody talks about, Clare Fischer.", likes: 78352)

let post2 = Post(author: "Luke Cat Amata", content: "Anybody else have an owner that refuses to let them jump on the table and destroy documents whenever they want? This is opression!", likes: 315279)

post1.display()
print("---------")
post2.display()

// Exercise 2

class Product {
  let name: String
  let price: Double
  let quantity: Int
  
  init(name: String, price: Double, quantity: Int) {
    self.name = name
    self.price = price
    self.quantity = quantity
  }
}

public class ShoppingCartSingleton {
  private var products: [Product] = []
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
}
