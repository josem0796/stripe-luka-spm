//
//  File.swift
//  
//
//  Created by Jose Moran on 31/5/24.
//

import Foundation
import Combine
import Alamofire

internal struct PaymentRepository {
  
  func getPaymentIntent(purchase: Purchase) -> AnyPublisher<PaymentIntentResponse, Never> {
    
    let token = LukaStripeSdk.instance.session.lukaToken
    
    return LukaStripeSdk.instance.apiSession.request(
      URL(string: "\(ApiConfig.baseUrl)/servicio/login")!,
      method: .post,
      parameters: purchase,
      encoder: JSONParameterEncoder.prettyPrinted,
      headers: ["Authorization": "Bearer \(token)"]
    ).validate(statusCode: [200])
      .publishDecodable(type: PaymentIntentResponse.self)
      .compactMap {
        return $0.value
      }
      .eraseToAnyPublisher()
  }

}


public class PaymentIntentResponse : Codable  {
  let transactionId: Int
  let paymentId: String
  let clientSecret: String
}
