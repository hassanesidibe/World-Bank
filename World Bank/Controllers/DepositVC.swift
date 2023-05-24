//
//  DepositVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/28/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

protocol DepositVCManager {
    func didFinishDepositingMoneyToAccount(_ depositVC: DepositVC)
    func failedToDepositMoneyToAccount(_ depositVC: DepositVC, error: Error)
}


class DepositVC: UIViewController {
    
    let db = Firestore.firestore()
    var banAccount: BankAccountManager?
    var signedInUserEmail: String?
    var soundPlayer: AVAudioPlayer?
    var timer = Timer() //To control how long the payment sound should be played
    
    
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var xmark: UIImageView!
    
//    HomeVC's prepare for segue method will assign a value to this bank account variable below
    var bankAccount: BankAccountManager?
    
    var accountType: BankAccountType?
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let unwrappedAccountType = accountType {
            switch unwrappedAccountType {
            case .checking:
                messageLabel.text = "Checking (XXXX)"
            case .savings:
                messageLabel.text = "Savings (XXXX)"
            case .credit:
                messageLabel.text = "Credit card (XXXX)"
            }
        }
        
        hideCheckmarkAndXmark()
    }
    

    
    @IBAction func depositButtonPressed(_ sender: UIButton) {
        
//        I HAVE TO ADD A CHECK MARK or Xmark TO TransferVC VIEW WHEN transfer button is pressed, I also need to implement the red xmark for credit card payment. The credit card payment already has a greene check mark, i only need add a red check mark to it
        
        if Auth.auth().currentUser != nil {
            if let userEmail = Auth.auth().currentUser?.email {
                signedInUserEmail = userEmail
                //I have access to signed in user's account here
                if let amountString = amountTextField.text {
                    if let amount = Double(amountString) {
                        
                        if let unwrappedBankAccount = self.bankAccount {
                            if accountType == .checking {
                                unwrappedBankAccount.deposit(amount, to: .checking)
                                showCheckMarkAndPlaySound()
                                dismissViewAfter(numberOfSeconds: 2)
                                        
                            } else if accountType == .savings {
                                unwrappedBankAccount.deposit(amount, to: .savings)
                                showCheckMarkAndPlaySound()
                                dismissViewAfter(numberOfSeconds: 2)
                            }
                        }
                        
                    } else {
                        showXmarkFor(numberOfSeconds: 1)
                    }
                }
                
            }
            
        } else {
            print("No one is signed in in DepositVC")
        }
        
    }
}


//Play sound and dismiss view after deposit
extension DepositVC {
    
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
}


//MARK: - Show and hide checkmark
extension DepositVC {
    
    func hideCheckmarkAndXmark() {
        checkmark.isHidden = true
        xmark.isHidden = true
    }
    
    func showCheckMarkAndPlaySound() {
        checkmark.isHidden = false
        xmark.isHidden = true
        playSound()
    }
    
    func showXmarkFor(numberOfSeconds: Int) {
        checkmark.isHidden = true
        xmark.isHidden = false
        self.timer.invalidate()
        
        var secondsPassed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsPassed < numberOfSeconds {
                secondsPassed += 1
            } else {
                self.timer.invalidate()
                self.xmark.isHidden = true
            }
        }
    }
}






