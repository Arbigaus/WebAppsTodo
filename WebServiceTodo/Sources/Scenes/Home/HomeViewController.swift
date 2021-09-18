//
//  
//  HomeViewController.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//
//

import Foundation
import UIKit
import Combine

final class HomeViewController: UIViewController {
    // MARK: - Variables

    var viewModel: HomeViewModel

    private var bindings = Set<AnyCancellable>()
    var isLoading: Bool = false {
        didSet { isLoading ? startLoading() : finishLoading() }
    }
    var didSignOut: Bool = false {
        didSet {
            navigateToLogin()
        }
    }
    var todoList: [TodoList] = []

    // MARK: - View's

    private lazy var contentView = HomeView()

    // MARK: - Initializers

    init(viewModel: HomeViewModel = HomeViewModel()) {
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

        viewModel.getUserData()
    }

    private func setupViews() {
        navigationController?.navigationBar.isHidden = true

        contentView.tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    // MARK: - Functions

    // MARK: - Setup Bindings

    private func setUpBindings() {
        func bindViewToViewModel() {
        }

        func bindViewModelToView() {
            viewModel.$didSignOut
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { [weak self] value in
                        self?.didSignOut = value
                    })
                    .store(in: &bindings)

            viewModel.$isLoading
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { [weak self] value in
                        self?.isLoading = value
                    })
                    .store(in: &bindings)

            viewModel.$name
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.contentView.titleLabel.text = value
                }
                .store(in: &bindings)

            viewModel.$todoList
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.todoList = value
                    self?.contentView.tableView.reloadData()
                }
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    // MARK: - Navigation Functions

    private func navigateToLogin() {
        if didSignOut {
            navigationController?.pushViewController(LoginViewController(), animated: true)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
                as? TodoCell else {
            return UITableViewCell()
        }
        cell.configure(with: todoList[indexPath.row])

        return cell
    }
}
