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

    lazy var titleLabel = UILabel() <-< {
        $0.textAlignment = .center
        $0.textColor = .black
    }

    lazy var tableView = UITableView() <-< {
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
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
        addSubview(titleLabel) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        addSubview(tableView) { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
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

        public func configure(with item: TodoList) {
            titleLabel.text = item.title
            descriptionLabel.text = item.description

            configureView()
        }

        private func configureView() {
            contentView.addSubview(titleLabel) { make in
                make.top.leading.trailing.equalToSuperview().inset(16)
            }
            contentView.addSubview(descriptionLabel) { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalToSuperview().inset(16)
            }
        }
    }
}
