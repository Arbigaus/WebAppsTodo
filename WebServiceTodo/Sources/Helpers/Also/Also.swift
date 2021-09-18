//
//  Also.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import Foundation

infix operator <-< : AssignmentPrecedence

@discardableResult
public func <-< <T: AnyObject>(left: T, right: (T) -> Void) -> T {
    right(left)
    return left
}

