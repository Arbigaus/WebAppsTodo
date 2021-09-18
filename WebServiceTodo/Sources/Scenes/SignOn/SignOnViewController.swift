//
//  
//  SignOnViewController.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//
//

import Foundation
import UIKit
import Combine

final class SignOnViewController: UIViewController {
    // MARK: - Variables

    var viewModel: SignOnViewModel

    private var bindings = Set<AnyCancellable>()
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }
    var didSignOn: Bool = false {
        didSet { navigateToHome() }
    }

    // MARK: - View's

    private lazy var contentView = SignOnView()

    // MARK: - Initializers

    init(viewModel: SignOnViewModel = SignOnViewModel()) {
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
        view.backgroundColor = .white

        setUpBindings()
        setupViews()
    }

    private func setupViews() {
        contentView.signOnButton.addAction { [weak self] in
            self?.viewModel.signOn()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Setup Bindings

    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.nameTextField.textPublisher
                    .debounce(for: 0, scheduler: RunLoop.main)
                    .removeDuplicates()
                    .assign(to: \.name, on: viewModel)
                    .store(in: &bindings)

            contentView.emailTextField.textPublisher
                .debounce(for: 0, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.email, on: viewModel)
                .store(in: &bindings)

            contentView.passwordTextField.textPublisher
                .debounce(for: 0, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.password, on: viewModel)
                .store(in: &bindings)
        }

        func bindViewModelToView() {
            viewModel.$isLoading
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.isLoading = value
                }
                .store(in: &bindings)

            viewModel.$isValidPassword
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.contentView.signOnButton.isEnabled = value
                    self?.contentView.signOnButton.setTitleColor(value ? .systemBlue : .gray, for: .normal)
                }
                .store(in: &bindings)

            viewModel.$didSignOn
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.didSignOn = value
                }
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    // MARK: - Functions

    fileprivate func navigateToHome() {
        if didSignOn {
            navigationController?.pushViewController(HomeViewController(), animated: true)
        }
    }
}
