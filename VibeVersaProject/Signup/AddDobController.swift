
import Foundation
import UIKit

class AddDobController: UIViewController {

    private let titleLabel = Label(texttitle: "Date of Birth", textcolor: .black, font: .boldSystemFont(ofSize: 30), numOflines: 1, textalignment: .left)
    private let subtitleLabel = Label(texttitle: "Enter your date of birth for better skill matching and personalized recommendations.", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 0, textalignment: .left)
    
    private let datePickerView = View(backgroundcolor: .darkBeige, cornerradius: 20.autoSized)
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.overrideUserInterfaceStyle = .light
        picker.tintColor = .black
        picker.backgroundColor = .darkBeige
        picker.layer.cornerRadius = 40.autoSized
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let nextButton = ButtonWithLabel(title: "Next", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let backButton = ButtonWithImage(imageName: "back")
    var personalDetailsModel: SignupPersonalDetailsModel
    
    init(signupPersonalDetails: SignupPersonalDetailsModel) {
        self.personalDetailsModel = signupPersonalDetails
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
        view.addSubview(datePickerView)
        datePickerView.addSubview(datePicker)
        view.addSubview(nextButton)
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.autoSized),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            datePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            datePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            datePickerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60.autoSized),
            
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor, constant: 10.autoSized),
            datePicker.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: -10.autoSized),
            datePicker.centerXAnchor.constraint(equalTo: datePickerView.centerXAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            nextButton.topAnchor.constraint(equalTo: datePickerView.bottomAnchor, constant: 40.autoSized),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            nextButton.widthAnchor.constraint(equalToConstant: 100.widthRatio),
            nextButton.heightAnchor.constraint(equalToConstant: 50.autoSized),
            
            backButton.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            backButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -16.widthRatio),
        ])
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datePicker.date)
        self.navigationController?.pushViewController(InterestsSelectionController(signupPersonalDetails: personalDetailsModel, dob: dateString), animated: true)
    }
}
