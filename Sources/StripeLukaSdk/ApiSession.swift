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
  
//  let bundle = Bundle.main
//  
//  guard let certificatePath = bundle.url(forResource: "payco2024", withExtension: "cer") else {
//      fatalError("Couldn't find certificate file")
//  }
  
  let certString = "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"
  
  guard let data = Data(base64Encoded: certString) else {
    fatalError("Couldn't find certificate file")
  }

  let certificateData = NSData(data: data)
  return SecCertificateCreateWithData(nil, certificateData)!
 
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
