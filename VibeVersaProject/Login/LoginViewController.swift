
import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    private let backButton = ButtonWithImage(imageName: "back")
    private let titleLabel = Label(texttitle: "Hi, Welcome Back! 👋", textcolor: .black, font: .boldSystemFont(ofSize: 28), numOflines: 1, textalignment: .left)
    private let subtitleLabel = Label(texttitle: "Hello again, you have been missed!", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 0, textalignment: .left)

    private let emailLabel = Label(texttitle: "Email", textcolor: .black, font: .boldSystemFont(ofSize: 16), numOflines: 1, textalignment: .left)
    private let emailTextField = TextField(textTitle: "Email Address", backgroundcolor: .clear)

    private let passwordLabel = Label(texttitle: "Password", textcolor: .black, font: .boldSystemFont(ofSize: 16), numOflines: 1, textalignment: .left)
    private let passwordTextField = TextField(textTitle: "Password", backgroundcolor: .clear)

    private let loginButton = ButtonWithLabel(title: "LOGIN", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
//    var personalDetailsModel: SignupPersonalDetailsModel?
//    var dob: String?
//    var interestsDetails: SignupInterestsDetailsModel?
//    var workRelatedDetails: SignupWorkDetailsModel?
//    var profileImage: UIImage?
//
//    init(signupPersonalDetails: SignupPersonalDetailsModel, signupInterestsDetails: SignupInterestsDetailsModel, dob: String, signupWorkDetails: SignupWorkDetailsModel, profileImage: UIImage) {
//        self.personalDetailsModel = signupPersonalDetails
//        self.dob = dob
//        self.interestsDetails = signupInterestsDetails
//        self.workRelatedDetails = signupWorkDetails
//        self.profileImage = profileImage
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        setupViews()
        enableDisableButton()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupViews() {
        // Add subviews
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)

        NSLayoutConstraint.activate([

            // Back Button
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.autoSized),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),

            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.autoSized),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),

            // Email Label
            emailLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 80.autoSized),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),

            // Email TextField
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10.autoSized),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            emailTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),

            // Password Label
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20.autoSized),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),

            // Password TextField
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10.autoSized),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),

            // Login Button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40.autoSized),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            loginButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
        ])
    }
    private func setupPasswordField() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
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
//        self.navigateToHomeScreen()
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
                // Return the error through the completion handler
                completion(.failure(error))
                return
            }
            
            if let user = authResult?.user {
                // Return the Firebase user object
                completion(.success(user))
            } else {
                // Handle an unexpected case where the user object is nil
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
