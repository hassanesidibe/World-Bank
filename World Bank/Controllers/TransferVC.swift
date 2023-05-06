//
//  TransferVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/28/23.
//

import UIKit

class TransferVC: UIViewController {
    
    
    @IBOutlet weak var recipientEmailTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
//    @IBOutlet weak var accountPicker: UISegmentedControl!
    var bankAccount: BankAccountManager?
    var transferType: BankAccountType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        //Send money to account with the email provided in the email field
        
        print("Test 0")
        
        if let unwrappedBankAccount = self.bankAccount,
           let recipientEmail = recipientEmailTextField.text,
           let amount = Double(amountTextField.text!) {
            
            if let unwrappedTransferType = self.transferType {
                if unwrappedTransferType == .checking {
                    
                    unwrappedBankAccount.transferFromChecking(to: recipientEmail, amount: amount)
                    
                    print("Test 1")
                    
                } else if unwrappedTransferType == .savings {
                    unwrappedBankAccount.transferFromSavings(to: recipientEmail, transferAmount: amount)
                    print("Test 2")
                }
            }
            
        } else {
            print("Error unwrapping values in TransferVC.sendButtonPressed()")
        }
    }
    
}
