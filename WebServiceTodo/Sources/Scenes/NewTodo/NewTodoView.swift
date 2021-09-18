//
//  
//  NewTodoView.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 18/09/21.
//
//

import UIKit

final class NewTodoView: UIView {
    // MARK: - View's

    lazy var titleLabel = UILabel() <-< {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Novo Lembrete"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
    lazy var titleTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Título"
    }
    lazy var descriptionTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Descrição"
    }
    lazy var saveButton = UIButton() <-< {
        $0.setTitle("Salvar", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }

    // MARK: - Variables


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
            make.top.equalToSuperview().offset(250)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        addSubview(titleTextField) { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        addSubview(descriptionTextField) { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        addSubview(saveButton) { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
    }
}
