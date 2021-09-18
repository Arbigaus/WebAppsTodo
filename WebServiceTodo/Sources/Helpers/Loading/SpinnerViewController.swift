//
//  SpinnerViewController.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import Foundation
import UIKit

final class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large) <-< {
        $0.color = .white
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)

        spinner.startAnimating()

        view.addSubview(spinner) { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(150)
        }

    }
}
