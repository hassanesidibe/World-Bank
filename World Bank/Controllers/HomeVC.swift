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


//THIS VIEW SHOULD FETCH TRANSFER NOTIFICATION, ANYTIME IT APPEARS

class HomeVC: UIViewController {
    
    let db = Firestore.firestore()
    var bankAccountManager: BankAccountManager?   //This is my Model
    var tranferType: BankAccountType? //Will store the type of account user will make transfer from
    
    typealias bankAccountConstants = K.FStore.BankAccount
    
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
            self.bankAccountManager = BankAccountManager(userEmail: unwrappedEmail)
            self.bankAccountManager?.delegate = self
            //Calling these methods below will trigger the associated delegate method, after fetching data
            bankAccountManager?.fetchBalance(for: .checking)
            bankAccountManager?.fetchBalance(for: .savings)
            bankAccountManager?.fetchBalance(for: .credit)
            
        } else {
            print("The user's email was not set in HomeVC, so account information cannot be retrieve from database")
        }
    }
    
    
    
    //MARK: Depostit to checking and savings
    @IBAction func depositToCheckingPressed(_ sender: UIButton) {
        accountToDepositTo = .checking
        performSegue(withIdentifier: K.accountScreenToDeposit, sender: self)
        
    }
    
    
    @IBAction func depositToSavingsPressed(_ sender: UIButton) {
        accountToDepositTo = .savings
        performSegue(withIdentifier: K.accountScreenToDeposit, sender: self)
    }
    
    //MARK: - SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if self.bankAccountManager != nil {
            
                if segue.identifier == K.accountScreenToDeposit {
                    let depositVC = segue.destination as! DepositVC
                    depositVC.bankAccount = self.bankAccountManager
                    depositVC.accountType = accountToDepositTo
                    
                } else if segue.identifier == K.accountScreenToTransfer {
                    let transferVC = segue.destination as! TransferVC
                    transferVC.bankAccount = self.bankAccountManager
                    
                    if tranferType == .checking {
                        if let checkingBalance = Double(checkingBalanceLabel.text!) {
                            transferVC.transferType = .checking
                            transferVC.accountBalance = checkingBalance
                        }
                        
                    } else if tranferType == .savings {
                        if let savingsBalance = Double(savingsBalanceLabel.text!) {
                            transferVC.transferType = .savings
                            transferVC.accountBalance = savingsBalance
                        }
                    }
                    
                } else if segue.identifier == K.accountScreenToCreditCardPayment {
                    if let creditBalance = Double(creditBalanceLabel.text!),
                       let checkingBalanceString = checkingBalanceLabel.text,
                       let savingsBalanceString = savingsBalanceLabel.text {
                        
                        let creditPaymentVC = segue.destination as! CreditCardPaymentVC
                        creditPaymentVC.bankAccountmanager = self.bankAccountManager
                        creditPaymentVC.statementBalance = creditBalance
                        
//                        PASSING checkingBalance and savingsBalance to CreditCardPaymentVC
                        
                        if let checkingBalanceDouble = Double(checkingBalanceString),
                           let savingsBalanceDouble = Double(savingsBalanceString) {
                            creditPaymentVC.checkingBalance = checkingBalanceDouble
                            creditPaymentVC.savingsBalance = savingsBalanceDouble
                        } else {
                            print("Error in HomeVC.prepare(for segue:) - Unable to unwrapped the values in checking account and savings account label")
                        }
                    }
                    
                }
             
        }  else {
            print("Error unwrapping bank account in HomeVC.prepare(for segue)")
        }
    }
    
    
//MARK: - Transfer
    
    
    
    //MARK: Transfer from cheking and savings
    @IBAction func transferFromCheckingPressed(_ sender: UIButton) {
        
        if let balanceString = checkingBalanceLabel.text {
            if let currentCheckingBalance = Double(balanceString) {
                
                if thereIsEnoughMoneyInAccountForTransfer(currentCheckingBalance) {
                    self.tranferType = .checking
                    self.performSegue(withIdentifier: K.accountScreenToTransfer, sender: self)
                }
            }
        }
    }
    
    
    @IBAction func transferFromSavingsPressed(_ sender: UIButton) {
//        print("transferFromSavingsPressed")
        if let balanceString = savingsBalanceLabel.text {
            if let currentSavingsBalance = Double(balanceString) {
                
                if thereIsEnoughMoneyInAccountForTransfer(currentSavingsBalance) {
                    self.tranferType = .savings
                    self.performSegue(withIdentifier: K.accountScreenToTransfer, sender: self)
                }
            }
        }
    }
    
    
    //MARK: Credit card payment
    @IBAction func makeCreditCardPaymentPressed(_ sender: UIButton) {
//        print("makeCreditCardPaymentPressed")
        self.performSegue(withIdentifier: K.accountScreenToCreditCardPayment, sender: self)
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
extension HomeVC: BankAccountManagerDelegate {

    func didFinishFetching_chekingAccountBalance(_ bankAccount: BankAccountManager, balance: Double) {
        DispatchQueue.main.async {
            print("Success caling didFinishFetching_chekingAccountBalance() in HomeVC")
            self.checkingBalanceLabel.text = "\(balance)"
        }
    }
    
    func didFinishFetching_savingsAccountBalance(_ bankAccount: BankAccountManager, balance: Double) {
        print("Success caling didFinishFetching_savingsAccountBalance() in HomeVC")
        self.savingsBalanceLabel.text = "\(balance)"
    }
    
    func didFinishFetching_creditCardAccountBalance(_ bankAccount: BankAccountManager, balance: Double) {
//        print("Success caling didFinishFetching_creditCardAccountBalance() in HomeVC")
        self.creditBalanceLabel.text = "\(balance)"
    }
    
    func didFinishDepositingMoneyTo_checkingAccount(_ bankAccount: BankAccountManager) {
//        print("Hello from didFinishDepositingMoneyTo_checkingAccount()")
        self.bankAccountManager?.fetchBalance(for: .checking)
    }
    
    func didFinishDepositingMoneyTo_savingsAccount(_ bankAccount: BankAccountManager) {
//        print("Hello from didFinishDepositingMoneyTo_savingsAccount()")
        self.bankAccountManager?.fetchBalance(for: .savings)
    }
    
    func didFinishMakingCreditCardPayment(_ bankAccountManager: BankAccountManager, from accountResponsibleForCardPayment: BankAccountType) {
        print("Hello from didFinishMakingCreditCardPayment()")
        //Reload credit card balance, and the bank account credit card was paid from
        self.bankAccountManager?.fetchBalance(for: .credit)
        if accountResponsibleForCardPayment == .checking {
            print("TEST 1: RELOAD CHECKING ACCOUNT")
            self.bankAccountManager?.fetchBalance(for: .checking)
        } else if accountResponsibleForCardPayment == .savings {
            print("TEST 2: RELOAD SAVINGS ACCOUNT")
            self.bankAccountManager?.fetchBalance(for: .savings)
        }
    }
    
    
    func didFinishTransferringMoney_fromChecking(_ bankAccountManager: BankAccountManager, transferAmount: Double) {
//        print("Hello from didFinishTransferringMoney_fromChecking()")
        
//        SUBTRACT tranferAmount from, the checking account money was tranfered from. In this case that is the login user in HomeVC
        
        
        self.bankAccountManager?.subtractFromChecking(transferAmount: transferAmount)
    }
    
    func didFinishTransferringMoney_fromSavings(_ bankAccountManager: BankAccountManager, transferAmount: Double) {
//        print("Hello from didFinishTransferringMoney_fromSavings")
        
//        SUBTRACT tranferAmount from, the savings account money was tranfered from. In this case that is the login user in HomeVC
        
        self.bankAccountManager?.subtractFromSavings(transferAmount: transferAmount)
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
    
    
    func thereIsEnoughMoneyInAccountForTransfer(_ transferAmount: Double) -> Bool {
        //There must be a minimum of $10 in the account in order to perform a transfer
        if transferAmount < 10 {
            print("Error in HomeVC.currentAccountBalanceIsGreaterThanTransferAmount(): Unable to transfer money, low checking balance $\(transferAmount)")
            return false
        } else {
            return true
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
        
        if Auth.auth().currentUser != nil {
            print("I have access to signed in user in HomeVC")
            if let userEmail = Auth.auth().currentUser!.email {
//                self.currentUserEmail = userEmail
                //Fetch login user's account info, including checking balance, savings balance, and credit.
                db.collection(bankAccountConstants.collectionName).whereField(bankAccountConstants.emailField, isEqualTo: userEmail)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            if let accountDocument = querySnapshot!.documents.first {
//                                print("\(accountDocument.documentID) => \(accountDocument.data())")
                                let accountData = accountDocument.data()
                                
                                let firstName = accountData[bankAccountConstants.firstNameField]
                                let checkingBalance = accountData[bankAccountConstants.checkingBalanceField]
                                let savingsBalance = accountData[bankAccountConstants.savingsBalanceField]
                                let creditCardBalance = accountData[bankAccountConstants.creditBalanceField]
                                
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









