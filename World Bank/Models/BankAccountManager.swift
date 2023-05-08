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




class BankAccountManager {
    
    var userEmail: String
    let db = Firestore.firestore()
    typealias bankAccountConstants = K.FStore.BankAccount
    
    var delegate: BankAccountManagerDelegate?
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
    
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
