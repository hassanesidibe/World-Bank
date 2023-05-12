//
//  CreditCardPaymentVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/8/23.
//

import UIKit
import AVFoundation

class CreditCardPaymentVC: UIViewController {

    var bankAccountmanager: BankAccountManager?
    var statementBalance: Double?
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var accountTypeSegmentedControl: UISegmentedControl!
    
    //These values will be set by HomeVC in prepare(for segue:)
    var checkingBalance: Double?
    var savingsBalance: Double?
    
    
    @IBOutlet weak var payOtherAmountStackView: UIStackView!
    @IBOutlet weak var payStatementBalanceButtonButtonBackground: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    
    //    I will use this imageview to show and hide the check mark
    @IBOutlet weak var checkMarkImageView: UIImageView!
    var soundPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedStatementBalance = self.statementBalance {
            balanceLabel.text = "Statement balance $\(unwrappedStatementBalance)"
        }
    }
    
    
    @IBAction func payStatementBalanceButtonPressed(_ sender: UIButton) {
//        print("payStatementBalanceButtonPressed()")
//        I WAS WORKING ON THIS
        if let unwrappedBankAccount = self.bankAccountmanager,
           let unwrappedStatementBalance = self.statementBalance {
            
//            print("SATEMENT BALANCE BEFORE PAYMENT: \(unwrappedStatementBalance)")
            
            //Hide pay other amount textfield and pay button
            payOtherAmountStackView.alpha = 0
            
//            I WAS WORKING ON THIS AND CREDIT CARD PAYMENT FILE
//            I am able to play sound now
            
            let accountIndex = accountTypeSegmentedControl.selectedSegmentIndex
            
            if accountIndex == 1 {
                //pay credit card from savings account
                unwrappedBankAccount.makeCreditCardPaymentUsingUserSavingsAccount(paymentAmount: unwrappedStatementBalance)
                playSound()
            } else {
                //Pay credit card from checking account
                unwrappedBankAccount.makeCreditCardPaymentUsingUserCheckingAccount(paymentAmount: unwrappedStatementBalance)
                playSound()
            }
            
            //play a sound, change statement balance shown in the label to Zero, and dismiss view
            
        } else {
            print("Error in CreditCardPaymentVC.payStatementBalanceButtonPressed(): bank account or statement balance is nil")
        }
        
    }
    
    @IBAction func payButtonPressed(_ sender: UIButton) {
        if self.bankAccountmanager != nil,
           let amountTextFieldValue = amountTextField.text,
           let unwrappedStatementBalance = self.statementBalance,
           let unwrappedCheckingBalance = self.checkingBalance,
           let unwrappedSavingsBalance = self.savingsBalance {
            
            if paymentAmountIsValid(amountString: amountTextFieldValue) {
                //Make sure there is enough money in checking account, or savings before processing the credit card payment
                let paymentAmountDouble = Double(amountTextFieldValue)!
                let selectedAccount = accountTypeSegmentedControl.selectedSegmentIndex
                
                if selectedAccount == 0 {
                    //Pay from checking account
                    if paymentAmountDouble <= unwrappedCheckingBalance && paymentAmountDouble <= unwrappedStatementBalance {
                        self.bankAccountmanager?.makeCreditCardPaymentUsingUserCheckingAccount(paymentAmount: paymentAmountDouble)
                        
                        playSound()
                        self.dismiss(animated: true)
                    } else {
                        print("Error in CreditCardPaymentVC.payButtonPressed() - Not enough money in checking account to pay credit card, or the amount entered exceeds the credit card balance")
                    }
                    
                } else if selectedAccount == 1 {
                    //Pay from savings account
//                    print("GREETINGS GREETINGS GREETINGS")
                    if paymentAmountDouble <= unwrappedSavingsBalance && paymentAmountDouble <= unwrappedStatementBalance{
                        self.bankAccountmanager?.makeCreditCardPaymentUsingUserSavingsAccount(paymentAmount: paymentAmountDouble)
                        playSound()
                        self.dismiss(animated: true)
                    } else {
                        print("Error in CreditCardPaymentVC.payButtonPressed() - Not enough money in savings account to pay credit card, or the amount entered exceeds the credit card balance")
                    }
                    
                }
                
                //Hide pay statement balance button
                payStatementBalanceButtonButtonBackground.alpha = 0
                
            } else {
                print("Error in CreditCardPaymentVC.payButtonPressed() - Please provide an amount greater than zero")
            }
            
            
            
        }
    }
    
    
    func paymentAmountIsValid(amountString: String) -> Bool {
        if let paymentAmount = Double(amountString) {
            
            if paymentAmount > 0 {
                return true
            } else { return false}
            
        } else {
            return false
        }
        
    }
    
    
    
    
    
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "dingSound", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
