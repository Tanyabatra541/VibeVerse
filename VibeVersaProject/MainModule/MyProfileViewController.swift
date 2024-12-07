import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyProfileViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageView = ImageView(imagecolor: .blue)
    private let nameLabel = Label(texttitle: "Name", textcolor: .black, font: .systemFont(ofSize: 26), numOflines: 0, textalignment: .center)
    private let updateButton = ButtonWithLabel(title: "My Communities", font: .systemFont(ofSize: 14), backgroundColor: .yellow, titlecolor: .black, cornerRadius: 10)
    private let logoutButton = ButtonWithLabel(title: "Logout", font: .systemFont(ofSize: 14), backgroundColor: .yellow, titlecolor: .black, cornerRadius: 10)
    
    private let aboutLabel = Label(texttitle: "About", textcolor: .black, font: .systemFont(ofSize: 24), numOflines: 0, textalignment: .left)
    
    private let phoneImage = ImageView(systemName: "phone", imagecolor: .black)
    private let phoneLabel = Label(texttitle: "Phone", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let mailImage = ImageView(systemName: "mail", imagecolor: .black)
    private let mailLabel = Label(texttitle: "Email", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let linkImage = ImageView(systemName: "link", imagecolor: .black)
    private let linkLabel = Label(texttitle: "Work Link", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let descriptionHeadingLabel = Label(texttitle: "Description", textcolor: .black, font: .systemFont(ofSize: 22), numOflines: 0, textalignment: .left)
    private let descriptiontText = Label(texttitle: "Description Text", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let acheivementsHeadingLabel = Label(texttitle: "Achievements", textcolor: .black, font: .systemFont(ofSize: 22), numOflines: 0, textalignment: .left)
    private let acheivementsText = Label(texttitle: "Achievements Text", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
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
        updateButton.addTarget(self, action: #selector(showMyCommunities), for: .touchUpInside)
    }
    
    override func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(updateButton)
        contentView.addSubview(logoutButton)
        contentView.addSubview(aboutLabel)
        contentView.addSubview(phoneImage)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(mailImage)
        contentView.addSubview(mailLabel)
        contentView.addSubview(linkImage)
        contentView.addSubview(linkLabel)
        contentView.addSubview(descriptionHeadingLabel)
        contentView.addSubview(descriptiontText)
        contentView.addSubview(acheivementsHeadingLabel)
        contentView.addSubview(acheivementsText)
        
        super.setupViews()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.autoSized),
            profileImageView.heightAnchor.constraint(equalToConstant: 130.autoSized),
            profileImageView.widthAnchor.constraint(equalToConstant: 130.autoSized),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20.widthRatio),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50.autoSized),
            
            updateButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.autoSized),
            updateButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: 30.autoSized),
            updateButton.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            
            logoutButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 10.autoSized),
            logoutButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 30.autoSized),
            logoutButton.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            
            aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            aboutLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 60.autoSized),
            
            phoneImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            phoneImage.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 20.autoSized),
            
            phoneLabel.centerYAnchor.constraint(equalTo: phoneImage.centerYAnchor),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneImage.trailingAnchor, constant: 10.widthRatio),
            
            mailImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            mailImage.topAnchor.constraint(equalTo: phoneImage.bottomAnchor, constant: 10.autoSized),
            
            mailLabel.centerYAnchor.constraint(equalTo: mailImage.centerYAnchor),
            mailLabel.leadingAnchor.constraint(equalTo: mailImage.trailingAnchor, constant: 10.widthRatio),
            
            linkImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25.widthRatio),
            linkImage.topAnchor.constraint(equalTo: mailImage.bottomAnchor, constant: 10.autoSized),
            
            linkLabel.centerYAnchor.constraint(equalTo: linkImage.centerYAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: linkImage.trailingAnchor, constant: 10.widthRatio),
            
            descriptionHeadingLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 30.autoSized),
            descriptionHeadingLabel.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor),
            
            descriptiontText.leadingAnchor.constraint(equalTo: descriptionHeadingLabel.leadingAnchor),
            descriptiontText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.widthRatio),
            descriptiontText.topAnchor.constraint(equalTo: descriptionHeadingLabel.bottomAnchor, constant: 20.autoSized),
            
            acheivementsHeadingLabel.topAnchor.constraint(equalTo: descriptiontText.bottomAnchor, constant: 30.autoSized),
            acheivementsHeadingLabel.leadingAnchor.constraint(equalTo: aboutLabel.leadingAnchor),
            
            acheivementsText.leadingAnchor.constraint(equalTo: descriptionHeadingLabel.leadingAnchor),
            acheivementsText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.widthRatio),
            acheivementsText.topAnchor.constraint(equalTo: acheivementsHeadingLabel.bottomAnchor, constant: 20.autoSized),
            acheivementsText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.autoSized),
        ])
    }
    
    @objc func logoutTapped() {
        logout { result in
            switch result {
            case .success:
                print("User successfully logged out.")
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
            completion(.success(()))
        } catch let error {
            self.hideLoader()
            completion(.failure(error))
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
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "User ID not found", code: 401, userInfo: nil)))
            return
        }
        
        db.collection("users")
            .document(userID)
            .getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let document = document, document.exists {
                    if let data = document.data() {
                        completion(.success(data))
                    } else {
                        completion(.failure(NSError(domain: "Data not found", code: 404, userInfo: nil)))
                    }
                }
            }
    }
    
    func updateUI(with data: [String: Any]) {
        if let personalDetails = data["personalDetails"] as? [String: Any] {
            nameLabel.text = "\(personalDetails["firstName"] as? String ?? "") \(personalDetails["lastName"] as? String ?? "")"
            phoneLabel.text = personalDetails["phone"] as? String
            mailLabel.text = personalDetails["email"] as? String
        }
        
        if let workDetails = data["workDetails"] as? [String: Any] {
            linkLabel.text = workDetails["workLink"] as? String
            descriptiontText.text = workDetails["description"] as? String
            acheivementsText.text = workDetails["achievements"] as? String
        }
        
        if let profileImageUrl = data["profileImageUrl"] as? String {
            loadImage(from: profileImageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    @objc func showMyCommunities() {
        let myCommunitiesVC = MyCommunitiesViewController()
        self.navigationController?.pushViewController(myCommunitiesVC, animated: true)
    }

    
    func displayJoinedCommunities(_ communities: [String]) {
        let communitiesList = communities.joined(separator: "\n")
        let alert = UIAlertController(title: "My Communities", message: communitiesList, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

