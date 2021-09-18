//
//  
//  NewTodoViewController.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 18/09/21.
//
//

import Foundation
import UIKit
import Combine

final class NewTodoViewController: UIViewController {
    // MARK: - Variables

    var viewModel: NewTodoViewModel

    private var bindings = Set<AnyCancellable>()
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }
    var didCreateTodo = false {
        didSet {
            backToHome()
        }
    }

    // MARK: - View's

    private lazy var contentView = NewTodoView()

    // MARK: - Initializers

    init(viewModel: NewTodoViewModel = NewTodoViewModel()) {
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
        contentView.saveButton.addAction { [weak self] in
            self?.viewModel.createNewTodo()
        }
    }

    // MARK: - Setup Bindings

    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.titleTextField.textPublisher
                .debounce(for: 0, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.todoTitle, on: viewModel)
                .store(in: &bindings)

            contentView.descriptionTextField.textPublisher
                .debounce(for: 0, scheduler: RunLoop.main)
                .removeDuplicates()
                .assign(to: \.todoDescription, on: viewModel)
                .store(in: &bindings)
        }

        func bindViewModelToView() {
            viewModel.$isLoading
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { [weak self] value in
                        self?.isLoading = value
                    })
                    .store(in: &bindings)

            viewModel.$didCreateTodo
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.didCreateTodo = value
                }
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    // MARK: - Navigations

    fileprivate func backToHome() {
        if didCreateTodo {
            navigationController?.popViewController(animated: true)
        }
    }
}
