//
//  QuizQuestion.swift
//  appnavigation
//
//  Created by MACM72 on 25/02/26.
//

import Foundation

struct QuizQuestion {
    let questionText: String
    let options: [String]
    let isMultipleChoice: Bool // The key to check in didSelectRowAt
}
