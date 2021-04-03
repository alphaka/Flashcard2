//
//  ViewController.swift
//  Flashcard2
//
//  Created by Alpha Kabinet Kaba on 3/6/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    // array that hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Read saved flashcards
        readSavedFlashcards()
    }
    
    // Opening an empty flashcard for the first time
    override func viewDidAppear(_ animated: Bool) {
        // Adding our initial flashcard if needed
        if flashcards.count == 0{
            //updateFlashcard(question: "What is the capital of Sweden?", answer: "Stockholm")
            performSegue(withIdentifier: "segway1", sender: self) // how to open a screen progmatically
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        
        UIView.transition(with: card, duration: 0.4, options: .transitionFlipFromRight, animations: {
            if(self.frontLabel.isHidden == false) {
                self.frontLabel.isHidden = true
            }else{
                self.frontLabel.isHidden = false
            }
        })
    }
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)}, completion: { finished in
            
                // Update labels
                self.updateLabels()
                
                // Run other animation
                self.animateCardIn()
        })
    }
    
    func animateCardIn() {
        // Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)
        
        // Animate card going back to its original position
        UIView.animate(withDuration: 0.4) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        // We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        // We set the flashcardsController property to self
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
        
        creationController.question.text = frontLabel.text
        creationController.answer.text = backLabel.text
    }
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        
        // Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        
        // Logging to the console
        print("😎 Added new flashcard")
        print("😎 We now have \(flashcards.count) flashcards")
        
        // Update current index
        currentIndex = flashcards.count-1
        print("😎 Our current index is \(currentIndex)")
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save the flashcard to disk
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons() {
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        // Incresse current index
        currentIndex = currentIndex + 1
        
        // Update buttons
        updateNextPrevButtons()
        
        animateCardOut()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        // Decrease current index
        currentIndex = currentIndex - 1
        
        // Update buttons
        updateNextPrevButtons()
        
        // Amination of the flashcard outward
        UIView.animate(withDuration: 0.4, animations: {
                        self.card.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)}, completion: { [self] finished in
                
                // Update labels
                self.updateLabels()
                
                // Start on the left side (don't animate this)
                card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)

                // Animate card going back to its original position
                UIView.animate(withDuration: 0.4) {
                    self.card.transform = CGAffineTransform.identity
                }
                
        })

    }
    
    func updateLabels() {
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk() {
        // From flahcard to array to dictionary array
        let dictionaryArray = flashcards.map{ (card) -> [String: String] in return ["question": card.question, "answer": card.answer]
            
        }
        
        // Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print("🥳 Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
           
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            // Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
    }
}
