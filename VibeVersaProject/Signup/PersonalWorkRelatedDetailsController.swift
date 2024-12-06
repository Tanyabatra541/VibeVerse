
import Foundation
import UIKit

class PersonalWorkRelatedDetailsController: UIViewController {

    private let titleLabel = Label(texttitle: "Personal Details", textcolor: .black, font: .systemFont(ofSize: 30, weight: .bold), numOflines: 1, textalignment: .left)
    private let subtitleLabel = Label(texttitle: "Provide your personal details to enhance your experience and connect with like-minded individuals.", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 0, textalignment: .left)
    
    private let workLinkLabel = Label(texttitle: "Work Link*", textcolor: .black, font: .systemFont(ofSize: 18, weight: .bold), numOflines: 0, textalignment: .left)
    private let workLinkTextView = TextViewWithPlaceholder(placeholder: "E.x.LinkedIn Profile: [Enter your LinkedIn profile URL]", backgroundColor: .darkBeige, cornerRadius: 10)
    
    private let descriptionLabel = Label(texttitle: "Description*", textcolor: .black, font: .systemFont(ofSize: 18, weight: .bold), numOflines: 0, textalignment: .left)
    private let wordCountLabel = Label(texttitle: "0/100 words", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 1, textalignment: .right)
    private let descriptionTextView = TextViewWithPlaceholder(placeholder: "Add something about yourself...", backgroundColor: .darkBeige, cornerRadius: 10)
    
    private let acheivementsLabel = Label(texttitle: "Achievements*", textcolor: .black, font: .systemFont(ofSize: 18, weight: .bold), numOflines: 0, textalignment: .left)
    private let achievementsTextView = TextViewWithPlaceholder(placeholder: "Add your achievements...", backgroundColor: .darkBeige, cornerRadius: 10)

    private let nextButton = ButtonWithLabel(title: "Next", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let backButton = ButtonWithImage(imageName: "back")

    var personalDetailsModel: SignupPersonalDetailsModel
    var dob: String?
    var interestsDetails: SignupInterestsDetailsModel
    
    init(signupPersonalDetails: SignupPersonalDetailsModel, signupInterestsDetails: SignupInterestsDetailsModel, dob: String) {
        self.personalDetailsModel = signupPersonalDetails
        self.dob = dob
        self.interestsDetails = signupInterestsDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupViews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(workLinkLabel)
        view.addSubview(workLinkTextView)
        view.addSubview(descriptionLabel)
        view.addSubview(wordCountLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(acheivementsLabel)
        view.addSubview(achievementsTextView)
        view.addSubview(nextButton)
        view.addSubview(backButton)
    
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),

            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.autoSized),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            workLinkLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            workLinkLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40.autoSized),

            // Work Link TextView
            workLinkTextView.topAnchor.constraint(equalTo: workLinkLabel.bottomAnchor, constant: 10.autoSized),
            workLinkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            workLinkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            workLinkTextView.heightAnchor.constraint(equalToConstant: 60.autoSized),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: workLinkTextView.bottomAnchor, constant: 20.autoSized),
            
            wordCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            wordCountLabel.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),

            // Description TextView
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10.autoSized),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100.autoSized),
            
            acheivementsLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            acheivementsLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20.autoSized),

            // Achievements TextView
            achievementsTextView.topAnchor.constraint(equalTo: acheivementsLabel.bottomAnchor, constant: 10.autoSized),
            achievementsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            achievementsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            achievementsTextView.heightAnchor.constraint(equalToConstant: 100.autoSized),

            // Next Button
            nextButton.topAnchor.constraint(equalTo: achievementsTextView.bottomAnchor, constant: 40.autoSized),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            nextButton.widthAnchor.constraint(equalToConstant: 100.widthRatio),
            nextButton.heightAnchor.constraint(equalToConstant: 50.autoSized),

            // Back Button
            backButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -16.widthRatio),
        ])
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func nextButtonTapped() {
        let data = SignupWorkDetailsModel(workLink: workLinkTextView.text ?? "", description: descriptionTextView.text ?? "", achievements: achievementsTextView.text ?? "")
        self.navigationController?.pushViewController(UploadProfilePictureController(signupPersonalDetails: personalDetailsModel, signupInterestsDetails: interestsDetails, dob: dob ?? "", signupWorkDetails: data), animated: true)
    }
}

