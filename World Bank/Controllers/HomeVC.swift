//
//  HomeVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/25/23.
//

//I NEED TO CREATE A GITHUB REPOSITORY FOR THIS APP


import UIKit

class HomeVC: UIViewController {
    
    //checking account outlets
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var checkingAccountNumberLabel: UILabel!
    @IBOutlet weak var checkingBalanceLabel: UILabel!
    
    //Savings account outlets
    @IBOutlet weak var savingsAccountNumberLabel: UILabel!
    @IBOutlet weak var savingsBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Depostit and tranfer from checking
    @IBAction func depositToCheckingPressed(_ sender: UIButton) {
        print("depositToCheckingPressed")
    }
    
    @IBAction func transferFromCheckingPressed(_ sender: UIButton) {
        print("transferFromCheckingPressed")
    }
    
    
    
    
    
    //MARK: Deposit and transfer from savings
    @IBAction func depositToSavingsPressed(_ sender: UIButton) {
        print("depositToSavingsPressed")
        
    }
    
    @IBAction func transferFromSavingsPressed(_ sender: UIButton) {
        print("transferFromSavingsPressed")
    }
    
    //MARK: Credit card payment
    
    @IBAction func makeCreditCardPaymentPressed(_ sender: UIButton) {
        print("makeCreditCardPaymentPressed")
    }
    

}
