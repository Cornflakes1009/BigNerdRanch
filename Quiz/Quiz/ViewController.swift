//
//  ViewController.swift
//  Quiz
//
//  Created by HaroldDavidson on 12/20/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let questions = ["What is 7+7?", "What is the capital of Vermont?", "What is cognac made from?"]
    let answers = ["14", "Montpelier", "grapes"]
    var currentQuestionIndex = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextQuestionLabel.alpha = 0
    }
    
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBAction func showNextQuestion(_ sender: Any) {
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }

        nextQuestionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        let answer = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentQuestionLabel.text = questions[currentQuestionIndex]
        
        updateOffScreenLabel()
    }
    
    func updateOffScreenLabel() {
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
    }
    
    func animateLabelTransitions() {
        // forcing any changes if needed
        view.layoutIfNeeded()
        
        // updating the alpha and center x constraints
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
        UIView.animate(withDuration: 2.5, animations: {
            UIView.animate(withDuration: 2.5,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0,
                options: [.curveLinear],
                animations: {
                    self.currentQuestionLabel.alpha = 0
                    self.nextQuestionLabel.alpha = 1
                    
                    self.view.layoutIfNeeded()
                    }, completion: { _ in
                        swap(&self.currentQuestionLabel,
                        &self.nextQuestionLabel)
                        swap(&self.currentQuestionLabelCenterXConstraint,
                        &self.nextQuestionLabelCenterXConstraint)
                        
                        self.updateOffScreenLabel()
                    })
        })
        
        
        
    } // end of animateLabelTransitions()
}
