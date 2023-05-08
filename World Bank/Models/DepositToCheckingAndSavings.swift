//
//  DepositToCheckingAndSavings.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/7/23.
//

import Foundation

extension BankAccountManager {
    
    func deposit(_ depositAmount: Double, to accountType: BankAccountType) {
        
        db.collection(K.FStore.BankAccount.collectionName)
            .whereField(K.FStore.BankAccount.emailField, isEqualTo: self.userEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let userAccountReference = self.db.collection(K.FStore.BankAccount.collectionName).document(self.userEmail)
                        
                        if accountType == .checking {
                            //Add money to checking account
                            print("Depositing \(depositAmount) to checking")
                            let checkingBalanceString = accountData[K.FStore.BankAccount.checkingBalanceField] as! String
                            if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                                let newBalance = (currentCheckingBalanceDouble + depositAmount)
                                userAccountReference.updateData([K.FStore.BankAccount.checkingBalanceField : "\(newBalance)"])
                                self.delegate?.didFinishDepositingMoneyTo_checkingAccount(self)
                            }
                            
                        } else if accountType == .savings {
                            //Add money to savings account
                            print("Depositing \(depositAmount) to savings")
                            let savingsBalanceString = accountData[K.FStore.BankAccount.savingsBalanceField] as! String
                            if let currentSavingsBalanceDouble = Double(savingsBalanceString) {
                                let newBalance = (currentSavingsBalanceDouble + depositAmount)
                                userAccountReference.updateData([K.FStore.BankAccount.savingsBalanceField : "\(newBalance)"])
                                self.delegate?.didFinishDepositingMoneyTo_savingsAccount(self)
                            }
                        }
                    }
                }
            }
        
    }
}
