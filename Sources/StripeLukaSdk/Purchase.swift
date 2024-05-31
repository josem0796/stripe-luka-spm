//
//  File.swift
//  
//
//  Created by Jose Moran on 31/5/24.
//

import Foundation

public class Purchase : Codable {
  let amount : Double
  let currency: String
  var lukaId: String = LukaStripeSdk.instance.session.lukaCustomerId
  
  public init(amount: Double, currency: StripeCurrency) {
    self.amount = amount
    self.currency = currency.rawValue
  }
  
  public func setLukaId(id: String) {
    self.lukaId = id
  }
  
  enum CodingKeys : String, CodingKey {
    case amount = "monto"
    case currency = "moneda"
    case lukaId = "idTraza"
  }
  
}

public enum StripeCurrency : String {
  case usd = "usd"
  case eur = "eur"
  case clp = "clp"
  case mxn = "mxn"
  case cad = "cad"
}
