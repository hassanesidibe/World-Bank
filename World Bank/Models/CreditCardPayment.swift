//
//  CreditCardPayment.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/7/23.
//

import Foundation

extension BankAccountManager {
    
    //MARK: Credit payment using checking account
    func makeCreditCardPaymentUsingUserCheckingAccount(paymentAmount: Double) {
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
                        let checkingAccountBalanceString = accountData[K.FStore.BankAccount.checkingBalanceField] as! String
                        
                        if let currentCreditCardBalanceDouble = Double(creditCardBalanceString),
                           let currentCheckingBalanceDouble = Double(checkingAccountBalanceString) {
                            
                            //check if value of savings account is greater than the credit card payment amount, before withdrawing money from savings account.
                            if currentCheckingBalanceDouble >= currentCreditCardBalanceDouble {
                                let newCreditCardBalance = currentCreditCardBalanceDouble - paymentAmount
                                let newCheckingAccountBalance = currentCheckingBalanceDouble - paymentAmount
                                //update credit card, and savings in the firestore
                                userAccountReference.updateData([K.FStore.BankAccount.creditBalanceField : "\(newCreditCardBalance)"])
                                userAccountReference.updateData([K.FStore.BankAccount.checkingBalanceField : "\(newCheckingAccountBalance)"])
                                
                                self.delegate?.didFinishMakingCreditCardPayment(self)
                                
                                
                            } else {
                                print("Error in CreditCardPayment file, in makeCreditCardPaymentUsingUserCheckingAccount(): Not enough fund in checking account to make credit card payment.")
                            }
                        }
                    }
                }
            }
    }
    
    
    //MARK: Credit card payment using savings account
    func makeCreditCardPaymentUsingUserSavingsAccount(paymentAmount: Double) {
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
                        let savingsAccountBalanceString = accountData[K.FStore.BankAccount.savingsBalanceField] as! String
                        
                        if let currentCreditCardBalanceDouble = Double(creditCardBalanceString),
                           let currentSavingsBalanceDouble = Double(savingsAccountBalanceString) {
                            
                            //check if value of savings account is greater than the credit card payment amount, before withdrawing money from savings account.
                            if currentSavingsBalanceDouble >= currentCreditCardBalanceDouble {
                                let newCreditCardBalance = currentCreditCardBalanceDouble - paymentAmount
                                let newSavingsAccountBalance = currentSavingsBalanceDouble - paymentAmount
                                //update credit card, and savings in the firestore
                                userAccountReference.updateData([K.FStore.BankAccount.creditBalanceField : "\(newCreditCardBalance)"])
                                userAccountReference.updateData([K.FStore.BankAccount.savingsBalanceField : "\(newSavingsAccountBalance)"])
                                
                                self.delegate?.didFinishMakingCreditCardPayment(self)
                                
                                
                            } else {
                                print("Error in CreditCardPayment file, in makeCreditCardPaymentUsingUserSavingsAccount(): Not enough fund in savings account to make credit card payment.")
                            }
                        }
                    }
                }
            }
    }
    
}
