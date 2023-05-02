//
//  HomeVC.swift
//  World Bank
//
//  Created by Hassane Sidibe on 4/25/23.
//

//I NEED TO CREATE A GITHUB REPOSITORY FOR THIS APP


import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


//I WAS WORKING ON THIS NEW IMPLEMENTATION OF HomeVC, I COMMENTED THE OLD VERSION AT THE BOTTOM

class HomeVC: UIViewController {
    
    let db = Firestore.firestore()
    var bankAccount: BankAccount?   //This is my Model
    
    @IBOutlet weak var greetingLabel: UILabel!
    //checking account outlets
    @IBOutlet weak var checkingAccountNumberLabel: UILabel!
    @IBOutlet weak var checkingBalanceLabel: UILabel!
    //Savings account outlets
    @IBOutlet weak var savingsAccountNumberLabel: UILabel!
    @IBOutlet weak var savingsBalanceLabel: UILabel!
    //credit card account outlets
    @IBOutlet weak var creditAccountNumberLabel: UILabel!
    @IBOutlet weak var creditBalanceLabel: UILabel!
    
    var accountToDepositTo: BankAccountType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let unwrappedEmail = self.getSignedInUserEmail() {
            self.bankAccount = BankAccount(userEmail: unwrappedEmail)
            self.bankAccount?.delegate = self
            bankAccount?.fetchBalance(for: .checking)
            bankAccount?.fetchBalance(for: .savings)
            bankAccount?.fetchBalance(for: .credit)
            
        } else {
            print("The user's email was not set in HomeVC, so account information cannot be retrieve from database")
        }
    }
    
    
    
    //MARK: Depostit and payment
    @IBAction func depositToCheckingPressed(_ sender: UIButton) {
//        print("depositToCheckingPressed() ")
        
        accountToDepositTo = .checking
        performSegue(withIdentifier: K.accountScreenToDeposit, sender: self)
        
    }
    
    
    @IBAction func depositToSavingsPressed(_ sender: UIButton) {
//        print("depositToSavingsPressed()")
        accountToDepositTo = .savings
        performSegue(withIdentifier: K.accountScreenToDeposit, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.accountScreenToDeposit {
            let depositVC = segue.destination as! DepositVC
            if let unwrappedBankAccount = self.bankAccount {
                depositVC.bankAccount = self.bankAccount
                depositVC.accountType = accountToDepositTo
                
            } else {
                print("Error unwrapping bank account in HomeVC.prepare(for segue)")
            }
        }
        
        
    }
    
    
    
    
    
    //MARK: Transfer from cheking and savings
    @IBAction func transferFromCheckingPressed(_ sender: UIButton) {
        print("transferFromCheckingPressed")
    }
    
    
    @IBAction func transferFromSavingsPressed(_ sender: UIButton) {
        print("transferFromSavingsPressed")
    }
    
    
    
    
    
    //MARK: Credit card payment
    @IBAction func makeCreditCardPaymentPressed(_ sender: UIButton) {
        print("makeCreditCardPaymentPressed")
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        //sign out current user, and segueue to login screen
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    
    
}





//MARK: - BankAccount delegate inplementation
extension HomeVC: BankAccountDelegate {
    func didFinishFetching_chekingAccountBalance(_ bankAccount: BankAccount, balance: Double) {
        DispatchQueue.main.async {
            print("Success caling didFinishFetching_chekingAccountBalance() in HomeVC")
            self.checkingBalanceLabel.text = "\(balance)"
        }
    }
    
    func didFinishFetching_savingsAccountBalance(_ bankAccount: BankAccount, balance: Double) {
        print("Success caling didFinishFetching_savingsAccountBalance() in HomeVC")
        self.savingsBalanceLabel.text = "\(balance)"
    }
    
    func didFinishFetching_creditCardAccountBalance(_ bankAccount: BankAccount, balance: Double) {
        print("Success caling didFinishFetching_creditCardAccountBalance() in HomeVC")
        self.creditBalanceLabel.text = "\(balance)"
    }
    
    func didFinishDepositingMoneyTo_checkingAccount(_ bankAccount: BankAccount) {
        print("Hello from didFinishDepositingMoneyTo_checkingAccount()")
        self.bankAccount?.fetchBalance(for: .checking)
    }
    
    func didFinishDepositingMoneyTo_savingsAccount(_ bankAccount: BankAccount) {
        print("Hello from didFinishDepositingMoneyTo_savingsAccount()")
        self.bankAccount?.fetchBalance(for: .savings)
    }
    
    func didFinishMakingCreditCardPayment(_ bankAccount: BankAccount) {
        print("Hello from didFinishMakingCreditCardPayment()")
    }
    
    
}














//MARK: - Extensions and utilities
extension HomeVC {
    
    func userIsSignedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func getSignedInUserEmail() -> String? {
        if Auth.auth().currentUser != nil {
            if let userEmail = Auth.auth().currentUser!.email {
                return userEmail
            } else {
                print("Error loading email, in HomeVC.getSignedInUserEmail()")
                return nil
            }
            
        } else {
            print("Error no user is signed in, in HomeVC.getSignedInUserEmail()")
            return nil
        }
        
    }
    
    func fetchAccountDataAndUpdateUI() {
        
//        if let userEmail = getCurrentUserEmail() {
//            self.currentUserEmail = userEmail
//        }
        
        
        
        if Auth.auth().currentUser != nil {
            print("I have access to signed in user in HomeVC")
            if let userEmail = Auth.auth().currentUser!.email {
//                self.currentUserEmail = userEmail
                //Fetch login user's account info, including checking balance, savings balance, and credit.
                db.collection(K.FStore.collectionName).whereField(K.FStore.emailField, isEqualTo: userEmail)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            if let accountDocument = querySnapshot!.documents.first {
//                                print("\(accountDocument.documentID) => \(accountDocument.data())")
                                let accountData = accountDocument.data()
                                
                                let firstName = accountData[K.FStore.firstNameField]
                                let checkingBalance = accountData[K.FStore.checkingBalanceField]
                                let savingsBalance = accountData[K.FStore.savingsBalanceField]
                                let creditCardBalance = accountData[K.FStore.creditBalanceField]
                                
                                //Updating account info UI's
                                self.greetingLabel.text = "Good evening, \(firstName as! String)"
                                self.checkingBalanceLabel.text = (checkingBalance as! String)
                                self.savingsBalanceLabel.text = (savingsBalance as! String)
                                self.creditBalanceLabel.text = (creditCardBalance as! String)
                            }
                            
                        }
                }
                
            }
            
            
            
        } else {
            print("I do not have access to login user in HomeVC yet")
        }
    }
}









