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
    func didFinishFetching_chekingAccountBalance(_ bankAccountManager: BankAccountManager, balance: Double)
    func didFinishFetching_savingsAccountBalance(_ bankAccountManager: BankAccountManager, balance: Double)
    func didFinishFetching_creditCardAccountBalance(_ bankAccountManager: BankAccountManager, balance: Double)
    
    func didFinishDepositingMoneyTo_checkingAccount(_ bankAccountManager: BankAccountManager)
    func didFinishDepositingMoneyTo_savingsAccount(_ bankAccountManager: BankAccountManager)
    func didFinishMakingCreditCardPayment(_ bankAccountManager: BankAccountManager)
    
    func didFinishTransferringMoney_fromChecking(_ bankAccountManager: BankAccountManager, transferAmount: Double)
    func didFinishTransferringMoney_fromSavings(_ bankAccountManager: BankAccountManager, transferAmount: Double)
}


class BankAccountManager {
    
    var userEmail: String
    let db = Firestore.firestore()
    typealias bankAccountConstants = K.FStore.BankAccount
    
    var delegate: BankAccountDelegate?
    
    
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
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
                        
                        switch accountType {
                        case .checking:
                            //Add money to checking account
                            print("Depositing \(depositAmount) to checking")
                            let checkingBalanceString = accountData[K.FStore.BankAccount.checkingBalanceField] as! String
                            if let currentCheckingBalanceDouble = Double(checkingBalanceString) {
                                let newBalance = (currentCheckingBalanceDouble + depositAmount)
                                userAccountReference.updateData([K.FStore.BankAccount.checkingBalanceField : "\(newBalance)"])
                                self.delegate?.didFinishDepositingMoneyTo_checkingAccount(self)
                            }
                            
                        case .savings:
                            //Add money to savings account
                            print("Depositing \(depositAmount) to savings")
                            let savingsBalanceString = accountData[K.FStore.BankAccount.savingsBalanceField] as! String
                            if let currentSavingsBalanceDouble = Double(savingsBalanceString) {
                                let newBalance = (currentSavingsBalanceDouble + depositAmount)
                                userAccountReference.updateData([K.FStore.BankAccount.savingsBalanceField : "\(newBalance)"])
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

    
    
    
    
    func makeCreditCardPayment(amount: String) {
        
        
        
    }
    
}



//MARK: - Retrieving account Info
extension BankAccountManager {
    
    
    func fetchBalance(for accountType: BankAccountType) {
        var balanceString: String?
        
        db.collection(K.FStore.BankAccount.collectionName)
            .whereField(K.FStore.BankAccount.emailField, isEqualTo: userEmail)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if let accountDocument = querySnapshot!.documents.first {
                        let accountDataDictionary = accountDocument.data()
                        
                        
                        switch accountType {
                        case .checking:
                            balanceString =  accountDataDictionary[K.FStore.BankAccount.checkingBalanceField] as? String
                            
                            
                        case .savings:
                            balanceString = accountDataDictionary[K.FStore.BankAccount.savingsBalanceField] as? String
                        case .credit:
                            balanceString = accountDataDictionary[K.FStore.BankAccount.creditBalanceField] as? String
                            
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
