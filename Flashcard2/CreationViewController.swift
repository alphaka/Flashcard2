//
//  CreationViewController.swift
//  Flashcard2
//
//  Created by Alpha Kabinet Kaba on 3/6/21.
//

import UIKit

class CreationViewController: UIViewController {

    var flashcardsController: ViewController!
    
    @IBOutlet weak var question: UITextField!
    @IBOutlet weak var answer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnDone(_ sender: Any) {
        // Get the text from the question text field
        let questionText = question.text
        
        // Get the text from the answer text field
        let answerText = answer.text
        
        // Call the function to update the flashcard
        flashcardsController.updateFlashcard(question: questionText!, answer: answerText!)
        if (questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty) {
            showAlert()
        } else {
            //Dismiss
            dismiss(animated: true)
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }

}
