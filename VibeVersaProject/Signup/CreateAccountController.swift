import Foundation
import UIKit

class CreateAccountController: UIViewController, UITextFieldDelegate {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let backButton = ButtonWithImage(imageName: "back")
    private let titleLabel = Label(texttitle: "Create account", textcolor: .black, font: .boldSystemFont(ofSize: 30), numOflines: 1, textalignment: .left)
    private let subtitleLabel = Label(texttitle: "Create an account and enjoy a world of learning and connections.", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 0, textalignment: .left)

    private let firstNameField: TextField = {
        let textField = TextField(textTitle: "First Name", backgroundcolor: .clear)
        textField.autocapitalizationType = .none
        return textField
    }()
    private let lastNameField: TextField = {
        let textField = TextField(textTitle: "Last Name", backgroundcolor: .clear)
        textField.autocapitalizationType = .none
        return textField
    }()
    private let phoneField: TextField = {
        let textField = TextField(textTitle: "Phone", backgroundcolor: .clear)
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        return textField
    }()
    private let emailField: TextField = {
        let textField = TextField(textTitle: "Email", backgroundcolor: .clear)
        textField.autocapitalizationType = .none
        return textField
    }()
    private let passwordField: TextField = {
        let textField = TextField(textTitle: "Password", backgroundcolor: .clear)
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        return textField
    }()
    private let eyeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    private let continueButton = ButtonWithLabel(title: "Continue", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let loginLabel = Label(texttitle: "Already have an account?", textcolor: .brown, font: .systemFont(ofSize: 16), numOflines: 1, textalignment: .center)
    private let loginButtonLabel = Label(texttitle: "Login", textcolor: .black, font: .systemFont(ofSize: 16), numOflines: 0, textalignment: .left)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupScrollView()
        setupViews()
        setupPasswordField()
        enableDisableButton()

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        loginButtonLabel.isUserInteractionEnabled = true
        loginButtonLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLoginTapped)))

        firstNameField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        emailField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(editingDidChangedForTextField(textField:)), for: .editingChanged)

        phoneField.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupViews() {
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(firstNameField)
        contentView.addSubview(lastNameField)
        contentView.addSubview(phoneField)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(continueButton)
        contentView.addSubview(loginLabel)
        contentView.addSubview(loginButtonLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.autoSized),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.widthRatio),

            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.autoSized),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25.widthRatio),

            firstNameField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20.autoSized),
            firstNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            firstNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25.widthRatio),
            firstNameField.heightAnchor.constraint(equalToConstant: 50.autoSized),

            lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 20.autoSized),
            lastNameField.leadingAnchor.constraint(equalTo: firstNameField.leadingAnchor),
            lastNameField.trailingAnchor.constraint(equalTo: firstNameField.trailingAnchor),
            lastNameField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),

            phoneField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 20.autoSized),
            phoneField.leadingAnchor.constraint(equalTo: firstNameField.leadingAnchor),
            phoneField.trailingAnchor.constraint(equalTo: firstNameField.trailingAnchor),
            phoneField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),

            emailField.topAnchor.constraint(equalTo: phoneField.bottomAnchor, constant: 20.autoSized),
            emailField.leadingAnchor.constraint(equalTo: firstNameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: firstNameField.trailingAnchor),
            emailField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20.autoSized),
            passwordField.leadingAnchor.constraint(equalTo: firstNameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: firstNameField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalTo: firstNameField.heightAnchor),

            continueButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40.autoSized),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40.widthRatio),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40.widthRatio),
            continueButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            
            loginLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 20.autoSized),
            loginLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20.widthRatio),
            
            loginButtonLabel.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor),
            loginButtonLabel.topAnchor.constraint(equalTo: loginLabel.topAnchor),

            loginButtonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.autoSized)
        ])
    }

    private func setupPasswordField() {
        passwordField.rightView = eyeButton
        passwordField.rightViewMode = .always

        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    @objc func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let eyeIcon = passwordField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: eyeIcon), for: .normal)
    }

    func enableDisableButton() {
        if firstNameField.text!.count < 2 || phoneField.text!.count < 4 || emailField.text!.count < 6 || passwordField.text!.count < 3 {
            continueButton.alpha = 0.3
            continueButton.isUserInteractionEnabled = false
        } else {
            continueButton.alpha = 1.0
            continueButton.isUserInteractionEnabled = true
        }
    }

    @objc func editingDidChangedForTextField(textField: UITextField) {
        enableDisableButton()
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func continueButtonTapped() {
        let data = SignupPersonalDetailsModel(firstName: firstNameField.text ?? "", lastName: lastNameField.text ?? "", phone: phoneField.text ?? "", email: emailField.text ?? "", password: passwordField.text ?? "")
        self.navigationController?.pushViewController(AddDobController(signupPersonalDetails: data), animated: true)
    }

    @objc func handleLoginTapped() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }

    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
