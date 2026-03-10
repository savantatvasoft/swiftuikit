//
//  PollViewModel.swift
//  appnavigation
//
//  Created by MACM72 on 25/02/26.
//

import Foundation


struct SubmitPollJSON {
    var questionText: String
    var optionText: [String]
}

class PollViewModel {

    private var questions: [QuizQuestion] = []

    func fetchQuestions(completion: @escaping () -> Void) {

        DispatchQueue.global().asyncAfter(deadline: .now() + 220.0) {
            self.questions = [
                QuizQuestion(questionText: "Which languages are used for iOS?", options: ["Swift", "Kotlin", "Objective-C", "Python"], isMultipleChoice: true),
                QuizQuestion(questionText: "What is the capital of France?", options: ["Berlin", "Madrid", "Paris", "Rome"], isMultipleChoice: false),
                QuizQuestion(questionText: "Select mobile operating systems:", options: ["iOS", "Windows", "Android", "macOS"], isMultipleChoice: true),
                QuizQuestion(questionText: "Which company made the iPhone?", options: ["Google", "Apple", "Microsoft", "Amazon"], isMultipleChoice: false),
                QuizQuestion(questionText: "Identify primary colors:", options: ["Red", "Yellow", "Green", "Blue"], isMultipleChoice: true)
            ]

            DispatchQueue.main.async {
                completion()
            }
        }
    }


    var totalQuestions: Int {
        return questions.count
    }

    var currentQuestionIndex = 0
    var selectedIndices = Set<Int>()

    var currentQuestion: QuizQuestion {
        return questions[currentQuestionIndex]
    }

    var questionProgressText: String {
        return "Question \(currentQuestionIndex + 1) of \(questions.count)"
    }

    var isNextButtonEnabled: Bool {
        return !selectedIndices.isEmpty
    }


    func handleSelection(at index: Int) {
        if currentQuestion.isMultipleChoice {
            if selectedIndices.contains(index) {
                selectedIndices.remove(index)
            } else {
                selectedIndices.insert(index)
            }
        } else {
            selectedIndices.removeAll()
            selectedIndices.insert(index)
        }
    }

    func moveToNextQuestion() -> Bool {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedIndices.removeAll()
            return true
        }
        return false
    }

    func moveToPreviousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
}
