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
    var timer = Timer()  //To control how long the payment sound should be played
    var soundPlayer: AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedStatementBalance = self.statementBalance {
            balanceLabel.text = "Statement balance $\(unwrappedStatementBalance)"
        }
        
        self.checkMarkImageView.alpha = 0
    }
    
    
    @IBAction func payStatementBalanceButtonPressed(_ sender: UIButton) {
//        print("payStatementBalanceButtonPressed()")
//        I WAS WORKING ON THIS
        if let unwrappedBankAccount = self.bankAccountmanager,
           let unwrappedStatementBalance = self.statementBalance {
            
            
            //If statement balance is zero than we do not process any transaction
            if unwrappedStatementBalance != 0 {
                //Hide pay other amount textfield and pay button
                payOtherAmountStackView.alpha = 0
                let accountIndex = accountTypeSegmentedControl.selectedSegmentIndex
                
                if accountIndex == 1 {
                    //pay credit card from savings account
                    unwrappedBankAccount.makeCreditCardPaymentUsingUserSavingsAccount(paymentAmount: unwrappedStatementBalance)
                    playSound()
                    showCheckMark()
                    self.updateStatementBalanceLabelAfterPayment(of: unwrappedStatementBalance)
                    dismissViewAfter(numberOfSeconds: 1)
                } else {
                    //Pay credit card from checking account
                    unwrappedBankAccount.makeCreditCardPaymentUsingUserCheckingAccount(paymentAmount: unwrappedStatementBalance)
                    playSound()
                    showCheckMark()
                    self.updateStatementBalanceLabelAfterPayment(of: unwrappedStatementBalance)
                    dismissViewAfter(numberOfSeconds: 1)
                }
                
            } else {
                //The credit card balance is Zero here, so we will dismiss the view after 2 seconds
                self.balanceLabel.textColor = .red
                self.dismissViewAfter(numberOfSeconds: 2)
            }
            
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
                        showCheckMark()
                        self.updateStatementBalanceLabelAfterPayment(of: paymentAmountDouble)
                        dismissViewAfter(numberOfSeconds: 1)
                        
                    } else {
                        print("Error in CreditCardPaymentVC.payButtonPressed() - Not enough money in checking account to pay credit card, or the amount entered exceeds the credit card balance")
                    }
                    
                } else if selectedAccount == 1 {
                    //Pay from savings account
                    if paymentAmountDouble <= unwrappedSavingsBalance && paymentAmountDouble <= unwrappedStatementBalance{
                        self.bankAccountmanager?.makeCreditCardPaymentUsingUserSavingsAccount(paymentAmount: paymentAmountDouble)
                        playSound()
                        self.showCheckMark()
                        self.updateStatementBalanceLabelAfterPayment(of: paymentAmountDouble)
                        dismissViewAfter(numberOfSeconds: 1)
                        
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
    
    

    
    

    
    //MARK: - Helper functions
    
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
    
    //Dismiss CreditCardPaymentVC after the specified number of seconds
    func dismissViewAfter(numberOfSeconds: Int) {
        var secondsPassed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsPassed < numberOfSeconds {
                secondsPassed += 1
            } else {
                self.timer.invalidate()
                self.dismiss(animated: true)
            }
        }
    }
    
    private func showCheckMark() {
        self.checkMarkImageView.alpha = 1
    }
    
    func updateStatementBalanceLabelAfterPayment(of payedAmount: Double) {
       //Make sure the payedAmount is less than or equal to the statement balance, before updating the statement balance label
        if let unwrappedStatementBalance = self.statementBalance {
            if payedAmount <= unwrappedStatementBalance {
                let newCreditBalance = unwrappedStatementBalance - payedAmount
                self.balanceLabel.text = "Statement balance $\(newCreditBalance)"
                
            } else { print("Error in CreditCardPaymentVC.updateStatementBalanceLabelAfterPayment() - peyed amount is greater than statement balance")}
            
        } else {
            print("Error in CreditCardPaymentVC.updateStatementBalanceLabelAfterPayment() - statement balance variable is nil")
        }
        
        
        
    }
}
