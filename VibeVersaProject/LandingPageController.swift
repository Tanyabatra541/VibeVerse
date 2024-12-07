
import UIKit

class LandingPageController: UIViewController {

    private let logoImageView = ImageView(imagetitle: "logo", imagecolor: .clear)
    private let titleLabel = ImageView(imagetitle: "logoLabel", imagecolor: .clear)
    private let subtitleLabel = Label(
        texttitle: "Unlock a world of limitless skills and knowledge with our skill sharing app!",
        textcolor: .black,
        font: .boldSystemFont(ofSize: 15),
        numOflines: 0,
        textalignment: .center
    )
    private let joinButton = ButtonWithLabel(title: "Join Now", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let loginLabel = Label(texttitle: "Already have an account?", textcolor: .brown, font: .systemFont(ofSize: 16), numOflines: 1, textalignment: .center)
    private let loginButtonLabel = Label(texttitle: "Login", textcolor: .black, font: .systemFont(ofSize: 16), numOflines: 0, textalignment: .left)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupViews()
        joinButton.addTarget(self, action: #selector(joinNowTapped), for: .touchUpInside)
        loginButtonLabel.isUserInteractionEnabled = true
        loginButtonLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLoginTapped)))
    }

    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(joinButton)
        view.addSubview(loginLabel)
        view.addSubview(loginButtonLabel)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140.autoSized),
            logoImageView.heightAnchor.constraint(equalToConstant: 109.autoSized),
            logoImageView.widthAnchor.constraint(equalToConstant: 104.autoSized),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.autoSized),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 200.autoSized),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.widthRatio),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.widthRatio),

            joinButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40.autoSized),
            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            joinButton.heightAnchor.constraint(equalToConstant: 50.autoSized),

            loginLabel.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 20.autoSized),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20.widthRatio),
            
            loginButtonLabel.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor, constant: 2.widthRatio),
            loginButtonLabel.topAnchor.constraint(equalTo: loginLabel.topAnchor),
        ])
    }
    
    @objc func joinNowTapped() {
        self.navigationController?.pushViewController(CreateAccountController(), animated: true)
    }
    @objc func handleLoginTapped() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}


