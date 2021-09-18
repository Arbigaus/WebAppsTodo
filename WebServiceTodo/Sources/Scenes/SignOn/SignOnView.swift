//
//  
//  SignOnView.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 14/09/21.
//
//

import UIKit

final class SignOnView: UIView {
    // MARK: - View's

    lazy var titleLabel = UILabel() <-< {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Cadastrar"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
    lazy var nameTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Nome"
    }
    lazy var emailTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "E-mail"
    }
    lazy var passwordTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Senha"
        $0.isSecureTextEntry = true
    }

    lazy var signOnButton = UIButton() <-< {
        $0.setTitle("Cadastrar", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
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

        addSubview(nameTextField) { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        addSubview(emailTextField) { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        addSubview(passwordTextField) { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        addSubview(signOnButton) { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
