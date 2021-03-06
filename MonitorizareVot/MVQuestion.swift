//  Created by Code4Romania

import Foundation

enum QuestionType {
    case MultipleAnswer
    case SingleAnswer
    case SingleAnswerWithText
    case MultipleAnswerWithText

    init(dbValue: Int) {
        switch dbValue {
        case 0: self = .MultipleAnswer
        case 1: self = .SingleAnswer
        case 2: self = .SingleAnswerWithText
        case 3: self = .MultipleAnswerWithText
        default: self = .SingleAnswer
        }
    }
    
    func raw()-> Int {
        switch self {
        case .MultipleAnswer:
            return 0
        case .SingleAnswer:
            return 1
        case .SingleAnswerWithText:
            return 2
        case .MultipleAnswerWithText:
            return 3
        }
    }
}

struct MVQuestion {
    var form: String
    var id: Int16
    var text: String
    var type: QuestionType
    var answered: Bool
    var answers: [MVAnswer]
    var synced: Bool
    var sectionInfo: MVSectionInfo? = nil
    var note: MVNote?
}

