import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserProfileController: UIViewController {
    
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "Profile", textcolor: .black, font: .systemFont(ofSize: 30, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    private let profileImageView = ImageView(imagecolor: .blue)
    private let nameLabel = Label(texttitle: "Name", textcolor: .black, font: .systemFont(ofSize: 26), numOflines: 0, textalignment: .center)
    private let messageButton = ButtonWithLabel(title: "Message", font: .systemFont(ofSize: 14), backgroundColor: .yellow, titlecolor: .black, cornerRadius: 10)
    
    private let aboutLabel = Label(texttitle: "About", textcolor: .black, font: .systemFont(ofSize: 24), numOflines: 0, textalignment: .left)
    
    private let phoneImage = ImageView(systemName: "phone", imagecolor: .black)
    private let phoneLabel = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let mailImage = ImageView(systemName: "mail", imagecolor: .black)
    private let mailLabel = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let linkImage = ImageView(systemName: "link", imagecolor: .black)
    private let linkLabel = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let descriptionHeadingLabel = Label(texttitle: "Description", textcolor: .black, font: .systemFont(ofSize: 22), numOflines: 0, textalignment: .left)
    private let descriptiontText = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    
    private let acheivementsHeadingLabel = Label(texttitle: "Achievements", textcolor: .black, font: .systemFont(ofSize: 22), numOflines: 0, textalignment: .left)
    private let acheivementsText = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    var userData: UsersModel
    
    init(userData: UsersModel) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        makeUI()
        setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 65.autoSized
        messageButton.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Load profile image
        loadProfileImage()
    }
    
    func setupViews() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(messageButton)
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
                
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100.autoSized),
            
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20.autoSized),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.widthRatio),
            backButton.widthAnchor.constraint(equalToConstant: 40.autoSized),
            backButton.heightAnchor.constraint(equalToConstant: 40.autoSized),

            headingLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20.autoSized),
            headingLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20.widthRatio),
            
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            profileImageView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40.autoSized),
            profileImageView.heightAnchor.constraint(equalToConstant: 130.autoSized),
            profileImageView.widthAnchor.constraint(equalToConstant: 130.autoSized),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20.widthRatio),
            nameLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 80.autoSized),
            
            messageButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.autoSized),
            messageButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageButton.heightAnchor.constraint(equalToConstant: 30.autoSized),
            messageButton.widthAnchor.constraint(equalToConstant: 200.widthRatio),
            
            aboutLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            aboutLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40.autoSized),
            
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
    
    private func makeUI() {
        headingLabel.text = "\(userData.firstName) \(userData.lastName)"
        nameLabel.text = "\(userData.firstName) \(userData.lastName)"
        phoneLabel.text = userData.phone
        mailLabel.text = userData.email
        linkLabel.text = userData.workLink
        descriptiontText.text = userData.description
        acheivementsText.text = userData.achievements
    }
    
    private func loadProfileImage() {
        guard let profileImageUrl = userData.profileImageUrl, let url = URL(string: profileImageUrl) else {
            print("Invalid profile image URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading profile image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }.resume()
    }
    
    @objc func messageButtonTapped() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let chatVC = ChatViewController(currentUserId: currentUserId, recipientUser: userData)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
