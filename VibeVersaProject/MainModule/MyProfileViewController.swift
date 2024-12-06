
import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyProfileViewController: BaseViewController {
    
    private let profileImageView = ImageView(imagetitle: "logo", imagecolor: .blue)
    private let nameLabel = Label(texttitle: "Name", textcolor: .black, font: .systemFont(ofSize: 26), numOflines: 0, textalignment: .center)
    private let updateButton = ButtonWithLabel(title: "My Communities", font: .systemFont(ofSize: 14), backgroundColor: .yellow, titlecolor: .black, cornerRadius: 10)
    private let logoutButton = ButtonWithLabel(title: "Logout", font: .systemFont(ofSize: 14), backgroundColor: .yellow, titlecolor: .black, cornerRadius: 10)
    
    private let aboutLabel = Label(texttitle: "About", textcolor: .black, font: .systemFont(ofSize: 24), numOflines: 0, textalignment: .left)
    
    private let phoneImage = ImageView(systemName: "phone", imagecolor: .black)
    private let phoneLabel = Label(texttitle: "03388473222", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let mailImage = ImageView(systemName: "mail", imagecolor: .black)
    private let mailLabel = Label(texttitle: "ali@gmail.com", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let linkImage = ImageView(systemName: "link", imagecolor: .black)
    private let linkLabel = Label(texttitle: "http://kajsckjasnkcnas", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let descriptionHeadingLabel = Label(texttitle: "Description", textcolor: .black, font: .systemFont(ofSize: 22), numOflines: 0, textalignment: .left)
    private let descriptiontText = Label(texttitle: "jkahckjhakjhclkjalcjklasjncklasnlkcnasklncklasnlkcnaslkncklasncklasnlkcnlsnjnorevokporkeo", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let acheivementsHeadingLabel = Label(texttitle: "Achievements", textcolor: .black, font: .systemFont(ofSize: 22), numOflines: 0, textalignment: .left)
    private let acheivementsText = Label(texttitle: "lksdjnvlinwvknkjnjkvnkjsdnkjvndskjnvkjdsnvkljdsnkjvndsjknvkjsdnvjksndkjvnskjdnvjknewn;nvn;", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        headingLabel.text = "Profile"
        homeButton.backgroundColor = .clear
        chatButton.backgroundColor = .clear
        profileButton.backgroundColor = .beige
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 65.autoSized
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        fetchProfileData { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.updateUI(with: data)
                    self.hideLoader()
                }
            case .failure(let error):
                self.hideLoader()
                print("Failed to fetch profile data: \(error.localizedDescription)")
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    override func setupViews() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(updateButton)
        view.addSubview(logoutButton)
        view.addSubview(aboutLabel)
        view.addSubview(phoneImage)
        view.addSubview(phoneLabel)
        view.addSubview(mailImage)
        view.addSubview(mailLabel)
        view.addSubview(linkImage)
        view.addSubview(linkLabel)
        view.addSubview(descriptionHeadingLabel)
        view.addSubview(descriptiontText)
        view.addSubview(acheivementsHeadingLabel)
        view.addSubview(acheivementsText)
        
        super.setupViews()
        
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            profileImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40.autoSized),
            profileImageView.heightAnchor.constraint(equalToConstant: 130.autoSized),
            profileImageView.widthAnchor.constraint(equalToConstant: 130.autoSized),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20.widthRatio),
            nameLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 50.autoSized),
            
            updateButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.autoSized),
            updateButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: 30.autoSized),
            updateButton.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            
            logoutButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 10.autoSized),
            logoutButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 30.autoSized),
            logoutButton.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            
            aboutLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            aboutLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 60.autoSized),
            
            phoneImage.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            phoneImage.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 20.autoSized),
            
            phoneLabel.centerYAnchor.constraint(equalTo: phoneImage.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneImage.trailingAnchor, constant: 10.widthRatio),
            
            mailImage.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            mailImage.topAnchor.constraint(equalTo: phoneImage.bottomAnchor, constant: 10.autoSized),
            
            mailLabel.centerYAnchor.constraint(equalTo: mailImage.centerYAnchor),
            mailLabel.leadingAnchor.constraint(equalTo: mailImage.trailingAnchor, constant: 10.widthRatio),
            
            linkImage.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            linkImage.topAnchor.constraint(equalTo: mailImage.bottomAnchor, constant: 10.autoSized),
            
            linkLabel.centerYAnchor.constraint(equalTo: linkImage.centerYAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: linkImage.trailingAnchor, constant: 10.widthRatio),
            
            descriptionHeadingLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 30.autoSized),
            descriptionHeadingLabel.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor),
            
            descriptiontText.leadingAnchor.constraint(equalTo: descriptionHeadingLabel.leadingAnchor),
            descriptiontText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.widthRatio),
            descriptiontText.topAnchor.constraint(equalTo: descriptionHeadingLabel.bottomAnchor, constant: 20.autoSized),
            
            acheivementsHeadingLabel.topAnchor.constraint(equalTo: descriptiontText.bottomAnchor, constant: 30.autoSized),
            acheivementsHeadingLabel.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor),
            
            acheivementsText.leadingAnchor.constraint(equalTo: descriptionHeadingLabel.leadingAnchor),
            acheivementsText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.widthRatio),
            acheivementsText.topAnchor.constraint(equalTo: acheivementsHeadingLabel.bottomAnchor, constant: 20.autoSized),
            
        ])
    }
    
    @objc func logoutTapped() {
        logout { result in
            switch result {
            case .success:
                print("User successfully logged out.")
                // Navigate to the login screen
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(let error):
                print("Failed to log out: \(error.localizedDescription)")
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        self.showLoader()
        do {
            try Auth.auth().signOut()
            self.hideLoader()
            completion(.success(())) // Successfully logged out
        } catch let error {
            self.hideLoader()
            completion(.failure(error)) // Return the error if logout fails
        }
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: Firebase
extension MyProfileViewController {
    func fetchProfileData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let db = Firestore.firestore()
        self.showLoader()
        // Replace `userID` with the actual ID of the document for the user
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "User ID not found", code: 401, userInfo: nil)))
            return
        }
        
        db.collection("users") // Adjust the collection name based on your Firestore structure
            .document(userID)
            .getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error)) // Return the error if fetching fails
                } else if let document = document, document.exists {
                    if let data = document.data() {
                        completion(.success(data)) // Return the fetched data
                    } else {
                        completion(.failure(NSError(domain: "Data not found", code: 404, userInfo: nil)))
                    }
                }
            }
    }
    func updateUI(with data: [String: Any]) {
        // Personal Details
        if let personalDetails = data["personalDetails"] as? [String: Any] {
            nameLabel.text = "\(personalDetails["firstName"] as? String ?? "") \(personalDetails["lastName"] as? String ?? "")"
            phoneLabel.text = personalDetails["phone"] as? String
            mailLabel.text = personalDetails["email"] as? String
        }
        
        // DOB
        if let dob = data["dob"] as? String {
            print("Date of Birth: \(dob)") // Use this if required in the UI
        }
        
        // Work Details
        if let workDetails = data["workDetails"] as? [String: Any] {
            linkLabel.text = workDetails["workLink"] as? String
            descriptiontText.text = workDetails["description"] as? String
            acheivementsText.text = workDetails["achievements"] as? String
        }
        
        // Interests Details
        if let interestsDetails = data["interestsDetails"] as? [String: Any] {
            print("Interests: \(interestsDetails["interests"] as? String ?? "")")
        }
        
        // Profile Image
        if let profileImageString = data["profileImage"] as? String,
           let imageData = Data(base64Encoded: profileImageString),
           let image = UIImage(data: imageData) {
            profileImageView.image = image
        }
    }
}
