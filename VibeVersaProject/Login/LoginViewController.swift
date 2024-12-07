import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let backButton = ButtonWithImage(imageName: "back")
    private let titleLabel = Label(texttitle: "Hi, Welcome Back! 👋", textcolor: .black, font: .boldSystemFont(ofSize: 28), numOflines: 1, textalignment: .left)
    private let subtitleLabel = Label(texttitle: "Hello again, you have been missed!", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 0, textalignment: .left)

    private let emailLabel = Label(texttitle: "Email", textcolor: .black, font: .boldSystemFont(ofSize: 16), numOflines: 1, textalignment: .left)
    private let emailTextField: TextField = {
        let textField = TextField(textTitle: "Email Address", backgroundcolor: .clear)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let passwordLabel = Label(texttitle: "Password", textcolor: .black, font: .boldSystemFont(ofSize: 16), numOflines: 1, textalignment: .left)
    private let passwordTextField: TextField = {
        let textField = TextField(textTitle: "Password", backgroundcolor: .clear)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton = ButtonWithLabel(title: "LOGIN", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupViews()
        setupPasswordField()
        enableDisableButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Back Button
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.autoSized),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.widthRatio),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),

            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.autoSized),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),

            // Email Label
            emailLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 80.autoSized),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),

            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10.autoSized),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25.widthRatio),
            emailTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),

            // Password Label
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20.autoSized),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),

            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10.autoSized),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25.widthRatio),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),

            // Login Button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40.autoSized),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25.widthRatio),
            loginButton.heightAnchor.constraint(equalToConstant: 50.autoSized),

            // Content View Bottom Anchor
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40.autoSized)
        ])
    }

    private func setupPasswordField() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    func enableDisableButton() {
        if emailTextField.text!.count < 5 || passwordTextField.text!.count < 4  {
            loginButton.alpha = 0.3
            loginButton.isUserInteractionEnabled = false
        } else {
            loginButton.alpha = 1.0
            loginButton.isUserInteractionEnabled = true
        }
    }

    @objc func editingDidChangedForTextField(textField: UITextField) {
        enableDisableButton()
    }

    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeIcon = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: eyeIcon), for: .normal)
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func loginButtonTapped() {
        view.endEditing(true)
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter both email and password.")
            return
        }

        loginUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("Successfully logged in as user: \(user.email ?? "No email")")
                DispatchQueue.main.async {
                    self.navigateToHomeScreen()
                }
            case .failure(let error):
                print("Login failed with error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.showLoader()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.hideLoader()
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let user = authResult?.user {
                completion(.success(user))
            } else {
                let unexpectedError = NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected error occurred during login."])
                completion(.failure(unexpectedError))
            }
        }
    }

    func navigateToHomeScreen() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

