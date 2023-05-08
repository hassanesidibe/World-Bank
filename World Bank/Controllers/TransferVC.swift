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
        
        if let unwrappedBankAccount = self.bankAccount,
           let recipientEmail = recipientEmailTextField.text,
           let amount = Double(amountTextField.text!) {
            
            if let unwrappedTransferType = self.transferType {
                
                switch unwrappedTransferType {
                case .checking:
                    unwrappedBankAccount.transferFromChecking(to: recipientEmail, amount: amount)
                case .savings:
                    unwrappedBankAccount.transferFromSavings(to: recipientEmail, transferAmount: amount)
                case .credit:
                    print("Make credit card payment in TransferVC.sendButtonPressed()")
                    unwrappedBankAccount.makeCreditCardPayment(paymentAmount: amount)
                    
                    
                }
            }
            
        } else {
            print("Error unwrapping values in TransferVC.sendButtonPressed()")
        }
    }
    
}
