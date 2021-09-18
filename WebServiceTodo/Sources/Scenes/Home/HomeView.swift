//
//  
//  HomeView.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//
//

import UIKit

final class HomeView: UIView {
    // MARK: - View's

    lazy var tableView = UITableView() <-< {
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }

    lazy var logoutButton = UIButton() <-< {
        $0.setTitle("Sair", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
    }

    // MARK: - Variables
    // TODO: Insert Variables here

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        backgroundColor = .white
        addSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func addSubviews() {
        addSubview(logoutButton) { make in
            make.bottom.equalToSuperview().inset(32)
            make.width.equalTo(200)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        addSubview(tableView) { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(logoutButton.snp.top).offset(-32)
        }

    }
}

// MARK: - TODO Cell
extension HomeViewController {
    final class TodoCell: UITableViewCell {
        lazy var titleLabel = UILabel() <-< {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        }

        lazy var descriptionLabel = UILabel() <-< {
            $0.textColor = .black
            $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }

        public func configure(with item: TodoItem) {
            titleLabel.text = item.title
            descriptionLabel.text = item.description

            configureView()
        }

        private func configureView() {
            contentView.addSubview(titleLabel) { make in
                make.top.equalToSuperview().inset(16)
                make.leading.trailing.equalToSuperview()
            }
            contentView.addSubview(descriptionLabel) { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().inset(16)
            }
        }
    }
}
