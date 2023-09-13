//
//  Story.swift
//  Choices
//
//  Created by MertcanAkyürek on 27.07.2023.
//

import Foundation

struct Story: Codable {
    let ID: Int
    let detail: String
    let options: [Option]
    var selectedIndex = -1
    
    var hasOption: Bool {
        return options.count != 0
    }
    
    var hasSelected: Bool {
        return selectedIndex != -1
    }
    
    enum CodingKeys: String, CodingKey {
        case ID, detail, options
    }
}
