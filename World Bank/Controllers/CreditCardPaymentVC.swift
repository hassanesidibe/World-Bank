//
//  CreditCardPaymentVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 5/8/23.
//

import UIKit

class CreditCardPaymentVC: UIViewController {

    var bankAccount: BankAccountManager?
    var statementBalance: Double?
    
    @IBOutlet weak var balanceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedStatementBalance = self.statementBalance {
            balanceLabel.text = "Statement balance $\(unwrappedStatementBalance)"
        }
    }
    
    
    @IBAction func payStatementBalanceButtonPressed(_ sender: UIButton) {
        print("payStatementBalanceButtonPressed()")
        
    
        
        
    }
    
    @IBAction func payButtonPressed(_ sender: UIButton) {
        print("payButtonPressed()")
        
        
        
        
    }
}
