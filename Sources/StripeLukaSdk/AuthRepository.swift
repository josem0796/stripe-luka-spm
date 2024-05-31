//
//  File.swift
//  
//
//  Created by Jose Moran on 30/5/24.
//

import Foundation
import Combine
import Alamofire
import StripePayments

internal struct AuthRepository {
  
  func auth(username: String, password: String) -> AnyPublisher<String, Never> {
    
    return LukaStripeSdk.instance.apiSession.request(
      URL(string: "\(ApiConfig.baseUrl)/servicio/login")!,
      method: .post,
      parameters: ["Username":username, "Password": password],
      encoder: JSONParameterEncoder.prettyPrinted
    ).validate(statusCode: [200])
      .publishDecodable(type: EmptyResponseDto.self, emptyResponseCodes: [200])
      .compactMap { response in
        guard let token: String = response.response?.allHeaderFields["token"] as? String,
              let id: String = response.response?.allHeaderFields["id"] as? String else {
          return ""
        }
//
        print("token \(token), id: \(id)")
        LukaStripeSdk.instance.session.lukaCustomerId = id
        LukaStripeSdk.instance.session.lukaToken = token
        return token
      }
      .flatMap { token in
        return getConfig(token)
      }
      .eraseToAnyPublisher()
  }
  
  func getConfig(_ token: String = LukaStripeSdk.instance.session.lukaToken) -> AnyPublisher<String,Never> {
    
    return LukaStripeSdk.instance.apiSession.request(
      URL(string: "\(ApiConfig.baseUrl)/servicio/config")!,
        method: .get,
        headers: ["Authorization": "Bearer \(token)"]
    ).validate(statusCode: [200])
      .publishUnserialized()
      .compactMap { _ in
        LukaStripeSdk.instance.session.stripePk = "pk_test_bPy27MY9VfExlRLhdrzlO5CS00tDLoxJkD"
        STPAPIClient.shared.publishableKey = "pk_test_bPy27MY9VfExlRLhdrzlO5CS00tDLoxJkD"
        return LukaStripeSdk.instance.session.stripePk
      }
      .eraseToAnyPublisher()
  }
}
