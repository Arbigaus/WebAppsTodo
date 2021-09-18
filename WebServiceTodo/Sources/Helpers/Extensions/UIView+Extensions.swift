//
//  UIView+Extensions.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import UIKit
import SnapKit

public extension UIView {

    /**

     Syntax sugar to add a view with constraints in same line

     Every time that we add a new subview and want to
     add constraint's to them, you need to do:

     ```
     anyview.addSubview(subview)
     subview.snp.makeConstraints { make in }
     ```

     With this new method we can do simple

     ```
     anyview.addSubview(subview) { make in }
     ```

     - Parameters:
     - view: view to be added a subview
     - closure: SnapKit Closure from `makeConstraints`

     */
    func addSubview(
        _ view: UIView,
        closure: (ConstraintMaker) -> Void
    ) {
        self.addSubview(view)
        view.snp.makeConstraints(closure)
    }

}
