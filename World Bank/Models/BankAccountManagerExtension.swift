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
                                    self.delegate?.didFinishTransferringMoney_fromChecking(self, transferAmount: amount)
                                    //postTransferNotification(amount, recipientEmail, senderEmail)
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
                                let checkingBalanceString = accountData[bankAccountConstants.checkingBalanceField] as! String
                                
                                if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                                    let newBalance = (currentCheckingBalanceDouble + transferAmount)
                                    userAccountReference.updateData([bankAccountConstants.checkingBalanceField : "\(newBalance)"])
                                    self.delegate?.didFinishTransferringMoney_fromSavings(self, transferAmount: transferAmount)
                                    
                                    // postTransferNotification(transferAmount, recipientEmail, senderEmail)
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
    
    
    
    func subtractFromChecking(transferAmount: Double) {
        //I will call this function in didFinishTransferringMoney_fromChecking() delegate method, to subtracct the amount that user tranferred from their checking account
        
        db.collection(bankAccountConstants.collectionName)
            .whereField(bankAccountConstants.emailField, isEqualTo: self.userEmail)
            .getDocuments { querySnapshot, error in
                if let err = error {
                    print("Error getting documents in BankAccountManager.subtract(): \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let userAccountReference = self.db.collection(bankAccountConstants.collectionName).document(self.userEmail)
                        
                        let checkingBalanceString = accountData[bankAccountConstants.checkingBalanceField] as! String
                        if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                            //Subtract the tranferred amount from user's checking account
                            let newBalance = (currentCheckingBalanceDouble - transferAmount)
                            userAccountReference.updateData([K.FStore.BankAccount.checkingBalanceField : "\(newBalance)"])
                            print("Test subtractFromChecking(): new checking balance = \(newBalance)")
                        }
                    }
                }
            }
    }
    
    
    func subtractFromSavings(transferAmount: Double) {
        //I will call this function in didFinishTransferringMoney_fromSavings() delegate method, to subtracct the amount that user tranferred from their savings account
        db.collection(bankAccountConstants.collectionName)
            .whereField(bankAccountConstants.emailField, isEqualTo: self.userEmail)
            .getDocuments { querySnapshot, error in
                if let err = error {
                    print("Error getting documents in BankAccountManager.subtractFromSavings(): \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let userAccountReference = self.db.collection(bankAccountConstants.collectionName).document(self.userEmail)
                        
                        let savingsBalanceString = accountData[bankAccountConstants.savingsBalanceField] as! String
                        if let currentSavingsBalanceDouble = Double(savingsBalanceString) {
                            //Subtract the tranferred amount from user's checking account
                            let newBalance = (currentSavingsBalanceDouble - transferAmount)
                            userAccountReference.updateData([K.FStore.BankAccount.savingsBalanceField : "\(newBalance)"])
                            print("\nTest subtractFromSavings(): new savings balance = \(newBalance)\n")
                        }
                    }
                }
            }
        
        
        
        
        
        
    }
    
    
    
}
