//
//  TransferVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/28/23.
//

import UIKit
import AVFoundation

class TransferVC: UIViewController {
    
    
    @IBOutlet weak var recipientEmailTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var xMark: UIImageView!
    
    
//    @IBOutlet weak var accountPicker: UISegmentedControl!
    var bankAccount: BankAccountManager?
    var transferType: BankAccountType?
    var accountBalance: Double?
    var timer = Timer() //To control how long the payment sound should be played
    var soundPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideCheckmarkAndXmark()
    }
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        //Send money to account with the email provided in the email field
        
        if let unwrappedBankAccount = self.bankAccount,
           let recipientEmail = recipientEmailTextField.text,
           let transferAmount = Double(amountTextField.text!),
           let unwrappedAccountBalance = self.accountBalance {
            
            if let unwrappedTransferType = self.transferType {
                
                if unwrappedAccountBalance >= transferAmount { //There is enough money in account for transfer
                    
                    if unwrappedTransferType == .checking {
                        unwrappedBankAccount.transferFromChecking(to: recipientEmail, amount: transferAmount)
                        showCheckMarkAndPlaySound()
                        dismissViewAfter(numberOfSeconds: 1)
                        
                    } else if unwrappedTransferType == .savings {
                        unwrappedBankAccount.transferFromSavings(to: recipientEmail, transferAmount: transferAmount)
                        showCheckMarkAndPlaySound()
                        dismissViewAfter(numberOfSeconds: 1)
                    }
                }
                 
                
            } else {
                //Unable to make transfer, transferType might be nil or transfer amount is greater than available funds
                showXmarkFor(numberOfSeconds: 2)
            }
            
        } else {
            print("Error unwrapping values in TransferVC.sendButtonPressed()")
        }
    }
    
}

extension TransferVC {
    
    func hideCheckmarkAndXmark() {
        checkMark.isHidden = true
        xMark.isHidden = true
    }
    
    func showCheckMarkAndPlaySound() {
        checkMark.isHidden = false
        xMark.isHidden = true
        playSound()
    }
    
    func showXmarkFor(numberOfSeconds: Int) {
        checkMark.isHidden = true
        xMark.isHidden = false
        self.timer.invalidate()
        
        var secondsPassed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsPassed < numberOfSeconds {
                secondsPassed += 1
            } else {
                self.timer.invalidate()
                self.xMark.isHidden = true
            }
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
}
