//
//  File.swift
//  
//
//  Created by Jose Moran on 31/5/24.
//

import Foundation

struct RepositoryFactory {
  
  private var _authRepository : AuthRepository? = nil
  
  mutating func authRepository() -> AuthRepository {
    if self._authRepository == nil {
      self._authRepository = AuthRepository()
    }
    
    return self._authRepository!
  }
  
  private var _paymentRepositoryRepository : PaymentRepository? = nil
  
  mutating func paymentRepositoryRepository() -> PaymentRepository {
    if self._paymentRepositoryRepository == nil {
      self._paymentRepositoryRepository = PaymentRepository()
    }
    
    return self._paymentRepositoryRepository!
  }
}
