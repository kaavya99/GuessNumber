//
//  ViewController.swift
//  GuessTheNumber
//
//  Created by Kaavya Singhal on 8/31/20.
//  Copyright © 2020 Kaavya Singhal. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    let lowerBound = 1
    let upperBound = 100
    var numberToGuess: Int!
    var numberofGuesses = 0
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureNavigationBar(withTitle: user.name, prefersLargeTitles: false)
        }
    }
    
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var guessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateRandomNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        authenticateUser()
    }
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            fetchUser()
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            self.user = user
        })
        
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    @IBAction func didTapHistory(_ sender: Any) {
        guard let user = user else { return }
        let controller = GameHistoryController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func generateRandomNumber() {
        numberToGuess = Int(arc4random_uniform(100)) + 1
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let guess = guessTextField.text {
            if let guessInt = Int(guess) {
                numberofGuesses = numberofGuesses + 1
                validateGuess(guessInt)
            }
        }
        guessTextField.text = ""
    }
    
    func validateGuess(_ guess: Int) {
        if guess < lowerBound || guess > upperBound {
            showBoundsAlert()
        } else if guess < numberToGuess {
            guessLabel.text = "Higher than \(guess)!"
        } else if guess > numberToGuess {
            guessLabel.text = "Lower than \(guess)!"
        } else {
            endGame()
        }
    }
    
    func endGame() {
        showWinAlert()
        
        saveUserData { (success) in
            if success {
                self.guessLabel.text = "Guess the Number"
                self.numberofGuesses = 0
                self.generateRandomNumber()
            } else {
                print("DEBUG: error saving data")
            }
        }
    }
    
    func saveUserData(completion: @escaping(Bool)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard var user = user else { return }
        
        var games = user.games
        games.append(numberofGuesses)
        user.games = games
        self.user = user
        
        let values = ["games": games] as [String : [Int]]
        Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func showBoundsAlert() {
        let alert = UIAlertController(title: "Hey!", message : "Your guess should be between 1 and 100!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWinAlert() {
        let alert = UIAlertController(title: "Congrats!", message: "You won with a total of \(numberofGuesses) guesses", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play again", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    

}

