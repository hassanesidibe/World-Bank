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
    @IBOutlet weak var accountPicker: UISegmentedControl!
    var bankAccount: BankAccountManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        //Send money to account with the email provided in the email field
        
        if let unwrappedBankAccount = self.bankAccount,
           let recipientEmail = recipientEmailTextField.text,
           let amount = Double(amountTextField.text!) {
            
            if getChosenAccount() == .checking {
                //transfer from checking account
                unwrappedBankAccount.transferFromChecking(to: recipientEmail, amount: amount)
                
            } else if getChosenAccount() == .savings {
                //transfer from savings account\
                unwrappedBankAccount.transferFromSavings(to: recipientEmail, transferAmount: amount)
            }
            
        }
    }
    
    
    func getChosenAccount() -> BankAccountType {
        if accountPicker.selectedSegmentIndex == 0 {
            return .checking
        } else {
            return .savings
        }
    }
    
}
