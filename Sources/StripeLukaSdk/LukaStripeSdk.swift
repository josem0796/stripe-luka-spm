// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine
import StripePaymentSheet

public class LukaStripeSdk : ObservableObject {

  static let instance = LukaStripeSdk()

  var operation: (any Operation)? = nil

  var config: Config = Config.default

  var session: LukaSession = LukaSession.default
  
  let apiSession = provideSessionManager()
  
  var repositoryFactory = RepositoryFactory()
  
  var isInitialized : Bool = false

  internal var disposables = Set<AnyCancellable>()
  
  @Published public var paymentSheetReady = false
  @Published public var paymentSheet: PaymentSheet?
  @Published public var paymentResult: PaymentSheetResult?

  public static func start(config: Config, callbacks: Config.Callbacks) {
    LukaStripeSdk.instance.config = config
    LukaStripeSdk.instance.repositoryFactory
      .authRepository()
      .auth(username: config.creds.username, password: config.creds.password)
      .sink {
        if !$0.isEmpty {
          callbacks.onSuccess()
          LukaStripeSdk.instance.isInitialized = true
        }else {
          callbacks.onError()
        }
      }.store(in: &LukaStripeSdk.instance.disposables)
  }
  
  public static func preparePaymentButton(purchase: Purchase) throws {
    guard LukaStripeSdk.instance.isInitialized else {
      throw LukaSdkError.runtimeError("SDK not initialized properly")
    }
    
    LukaStripeSdk.instance.repositoryFactory
      .paymentRepositoryRepository()
      .getPaymentIntent(purchase: purchase)
      .sink { intent in
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Lukapay"
        
        configuration.allowsDelayedPaymentMethods = true
        LukaStripeSdk.instance.paymentSheet = PaymentSheet(paymentIntentClientSecret: intent.clientSecret, configuration: configuration)
        LukaStripeSdk.instance.paymentSheetReady = true
      }.store(in: &LukaStripeSdk.instance.disposables)
  
  }
//
//
//  public static func processPayment(clientId: String, card: LukaCard, amount: Double, email: String, customTraceId: String) -> PaymentOperation {
//    return PaymentOperation(customerId: clientId, card: card, amount: amount, email: email, customerTraceId: customTraceId)
//  }
//  
//  public static func checkTransaction(traceId: String ) -> CheckTransactionOperation {
//    return CheckTransactionOperation(traceId: traceId)
//  }
//
//  public static func deleteCard(clientId: String, cardId: Int) -> DeleteCardOperation {
//    return DeleteCardOperation(customerId: clientId, cardId: cardId)
//  }
//
//  public static func getCards(clientId: String) -> GetCardsOperation {
//    return GetCardsOperation(customerId: clientId)
//  }
//
//  public static func addNewCard(navigationController: UINavigationController, email: String) -> AddCardOperation {
//    return AddCardOperation(controller: navigationController, email: email)
//  }
//  
//  public static func addNewCard( email: String) -> AddCardOperation {
//    return AddCardOperation(controller: nil, email: email)
//  }

}

//public class AddCardOperation: Operation{
//  public typealias G = AddCardResult
//  internal let email: String
//  internal let navController: UINavigationController?
//
//  init(controller: UINavigationController?, email: String) {
//    self.email = email
//    self.navController = controller
//  }
//
//  internal var successCall : ((AddCardResult) -> Void)? = nil
//  internal var errorCall : ((Error) -> Void)? = nil
//  internal var loadingCall : (() -> Void)? = nil
//
//  public func onSuccess(_ successCall: @escaping (AddCardResult) -> Void) -> any Operation {
//    self.successCall = successCall
//    return self
//  }
//
//  public func onError(_ errorCall : @escaping (Error) -> Void) -> any Operation {
//    self.errorCall = errorCall
//    return self
//  }
//
//  public func onLoading(_ loadingCall: @escaping (() -> Void)) -> any Operation {
//    self.loadingCall = loadingCall
//    return self
//  }
//
//  public func start() {
//    LukaBluesnapSdk.instance.operation = self
//    let hostingViewController = UIHostingController(rootView: LukaBluesnapView())
//    
//    if navController != nil {
//      navController?.pushViewController(hostingViewController, animated: true)
//      return
//    }
//    
//    
//    if let mainViewController = UIApplication.getMainViewController() {
//        // Now you can use the mainViewController as the main view controller.
//      mainViewController.pushViewController(hostingViewController, animated: true)
//    }
//  }
//
//  public func dismiss() {
//    
//    if navController != nil {
//      navController?.popViewController(animated: true)
//      return
//    }
//    
//    if let mainViewController = UIApplication.getMainViewController() {
//        // Now you can use the mainViewController as the main view controller.
//      mainViewController.popViewController(animated: true)
//    }
//  }
//
//}
//
//public class GetCardsOperation: Operation {
//
//  public typealias G = [LukaCard]
//  internal let customerId: String
//
//  init(customerId: String) {
//    self.customerId = customerId
//  }
//
//  internal var successCall : (([LukaCard]) -> Void)? = nil
//  internal var errorCall : ((Error) -> Void)? = nil
//  internal var loadingCall : (() -> Void)? = nil
//
//  public func onSuccess(_ successCall: @escaping ([LukaCard]) -> Void) -> any Operation {
//    self.successCall = successCall
//    return self
//  }
//
//  public func onError(_ errorCall : @escaping (Error) -> Void) -> any Operation {
//    self.errorCall = errorCall
//    return self
//  }
//
//  public func onLoading(_ loadingCall: @escaping (() -> Void)) -> any Operation {
//    self.loadingCall = loadingCall
//    return self
//  }
//
//  public func start() {
//    LukaBluesnapSdk.instance.operation = self
//    UseCaseFactory.listCardsUseCase.invoke(customerId: customerId)
//      .receive(on: DispatchQueue.main)
//      .sink { [weak self] list in
//        self?.successCall?(list)
//      }.store(in: &LukaBluesnapSdk.instance.disposables)
//  }
//}
//
//public class DeleteCardOperation: Operation {
//
//  public typealias G = Bool
//  internal let customerId: String
//  internal let cardId: Int
//
//  init(customerId: String, cardId: Int ) {
//    self.customerId = customerId
//    self.cardId = cardId
//  }
//
//  internal var successCall : ((Bool) -> Void)? = nil
//  internal var errorCall : ((Error) -> Void)? = nil
//  internal var loadingCall : (() -> Void)? = nil
//
//  public func onSuccess(_ successCall: @escaping (Bool) -> Void) -> any Operation {
//    self.successCall = successCall
//    return self
//  }
//
//  public func onError(_ errorCall : @escaping (Error) -> Void) -> any Operation {
//    self.errorCall = errorCall
//    return self
//  }
//
//  public func onLoading(_ loadingCall: @escaping (() -> Void)) -> any Operation {
//    self.loadingCall = loadingCall
//    return self
//  }
//
//  public func start() {
//    LukaBluesnapSdk.instance.operation = self
//    UseCaseFactory.deleteCardUseCase.invoke(customerId: customerId, cardId: cardId)
//      .receive(on: DispatchQueue.main)
//      .sink { [weak self] rst in
//        self?.successCall?(rst)
//      }.store(in: &LukaBluesnapSdk.instance.disposables)
//  }
//}
//
//public class PaymentOperation: Operation {
//  public typealias G = TransactionResult
//
//  internal let customerId: String
//  internal let card: LukaCard
//  internal let amount: Double
//  internal let email: String
//  internal let customerTraceId: String
//
//  init(customerId: String, card: LukaCard, amount: Double, email: String, customerTraceId: String) {
//    self.customerId = customerId
//    self.card = card
//    self.amount = amount
//    self.email = email
//    self.customerTraceId = customerTraceId
//  }
//
//  internal var successCall : ((TransactionResult) -> Void)? = nil
//  internal var errorCall : ((Error) -> Void)? = nil
//  internal var loadingCall : (() -> Void)? = nil
//
//  public func onSuccess(_ successCall: @escaping (TransactionResult) -> Void) -> any Operation {
//    self.successCall = successCall
//    return self
//  }
//
//  public func onError(_ errorCall : @escaping (Error) -> Void) -> any Operation {
//    self.errorCall = errorCall
//    return self
//  }
//
//  public func onLoading(_ loadingCall: @escaping (() -> Void)) -> any Operation {
//    self.loadingCall = loadingCall
//    return self
//  }
//
//  public func start() {
//    LukaBluesnapSdk.instance.operation = self
//    self.loadingCall?()
//    UseCaseFactory.processPaymentUseCase.invoke(customerId: customerId, card: card, amount: amount, email: email, customerTraceId: customerTraceId)
//      .receive(on: DispatchQueue.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .failure(let error):
//          debugPrint("failure to make payment")
//          self.errorCall?(error)
//
//        case .finished: debugPrint("Succefull payment")
//        }
//
//      }, receiveValue: { result in
//        self.successCall?(result)
//
//      }).store(in: &LukaBluesnapSdk.instance.disposables)
//  }
//
//
//}
//
//public class CheckTransactionOperation: Operation {
//  public typealias G = TransactionResponseDto
//
//  internal let traceId: String
//  init(traceId: String ) {
//    self.traceId = traceId
//  }
//
//  internal var successCall : ((TransactionResponseDto) -> Void)? = nil
//  internal var errorCall : ((Error) -> Void)? = nil
//  internal var loadingCall : (() -> Void)? = nil
//
//  public func onSuccess(_ successCall: @escaping (TransactionResponseDto) -> Void) -> any Operation {
//    self.successCall = successCall
//    return self
//  }
//
//  public func onError(_ errorCall : @escaping (Error) -> Void) -> any Operation {
//    self.errorCall = errorCall
//    return self
//  }
//
//  public func onLoading(_ loadingCall: @escaping (() -> Void)) -> any Operation {
//    self.loadingCall = loadingCall
//    return self
//  }
//
//  public func start() {
//    LukaBluesnapSdk.instance.operation = self
//    self.loadingCall?()
//    UseCaseFactory.checkTransactionUseCase.invoke(traceId: traceId)
//      .receive(on: DispatchQueue.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .failure(let error):
//          debugPrint("failure to check transaction")
//          self.errorCall?(error)
//
//        case .finished: debugPrint("Succefull retrieving transaction from Luka")
//        }
//
//      }, receiveValue: { result in
//        self.successCall?(result)
//
//      }).store(in: &LukaBluesnapSdk.instance.disposables)
//  }
//
//
//}
//
//
public protocol Operation {
  associatedtype G
  func onSuccess(_ successCall : @escaping (_ result : G) -> Void) -> any Operation
  func onError(_ errorCall : @escaping (_: Error) -> Void ) -> any Operation
  func onLoading(_ loadingCall : ( @escaping () -> Void)) -> any Operation
  func start()
}


public struct Config {
  var env: Environment
  var creds: SdkCredentials

  public init(env: Environment, creds: SdkCredentials) {
    self.env = env
    self.creds = creds
  }

  public static let `default` = Config(env: .sandbox, creds: .empty)

  public enum Environment {
    case sandbox
    case live
  }

  public struct SdkCredentials {
    let username: String
    let password: String

    public init(username: String, password: String) {
      self.username = username
      self.password = password
    }

    static let empty = SdkCredentials(username: "", password: "")
    
    func basic() -> String {
        let joined = "\(username):\(password)"
        let data = Data(joined.utf8)
        return "Basic \(data.base64EncodedString())"
    }
  }

  public typealias Callbacks = ConfigCallbacks

}

public protocol ConfigCallbacks {
  func onSuccess()
  func onError()
}

//
public class LukaSession {
  var lukaCustomerId: String = .empty
  var stripePk: String = .empty
  var lukaToken: String = .empty
  var clienId: String = .empty

  public static let `default` = LukaSession()
}
//
extension String {
  static let empty: String = ""
}


enum LukaSdkError: Error {
    case runtimeError(String)
}


//
//public typealias OnSuccess = (Any) -> Void
//public typealias OnError = (Error) -> Void
//public typealias OnLoading = () -> Void
//
