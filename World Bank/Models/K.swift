//
//  K.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/27/23.
//

import Foundation

struct K {
    static let signUpToAccount = "signUpToAccount"
    static let loginToAccount = "loginToAccount"
    
    struct FStore {
        static let collectionName = "bankAccounts"
        static let firstNameField = "firstName"
        static let lastNameField = "lastName"
        static let emailField = "email"
        static let checkingBalanceField = "checking"
        static let savingsBalanceField = "savings"
        static let creditBalanceField = "credit"
    }
}
