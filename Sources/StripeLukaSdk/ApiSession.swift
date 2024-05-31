//
//  File.swift
//  
//
//  Created by Jose Moran on 30/5/24.
//

import Foundation
import Alamofire

class ApiConfig {
  static var baseUrl: String  {
   return LukaStripeSdk.instance.config.env == .live ?
    "https://lukaapi.payco.net.ve/api/v1" : "https://bspaycoapi-qa.payco.net.ve/api/v1"
  }
}


func provideCertificate() -> SecCertificate {
  
  let bundle = Bundle.main
  
  guard let certificatePath = bundle.url(forResource: "payco2024", withExtension: "cer") else {
      fatalError("Couldn't find certificate file")
  }

  let certificateData = NSData(contentsOf: certificatePath)
  return SecCertificateCreateWithData(nil, certificateData!)!
 
}

func provideSessionManager() -> Session {
  let certificateData = provideCertificate()
  let serverTrustPolicies: [String: ServerTrustEvaluating] = [
          "lukaapi.payco.net.ve": PinnedCertificatesTrustEvaluator(certificates: [certificateData]),
          "bspaycoapi-qa.payco.net.ve": PinnedCertificatesTrustEvaluator(certificates: [certificateData]),
      ]
  
  let sessionManager = Session(
    configuration: .default,
    serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies)
  )
  
  return sessionManager
}
