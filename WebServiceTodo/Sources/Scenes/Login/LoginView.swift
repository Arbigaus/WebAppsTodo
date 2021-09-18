//
//  LoginView.swift
//  WebServiceTodo
//
//  Created by Gerson Arbigaus on 11/09/21.
//

import UIKit

final class LoginView: UIView {
    // MARK: - View's

    lazy var titleLabel = UILabel() <-< {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Bem Vindo"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
    lazy var emailTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "E-mail"
        $0.keyboardType = .emailAddress
    }
    lazy var passwordTextField = UITextField() <-< {
        $0.borderStyle = .roundedRect
        $0.placeholder = "Senha"
        $0.isSecureTextEntry = true
    }
    lazy var loginButton = UIButton() <-< {
        $0.setTitle("Entrar", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    lazy var signInButton = UIButton() <-< {
        $0.setTitle("Cadastrar", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
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

        addSubview(emailTextField) { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        addSubview(passwordTextField) { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        addSubview(loginButton) { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }

        addSubview(signInButton) { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(48)
        }
    }
}
