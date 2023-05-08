//
//  BankAccountManagerDelegate.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/7/23.
//

import Foundation

protocol BankAccountManagerDelegate {
    func didFinishFetching_chekingAccountBalance(_ bankAccountManager: BankAccountManager, balance: Double)
    func didFinishFetching_savingsAccountBalance(_ bankAccountManager: BankAccountManager, balance: Double)
    func didFinishFetching_creditCardAccountBalance(_ bankAccountManager: BankAccountManager, balance: Double)
    
    func didFinishDepositingMoneyTo_checkingAccount(_ bankAccountManager: BankAccountManager)
    func didFinishDepositingMoneyTo_savingsAccount(_ bankAccountManager: BankAccountManager)
    func didFinishMakingCreditCardPayment(_ bankAccountManager: BankAccountManager)
    
    func didFinishTransferringMoney_fromChecking(_ bankAccountManager: BankAccountManager, transferAmount: Double)
    func didFinishTransferringMoney_fromSavings(_ bankAccountManager: BankAccountManager, transferAmount: Double)
}

