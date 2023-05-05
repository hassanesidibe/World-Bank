//
//  BankAccountManagerExtension.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/5/23.
//

import Foundation


extension BankAccountManager {
    
    //MARK: Helper functions
    func isValidAmount(_ amount: Double) -> Bool {
        if amount < 10 || amount > 10000 {
            return false
        }
        return true
    }
    
    func recipientEmailIsDifferentFromSenderEmail(_ recipientEmail: String) -> Bool {
        if self.userEmail == recipientEmail {
            return false
        } else {
            return true
        }
    }
    
    
    //MARK: - Transfer functions
    func transferFromChecking(to recipientEmail: String, amount: Double) {
        //Transfer money from checking account, to recipient's checking account
        
        if recipientEmailIsDifferentFromSenderEmail(recipientEmail){
            //Email is valid, send money to recipient, and Add a notfification document to TransferNotifications collection
            if isValidAmount(amount) {
                db.collection(bankAccountConstants.collectionName)
                    .whereField(bankAccountConstants.emailField, isEqualTo: recipientEmail)
                    .getDocuments { querySnapshot, error in
                        if let err = error {
                            print("Error getting documents in BankAccountManager.transferFromChecking: \(err)")
                        } else {
                            
                            if let accountDocument = querySnapshot!.documents.first {
                                let accountData = accountDocument.data()
                                let userAccountReference = self.db.collection(bankAccountConstants.collectionName).document(recipientEmail)
                                
                                //Deposit to recipient's checking account
                                let checkingBalanceString = accountData[bankAccountConstants.checkingBalanceField] as! String
                                
                                
                                
                                if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                                    let newBalance = (currentCheckingBalanceDouble + amount)
                                    userAccountReference.updateData([K.FStore.BankAccount.checkingBalanceField : "\(newBalance)"])
                                    self.delegate?.didFinishTransferringMoney_fromChecking(self)
//                                    postTransferNotification(amount, recipientEmail, senderEmail)
                                }
                            }
                        }
                    }
                
            } else {
                print("Error from transferFromChecking(): Transfer amount must be $10 minimum to $10,000 maximum")
            }
            
        } else {
            print("Error in BankAccount.transferFromChecking(): current user email is the same as recipient email")
        }
    }
    
    func transferFromSavings(to recipientEmail: String, transferAmount: Double) {
        //Transfer money from savings account, to recipient's checking account
        
        if recipientEmailIsDifferentFromSenderEmail(recipientEmail){
            //Email is valid, send money to recipient, and Add a notfification document to TransferNotifications collection
            if isValidAmount(transferAmount) {
                db.collection(bankAccountConstants.collectionName)
                    .whereField(bankAccountConstants.emailField, isEqualTo: recipientEmail)
                    .getDocuments { querySnapshot, error in
                        if let err = error {
                            print("Error getting documents in BankAccountManager.transferFromSavings(): \(err)")
                        } else {
                            
                            if let accountDocument = querySnapshot!.documents.first {
                                let accountData = accountDocument.data()
                                let userAccountReference = self.db.collection(bankAccountConstants.collectionName).document(recipientEmail)
                                
                                //Deposit to recipient's checking account
                                let savingsBalanceString = accountData[bankAccountConstants.savingsBalanceField] as! String
                                
                                if let currentSavingsBalanceDouble = Double(savingsBalanceString) {
                                    let newBalance = (currentSavingsBalanceDouble + transferAmount)
                                    userAccountReference.updateData([bankAccountConstants.savingsBalanceField : "\(newBalance)"])
                                    self.delegate?.didFinishTransferringMoney_fromSavings(self)
                                    
//                                    postTransferNotification(transferAmount, recipientEmail, senderEmail)
                                }
                            }
                            
                            
                        }
                    }
                
            } else {
                print("Error in BankAccountManager.transferFromSavings(): Transfer amount must be $10 minimum to $10,000 maximum")
            }
            
        } else {
            print("Error in BankAccountManager.transferFromSavings(): current user email is the same as recipient email")
        }
    }
}
