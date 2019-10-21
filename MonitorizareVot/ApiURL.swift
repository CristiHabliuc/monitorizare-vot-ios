//
//  ApiURL.swift
//  MonitorizareVot
//
//  Created by Cristi Habliuc on 17/10/2019.
//  Copyright © 2019 Code4Ro. All rights reserved.
//

import UIKit

enum ApiURL {
    case login
    case pollingStationList
    case formSets
    case formsInSet(setId: Int)
    case uploadNote
    case uploadAnswer

    func url() -> URL {
        var uri = ""
        switch self {
        case .login: uri = "/v1/access/authorize"
        case .pollingStationList: uri = "/v1/polling-station"
        case .formSets: uri = "/v1/form"
        case .formsInSet(let setId): uri = "/v1/form/\(setId)"
        case .uploadNote: uri = "/v2/note/upload"
        case .uploadAnswer: uri = "/v1/answers"
        }
        return fullURL(withURI: uri)
    }
    
    private func fullURL(withURI uri: String) -> URL {
        guard let info = Bundle.main.infoDictionary,
            let urlString = info["API_URL"] as? String else {
            fatalError("No API_URL found")
        }
        guard let url = URL(string: urlString + uri) else {
            fatalError("Invalid url for provided uri: \(uri)")
        }
        return url
    }
}

