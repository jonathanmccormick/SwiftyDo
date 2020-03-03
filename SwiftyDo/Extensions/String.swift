//
//  String.swift
//  SwiftyDo
//
//  Created by Jonathan McCormick on 3/2/20.
//  Copyright © 2020 Jonathan McCormick. All rights reserved.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
}
