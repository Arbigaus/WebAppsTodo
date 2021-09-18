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
    var todoList: [TodoItem] = [] {
        didSet {
            list = [todoList, todoListDone]
        }
    }
    var todoListDone: [TodoItem] = [] {
        didSet {
            list = [todoList, todoListDone]
        }
    }
    var list: [[TodoItem]] = [] {
        didSet {
            contentView.tableView.reloadData()
        }
    }

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
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: true)

        viewModel.getUserData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        title = ""
    }

    // MARK: - setupViews

    private func setupViews() {
        let newItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.barButtonClickAction))
        navigationItem.rightBarButtonItem = newItemButton

        contentView.logoutButton.addAction { [weak self] in
            self?.viewModel.signOut()
        }
    }

    private func setupTableView() {
        contentView.tableView.register(TodoCell.self, forCellReuseIdentifier: "TodoCell")
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    // MARK: - Functions

    @objc func barButtonClickAction() {
        navigateToNewTodo()
    }

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
                    self?.title = value
                }
                .store(in: &bindings)

            viewModel.$todoList
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.todoList = value
                }
                .store(in: &bindings)

            viewModel.$todoListDone
                .receive(on: RunLoop.main)
                .sink { [weak self] value in
                    self?.todoListDone = value
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

    private func navigateToNewTodo() {
        navigationController?.pushViewController(NewTodoViewController(), animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentView.tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
                as? TodoCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(with: list[indexPath.section][indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "TODO" : "DONE"
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let trash = UIContextualAction(style: .destructive,
                                       title: "Apagar") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.viewModel.removeTodoItem(item: self.list[indexPath.section][indexPath.row])
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [trash])

        return configuration
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .destructive,
                                       title: "Done") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.viewModel.doneTodo(item: self.list[indexPath.section][indexPath.row])
            completionHandler(true)
        }
        done.backgroundColor = .systemGreen

        let configuration = UISwipeActionsConfiguration(actions: [done])

        return indexPath.section == 0 ? configuration : nil
    }
}
