//
//  BankAccount.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/30/23.
//

import Foundation
import FirebaseFirestore

//I WILL CREATE A BANK ACCOUNT INSTANCE IN MY VIEW CINTROLLERS

enum BankAccountType {
    case checking, savings, credit
}

protocol BankAccountDelegate {
    func didFinishFetching_chekingAccountBalance(_ bankAccount: BankAccount, balance: Double)
    func didFinishFetching_savingsAccountBalance(_ bankAccount: BankAccount, balance: Double)
    func didFinishFetching_creditCardAccountBalance(_ bankAccount: BankAccount, balance: Double)
    
    func didFinishDepositingMoneyTo_checkingAccount(_ bankAccount: BankAccount)
    func didFinishDepositingMoneyTo_savingsAccount(_ bankAccount: BankAccount)
    func didFinishMakingCreditCardPayment(_ bankAccount: BankAccount)
}


class BankAccount {
    
    var userEmail: String
    let db = Firestore.firestore()
    
    var delegate: BankAccountDelegate?
    
    
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
    func deposit(_ depositAmount: Double, to accountType: BankAccountType) {
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.emailField, isEqualTo: self.userEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountData = accountDocument.data()
                        let userAccountReference = self.db.collection(K.FStore.collectionName).document(self.userEmail)
                        
                        switch accountType {
                        case .checking:
                            //Add money to checking account
                            print("Depositing \(depositAmount) to checking")
                            let checkingBalanceString = accountData[K.FStore.checkingBalanceField] as! String
                            if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                                let newBalance = (currentCheckingBalanceDouble + depositAmount)
                                userAccountReference.updateData([K.FStore.checkingBalanceField : "\(newBalance)"])
                                self.delegate?.didFinishDepositingMoneyTo_checkingAccount(self)
                            }
                            
                        case .savings:
                            //Add money to savings account
                            print("Depositing \(depositAmount) to savings")
                            let savingsBalanceString = accountData[K.FStore.savingsBalanceField] as! String
                            if let currentSavingsBalanceDouble = Double(savingsBalanceString) {
                                let newBalance = (currentSavingsBalanceDouble + depositAmount)
                                userAccountReference.updateData([K.FStore.savingsBalanceField : "\(newBalance)"])
                                self.delegate?.didFinishDepositingMoneyTo_savingsAccount(self)
                            }
                            
                        case .credit:
                            //Make credit card payment
                            print("Making \(depositAmount) payment to credit card")
                            print("Warning: BankAccount.deposit() has not been inplemented for case: .credi")
                            self.delegate?.didFinishMakingCreditCardPayment(self)
                            
                        }
                    }
                }
            }
    }
    
    //MARK: Transfer money methods
    func transferFromChecking(amount: Double) {
        //Transfer money from checking account
    }
    
    func transferFromSavings(amount: Double) {
        //Transfer from savings account
        
        
    }
    
    func makeCreditCardPayment(amount: String) {
        
        
        
    }
    
//    func depositToChecking(depositAmount: Double) {
//
//        print("depositToChecking() called in BankAccount struct")
//
//
//            db.collection(K.FStore.collectionName)
//            .whereField(K.FStore.emailField, isEqualTo: self.userEmail)
//                .getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else {
//
//                        if let accountDocument = querySnapshot!.documents.first {
//                            let accountData = accountDocument.data()
//                            let checkingBalanceString = accountData[K.FStore.checkingBalanceField] as! String
//
//                            if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
//                                let newBalance = (currentCheckingBalanceDouble + depositAmount)
//
//                                let userAccountReference = self.db.collection(K.FStore.collectionName).document(self.userEmail)
//
//                                userAccountReference.updateData([K.FStore.checkingBalanceField : "\(newBalance)"])
////                                self.delegate?.didFinishDepositingMoneyToAccount(self)
//                            }
//
//
//                        }
//                    }
//            }
//
//
//    }
    

//    func depositToSavings(depositAmount: Double) {
//        print("depositToSavings() called in BankAccount struct")
//
//        db.collection(K.FStore.collectionName)
//            .whereField(K.FStore.emailField, isEqualTo: userEmail)
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//
//                    if let accountDocument = querySnapshot!.documents.first {
//                        let accountDataDictionary = accountDocument.data()
//                        let checkingBalanceString = accountDataDictionary[K.FStore.savingsBalanceField] as! String
//
//                        if let currentSavingsBalanceDouble = Double(checkingBalanceString) {
//                            let newBalance = (currentSavingsBalanceDouble + depositAmount)
//
//                            let userAccountReference = self.db.collection(K.FStore.collectionName).document(self.userEmail)
//
//                            userAccountReference.updateData([K.FStore.savingsBalanceField : "\(newBalance)"])
////                                self.delegate?.didFinishDepositingMoneyToAccount(self)
//                        }
//
//
//                    }
//                }
//        }
//
//
//}
     
}


//MARK: - Deposit, Transfer, and Payment
extension BankAccount {
    
}






//MARK: - Retrieving account Info
extension BankAccount {
    
    
    func getFirstName() -> String? {
        return nil
    }
    

    
    func fetchBalance(for accountType: BankAccountType) {
        var balanceString: String?
        
        db.collection(K.FStore.collectionName)
            .whereField(K.FStore.emailField, isEqualTo: userEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountDataDictionary = accountDocument.data()
                        
                        
                        switch accountType {
                        case .checking:
                            balanceString =  accountDataDictionary[K.FStore.checkingBalanceField] as? String
                            
                            
                        case .savings:
                            balanceString = accountDataDictionary[K.FStore.savingsBalanceField] as? String
                        case .credit:
                            balanceString = accountDataDictionary[K.FStore.creditBalanceField] as? String
                            
                        }
                        
                        
                        //Call the delegate methods with the balance retrieved from firestore
                        if let unwrappedBalanceString = balanceString {
                            if let balanceDouble = Double(unwrappedBalanceString) {
                                print("TEST 1: balanceDouble = \(balanceDouble)")
                                
                                switch accountType {
                                case .checking:
                                    self.delegate?.didFinishFetching_chekingAccountBalance(self, balance: balanceDouble)
                                case .savings:
                                    self.delegate?.didFinishFetching_savingsAccountBalance(self, balance: balanceDouble)
                                case .credit:
                                    self.delegate?.didFinishFetching_creditCardAccountBalance(self, balance: balanceDouble)
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                }
        }
    }
    
    
    
}
