//
//  UIControlExtension.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//

import UIKit

@objc public final class ClosureSleeve: NSObject {
    let closure: () -> Void
    public init (_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    /// Associates an action method with the control.
    ///
    /// Here is an example of a usage:
    /// ```
    ///     let button = UIButton()
    ///     button.addAction(for: .touchUpInside) { [weak self] in
    ///         self?.doStuff()
    ///     }
    /// ```
    ///
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, UUID().uuidString, sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }

}
