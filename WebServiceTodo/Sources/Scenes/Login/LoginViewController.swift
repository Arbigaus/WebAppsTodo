//
//  LoginViewController.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import Foundation
import UIKit
import Combine

final class LoginViewController: UIViewController {
    // MARK: - Variables

    var viewModel: LoginViewModel

    private var bindings = Set<AnyCancellable>()
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }
    var didLogin: Bool = false {
        didSet { navigateToHome() }
    }

    // MARK: - View's

    private lazy var contentView = LoginView()

    // MARK: - Initializers

    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    // MARK: - Loads

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
        setupViews()
    }

    private func setupViews() {
        contentView.signInButton.addAction { [weak self] in
            print("SignOn")
            self?.navigationController?.pushViewController(SignOnViewController(), animated: true)
        }

        contentView.loginButton.addAction { [weak self] in
            self?.viewModel.signIn()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true

    }

    // MARK: - Setup Bindings

    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.emailTextField.textPublisher
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.email, on: viewModel)
                .store(in: &bindings)

            contentView.passwordTextField.textPublisher
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)
        }

        func bindViewModelToView() {
            viewModel.$didLogin
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] value in
                    self?.didLogin = value
                })
                .store(in: &bindings)

            viewModel.$isLoading
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] value in
                    self?.isLoading = value
                })
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    // MARK: - Functions

    fileprivate func navigateToHome() {
        if didLogin {
            navigationController?.pushViewController(HomeViewController(), animated: true)
        }
    }
}
