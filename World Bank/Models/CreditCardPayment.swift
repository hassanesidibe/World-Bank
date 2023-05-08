//
//  CreditCardPayment.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/7/23.
//

import Foundation

extension BankAccountManager {
    
    func makeCreditCardPayment(paymentAmount: Double) {
        
        db.collection(K.FStore.BankAccount.collectionName)
            .whereField(K.FStore.BankAccount.emailField, isEqualTo: self.userEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let userAccountReference = self.db.collection(K.FStore.BankAccount.collectionName).document(self.userEmail)
                        
                        
                        let creditCardBalanceString = accountData[K.FStore.BankAccount.creditBalanceField] as! String
                        if let currentCreditCardBalanceDouble = Double(creditCardBalanceString) {
                            let newBalance = currentCreditCardBalanceDouble - paymentAmount
                            userAccountReference.updateData([K.FStore.BankAccount.creditBalanceField : "\(newBalance)"])
                            self.delegate?.didFinishMakingCreditCardPayment(self)
                        }
                    }
                }
            }
    }
    
}
