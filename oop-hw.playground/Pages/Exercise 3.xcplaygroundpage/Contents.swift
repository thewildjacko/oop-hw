//: [Previous](@previous)
// Exercise 3

import Foundation

enum PaymentError: Error {
  case insufficientFunds
  case billsAreCounterfeit
  case invalidNameOnCard
  case invalidEmailAddress
  case invalidCreditCardNumber
  case invalidExpirationDate
  case invalidCVC
  case invalidZipCode
  case unknownError
}

protocol PaymentProcessor {
  func processPayment(amount: Double, purchasePrice: Double) throws
}

class CreditCardRegexMatcherSingleton {
  private static var sharedInstance: CreditCardRegexMatcherSingleton?
  
  private init() { }
  
  public class func singleton() -> CreditCardRegexMatcherSingleton {
    if sharedInstance == nil {
      sharedInstance = CreditCardRegexMatcherSingleton()
    }
    return sharedInstance!
  }
  
  let nameRegexMatcher = /^[a-z'-]+\s([a-z]\.{0,1}\s|[a-z'-]+\s){0,1}[a-z'-]+$/
  let emailRegexMatcher = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/
  let numberMatcher = /^[0-9]{16}$/
  let expirationDateMatcher = /^[0-9]{4}$/
  let cvcMatcher = /^[0-9]{3}$/
  let zipCodeMatcher = /^[0-9]{5}$/
}


class CreditCardNameValidator {
  func validate(name: String) -> Bool {
    var validated = false
    let lowerCasedName = name.lowercased()
    
    if let validatedName = lowerCasedName.wholeMatch(of: CreditCardRegexMatcherSingleton.singleton().nameRegexMatcher) {
      validated = true
      validated = lowerCasedName.contains(/\d/) ? false : true
      validated = lowerCasedName.count > 26 ? false : true
    }
    
    return validated
  }
}

class CreditCardEmailValidator {
  func validate(email: String) -> Bool {
    var validated = false
    
    if let validatedEmail = email.wholeMatch(of: CreditCardRegexMatcherSingleton.singleton().emailRegexMatcher) {
      validated = true
    }
    
    return validated
  }
}

class CreditCardNumberValidator {
  func validate(number: String) -> Bool {
    var validated = false
    let numberTrimmed = number.replacingOccurrences(of: " ", with: "")
    
    if let validatedNumber = numberTrimmed.wholeMatch(of: CreditCardRegexMatcherSingleton.singleton().numberMatcher) {
      validated = true
    }
    
    return validated
  }
}

class CreditCardExpirationValidator {
  func validate(expirationDate: String) -> Bool {
    var validated = false
    
    if let validatedDate = expirationDate.wholeMatch(of: CreditCardRegexMatcherSingleton.singleton().expirationDateMatcher) {
      validated = true
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMyy"
      if let date = dateFormatter.date(from: expirationDate) {
        if let expiryDate = Calendar.current.date(byAdding: .month, value: 1, to: date) {
          if expiryDate > Date.now {
            
            validated = true
          } else {
            validated = false
          }
        }
      } else {
        validated = false
      }
    }
    
    return validated
  }
}

class CreditCardCVCValidator {
  func validate(cvc: String) -> Bool {
    var validated = false
    
    if let validatedNumber = cvc.wholeMatch(of: CreditCardRegexMatcherSingleton.singleton().cvcMatcher) {
      validated = true
    }
    
    return validated
  }
}

class CreditCardZipCodeValidator {
  func validate(zip: String) -> Bool {
    var validated = false
    
    if let validatedNumber = zip.wholeMatch(of: CreditCardRegexMatcherSingleton.singleton().zipCodeMatcher) {
      validated = true
    }
    
    return validated
  }
}

class CreditCardValidator {
  private static var sharedInstance: CreditCardValidator?
  
  private init() { }
  
  public class func singleton() -> CreditCardValidator {
    if sharedInstance == nil {
      sharedInstance = CreditCardValidator()
    }
    return sharedInstance!
  }
  
  let nameValidator = CreditCardNameValidator()
  let emailValidator = CreditCardEmailValidator()
  let numberValidator = CreditCardNumberValidator()
  let expirationValidator = CreditCardExpirationValidator()
  let cvcValidator = CreditCardCVCValidator()
  let zipCodeValidator = CreditCardZipCodeValidator()
  
  func validate(name: String, email: String, number: String, expiration: String, cvc: String, zip: String) -> [(passed: Bool, error: PaymentError)] {
    var validations: [(Bool, error: PaymentError)] = [
      (passed: self.nameValidator.validate(name: name), error: .invalidNameOnCard),
      (passed: self.emailValidator.validate(email: email), error: .invalidEmailAddress),
      (passed: self.numberValidator.validate(number: number), error: .invalidCreditCardNumber),
      (passed: self.expirationValidator.validate(expirationDate: expiration), error: .invalidExpirationDate),
      (passed: self.cvcValidator.validate(cvc: cvc), error: .invalidCVC),
      (passed: self.zipCodeValidator.validate(zip: zip), error: .invalidZipCode)
    ]
    
    return validations
  }
}

class PaymentAmountFormatter {
  static func formatAmount(amount: Double) -> String {
    String(format: "$%.2f", amount)
  }
}

class CreditCardProcessor: PaymentProcessor {
  var name: String
  var email: String
  var number: String
  var expiration: String
  var cvc: String
  var zip: String
  
  var validations: [(passed: Bool, error: PaymentError)] {
    CreditCardValidator.singleton().validate(name: name, email: email, number: number, expiration: expiration, cvc: cvc, zip: zip)
  }
  
  init(name: String, email: String, number: String, expiration: String, cvc: String, zip: String) {
    self.name = name
    self.email = email
    self.number = number
    self.expiration = expiration
    self.cvc = cvc
    self.zip = zip
  }
  
  func processPayment(amount: Double, purchasePrice: Double) throws {
    if amount < purchasePrice {
      throw PaymentError.insufficientFunds
    } else if amount >= purchasePrice && validations.map({ $0.0}).contains(false) {
      for validation in validations {
        if validation.passed == false {
          throw validation.error
        }
      }
    } else {
      print("Credit card payment in the amount of \(PaymentAmountFormatter.formatAmount(amount: amount)) succeeded!")
    }
  }
}

class CashProcessor: PaymentProcessor {
  var billsAreCounterfeit: Bool = false
  
  init(billsAreCounterfeit: Bool = false) {
    self.billsAreCounterfeit = billsAreCounterfeit
  }
  
  func processPayment(amount: Double, purchasePrice: Double) throws {
    if amount < purchasePrice {
      throw PaymentError.insufficientFunds
    } else if billsAreCounterfeit {
      throw PaymentError.billsAreCounterfeit
    } else {
      print("Cash payment in the amount of \(PaymentAmountFormatter.formatAmount(amount: amount)) succeeded!")
    }
  }
}



func handleCreditCardPayments(amount: Double, purchasePrice: Double, paymentProcessor: PaymentProcessor) {
  let prefix = "Credit card payment failed."
  
  do {
    try paymentProcessor.processPayment(amount: amount, purchasePrice: purchasePrice)
  } catch PaymentError.insufficientFunds {
    let difference = purchasePrice - amount
    print("\(prefix) Your credit card balance is too low.")
  } catch PaymentError.invalidNameOnCard {
    print("\(prefix) Invalid card name.")
  } catch PaymentError.invalidEmailAddress {
    print("\(prefix) Invalid email address.")
  } catch PaymentError.invalidCreditCardNumber {
    print("\(prefix) Invalid credit card number.")
  } catch PaymentError.invalidExpirationDate {
    print("\(prefix) Invalid expiration date.")
  } catch PaymentError.invalidCVC {
    print("\(prefix) Invalid CVC code.")
  } catch PaymentError.invalidZipCode {
    print("\(prefix) Invalid Zip code.")
  } catch {
    print("\(prefix) There was an unknown error. Please try again or use a different payment method.")
  }
}

func handleCashPayments(amount: Double, purchasePrice: Double, paymentProcessor: PaymentProcessor) {
  let prefix = "Cash payment failed."
  
  do {
    try paymentProcessor.processPayment(amount: amount, purchasePrice: purchasePrice)
  } catch PaymentError.insufficientFunds {
    let difference = purchasePrice - amount
    print("\(prefix) Please insert $\(PaymentAmountFormatter.formatAmount(amount: difference)) more.")
  } catch PaymentError.billsAreCounterfeit {
    print("\(prefix) We are unable to accept these bills because they are not legal tender.")
  } catch {
    print("\(prefix) There was an unknown error. Please try again or use a different payment method.")
  }
}

var cashProcessor = CashProcessor()
var creditCardProcessor = CreditCardProcessor(name: "Jake Peralta", email: "jakeperalta@gmail.com", number: "1234123412341234", expiration: "1224", cvc: "345", zip: "90210")

var amount = 20.5
var purchasePrice = 20.5

handleCashPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: cashProcessor)

amount = 15.5
handleCashPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: cashProcessor)

amount = 20.5
cashProcessor.billsAreCounterfeit = true
handleCashPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: cashProcessor)

purchasePrice = 500
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

amount = 500
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

creditCardProcessor.cvc = "8098"
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

creditCardProcessor.cvc = "345"
creditCardProcessor.email = "jakeperalta&gmail.com"
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

creditCardProcessor.email = "jakeperalta@gmail.com"
creditCardProcessor.zip = "9021"
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

creditCardProcessor.zip = "90210"
creditCardProcessor.name = "Jake$ P. Peralta-Higgins"
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

creditCardProcessor.name = "Jake S. Peralta"
creditCardProcessor.expiration = "0924"
handleCreditCardPayments(amount: amount, purchasePrice: purchasePrice, paymentProcessor: creditCardProcessor)

//: [Next](@next)
