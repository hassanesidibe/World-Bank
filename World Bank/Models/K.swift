//
//  K.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/27/23.
//

import Foundation

struct K {
    static let signUpScreenToAccount = "signUpToAccount"
    static let loginScreenToAccount = "loginToAccount"
    static let accountScreenToDeposit = "accountToDeposit"
    static let accountScreenToTransfer = "accountToTransfer"
    
    struct FStore {
        struct BankAccount {
            static let collectionName = "bankAccounts"
            static let firstNameField = "firstName"
            static let lastNameField = "lastName"
            static let emailField = "email"
            static let checkingBalanceField = "checking"
            static let savingsBalanceField = "savings"
            static let creditBalanceField = "credit"
        }
        
        struct TransferNotification {
            static let collectionName = "TransferNotifications"
            static let senderNameField = "senderName"
            static let senderEmailField = "senderEmail"
            static let amountField = "amountTransfered"
        }
    }
}
