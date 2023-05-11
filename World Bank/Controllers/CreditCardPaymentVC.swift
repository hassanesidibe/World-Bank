//
//  CreditCardPaymentVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/8/23.
//

import UIKit
import AVFoundation

class CreditCardPaymentVC: UIViewController {

    var bankAccount: BankAccountManager?
    var statementBalance: Double?
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var accountTypeSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var payOtherAmountStackView: UIStackView!
    @IBOutlet weak var payStatementBalanceButtonButtonBackground: UIView!
    
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
        print("payStatementBalanceButtonPressed()")
//        I WAS WORKING ON THIS
        if let unwrappedBankAccount = self.bankAccount,
           let unwrappedStatementBalance = self.statementBalance {
            
            //Hide pay other amount textfield and pay button
            payOtherAmountStackView.alpha = 0
            
//            I WAS WORKING ON THIS AND CREDIT CARD PAYMENT FILE
            
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
//        print("payButtonPressed()")
//        I WAS WORKING ON THIS
        
        if let unwrappedBankAccount = self.bankAccount {
            //Hide pay statement balance button
            payStatementBalanceButtonButtonBackground.alpha = 0
            
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
