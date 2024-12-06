
import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UploadProfilePictureController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let titleLabel = Label(texttitle: "Upload Your Picture", textcolor: .black, font: .boldSystemFont(ofSize: 30), numOflines: 1, textalignment: .left)
    private let subtitleLabel = Label(texttitle: "Tap to upload a picture for your profile.", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 0, textalignment: .left)

    private let uploadView = View(backgroundcolor: .darkBeige, cornerradius: 10)
    private let uploadIcon = ImageView(imagetitle: "upload")
    private let uploadLabel = Label(texttitle: "Upload Picture", textcolor: .black, font: .systemFont(ofSize: 15), numOflines: 1, textalignment: .center)


    private let nextButton = ButtonWithLabel(title: "Next", backgroundColor: .brown, titlecolor: .white, cornerRadius: 10)
    private let backButton = ButtonWithImage(imageName: "back")

    private let actionSheet = UIAlertController(title: "Select Source", message: nil, preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupViews()
    }
    
    var personalDetailsModel: SignupPersonalDetailsModel?
    var dob: String?
    var interestsDetails: SignupInterestsDetailsModel?
    var workRelatedDetails: SignupWorkDetailsModel?
    var signupModel: SignupAllDetailsModel?
    var selectedImage: UIImage?
    
    init(signupPersonalDetails: SignupPersonalDetailsModel, signupInterestsDetails: SignupInterestsDetailsModel, dob: String, signupWorkDetails: SignupWorkDetailsModel) {
        self.personalDetailsModel = signupPersonalDetails
        self.dob = dob
        self.interestsDetails = signupInterestsDetails
        self.workRelatedDetails = signupWorkDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(uploadView)
        uploadView.addSubview(uploadIcon)
        uploadView.addSubview(uploadLabel)
        view.addSubview(nextButton)
        view.addSubview(backButton)

        uploadView.isUserInteractionEnabled = true
        uploadView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTapped)))

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

            // Upload View
            uploadView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60.autoSized),
            uploadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadView.widthAnchor.constraint(equalToConstant: 300.autoSized),
            uploadView.heightAnchor.constraint(equalToConstant: 300.autoSized),
                        
            uploadIcon.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor),
            uploadIcon.topAnchor.constraint(equalTo: uploadView.topAnchor, constant: 80.autoSized),
            uploadIcon.widthAnchor.constraint(equalToConstant: 80.autoSized),
            uploadIcon.heightAnchor.constraint(equalToConstant: 80.autoSized),

            // Upload Label
            uploadLabel.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor),
            uploadLabel.topAnchor.constraint(equalTo: uploadIcon.bottomAnchor, constant: 20.autoSized),

            nextButton.topAnchor.constraint(equalTo: uploadView.bottomAnchor, constant: 40.autoSized),
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
        guard let personalDetails = personalDetailsModel,
              let dob = dob,
              let interestsDetails = interestsDetails,
              let workDetails = workRelatedDetails,
              let selectedImage = selectedImage else {
            print("Missing data")
            return
        }

        // Create the signup model
        let signupModel = SignupAllDetailsModel(
            personalDetails: personalDetails,
            dob: dob,
            interestsDetails: interestsDetails,
            workDetails: workDetails,
            profileImage: selectedImage
        )
        // Call the signup function
        signUp(with: signupModel)
    }

    @objc func handleViewTapped() {
        actionSheet.overrideUserInterfaceStyle = .light

        let openCamera = UIAlertAction(title: "Open Camera", style: .default) { (action) in
            self.showImagePicker(selectedSource: .camera)
        }
        let openLibrary = UIAlertAction(title: "Open Photos", style: .default) { (action) in
            self.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        actionSheet.addAction(openCamera)
        actionSheet.addAction(openLibrary)
        actionSheet.addAction(cancel)

        self.present(actionSheet, animated: true)
    }

    private func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(selectedSource) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = selectedSource
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = pickedImage
            uploadIcon.image = pickedImage
            uploadLabel.alpha = 0.0
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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

// Firebase auth and storage
extension UploadProfilePictureController {
    
    func signUp(with model: SignupAllDetailsModel) {
            self.showLoader()
            
            // First, sign up the user using Firebase Authentication
            Auth.auth().createUser(withEmail: model.personalDetails.email, password: model.personalDetails.password) { authResult, error in
                if let error = error {
                    print("Error signing up user: \(error.localizedDescription)")
                    self.showAlert(message: "Error signing up user: \(error.localizedDescription)")
                    self.hideLoader()
                    return
                }
                
                // Ensure we have a user ID
                guard let userId = authResult?.user.uid else {
                    print("Unable to retrieve user ID")
                    self.showAlert(message: "Unable to retrieve user ID")
                    self.hideLoader()
                    return
                }
                
                // Check if model.profileImage exists
                if model.profileImage == nil {
                    print("No profile image selected")
                    self.showAlert(message: "No profile image selected")
                    self.hideLoader()
                    return
                }
                
                // Convert the image to data
                guard let imageData = model.profileImage.jpegData(compressionQuality: 0.8) else {
                    print("Error converting image to data")
                    self.showAlert(message: "Error converting image to data")
                    self.hideLoader()
                    return
                }
                
                // Upload image to Firebase Storage
                let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
                storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image to Firebase Storage: \(error.localizedDescription)")
                        self.showAlert(message: "Error uploading image to Firebase Storage")
                        self.hideLoader()
                        return
                    }
                    
                    // Get image URL after successful upload
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting image download URL: \(error.localizedDescription)")
                            self.showAlert(message: "Error getting image download URL")
                            self.hideLoader()
                            return
                        }
                        
                        guard let imageUrl = url?.absoluteString else {
                            print("Error getting image URL")
                            self.showAlert(message: "Error getting image URL")
                            self.hideLoader()
                            return
                        }
                        
                        // Prepare data for Firestore
                        let signupData: [String: Any] = [
                            "userId": userId,
                            "personalDetails": [
                                "firstName": model.personalDetails.firstName,
                                "lastName": model.personalDetails.lastName,
                                "phone": model.personalDetails.phone,
                                "email": model.personalDetails.email
                            ],
                            "dob": model.dob,
                            "interestsDetails": [
                                "interests": model.interestsDetails.interests,
                                "goodAtThings": model.interestsDetails.goodAtThings,
                                "experience": model.interestsDetails.experience
                            ],
                            "workDetails": [
                                "workLink": model.workDetails.workLink,
                                "description": model.workDetails.description,
                                "achievements": model.workDetails.achievements
                            ],
                            "profileImageUrl": imageUrl
                        ]
                        
                        // Save to Firestore
                        let db = Firestore.firestore()
                        db.collection("users").document(userId).setData(signupData) { error in
                            self.hideLoader()
                            if let error = error {
                                print("Error saving user data to Firestore: \(error.localizedDescription)")
                                self.showAlert(message: "Error saving user data to Firestore")
                            } else {
                                print("User data successfully saved!")
                                DispatchQueue.main.async {
                                    self.navigateToHomeScreen()
                                }
                            }
                        }
                    }
                }
            }
        }
   
}

