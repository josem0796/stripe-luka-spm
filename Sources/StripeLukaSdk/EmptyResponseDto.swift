//
//  File.swift
//  
//
//  Created by Jose Moran on 30/5/24.
//

import Foundation
import Alamofire

struct EmptyResponseDto : Codable, EmptyResponse {
  static func emptyValue() -> Self {
    return EmptyResponseDto.init()
  }
}
