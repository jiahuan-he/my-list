//
//  TodoModel.swift
//  Draft11
//
//  Created by LMAO on 11/03/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import Foundation

enum Flags{
    case RED
    case BLUE
    case YELLOW
    case GREEN
}

class TodoModel{
    var content: String?
    var flag: Flags?
    var date: NSDate?
    var completed: Bool = false
    var deleted: Bool = false
    init(content: String) {
        self.content = content
    }
}
