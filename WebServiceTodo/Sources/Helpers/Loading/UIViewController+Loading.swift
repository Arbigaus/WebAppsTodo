//
//  UIViewController+Loading.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import UIKit

extension UIViewController {
    func startLoading() {
        let child = SpinnerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

    }

    func finishLoading() {
        children.forEach { child in
            guard let child = child as? SpinnerViewController else { return }
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
