
import Foundation
import UIKit
import FirebaseFirestore

class HomeViewController: BaseViewController {
    
    private let communitiesLabel = Label(
        texttitle: "Communities for you",
        textcolor: .black,
        font: .systemFont(ofSize: 22, weight: .bold),
        numOflines: 1,
        textalignment: .left
    )
    private let seeMoreCommunitiesButton = ButtonWithLabel(
        title: "See more",
        backgroundColor: .clear,
        titlecolor: .black,
        cornerRadius: 0
    )

    private let communityCard = View(
        backgroundcolor: .yellow,
        cornerradius: 20
    )
    private let communityTitleLabel = Label(
        texttitle: "Graphic Era",
        textcolor: .black,
        font: .systemFont(ofSize: 18, weight: .bold),
        numOflines: 1,
        textalignment: .left
    )
    private let communityDescriptionLabel = Label(
        texttitle: "Unleash your creativity and join our vibrant community of graphic designers, where ideas ignite and talents flourish",
        textcolor: .black,
        font: .systemFont(ofSize: 14),
        numOflines: 0,
        textalignment: .left
    )
    private let joinButton = ButtonWithLabel(
        title: "Join",
        backgroundColor: .brown,
        titlecolor: .white,
        cornerRadius: 10
    )

    private let similarPeopleLabel = Label(
        texttitle: "Users",
        textcolor: .black,
        font: .systemFont(ofSize: 22, weight: .bold),
        numOflines: 1,
        textalignment: .left
    )
    private let seeMoreUserssButton = ButtonWithLabel(
        title: "See more",
        backgroundColor: .clear,
        titlecolor: .black,
        cornerRadius: 0
    )
    private let tableView = UITableView()
    private var users: [UsersModel] = []
    var joined = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        homeButton.backgroundColor = .beige
        chatButton.backgroundColor = .clear
        profileButton.backgroundColor = .clear
        headingLabel.text = "Home"
        seeMoreCommunitiesButton.addTarget(self, action: #selector(handleSeeMoreCommunities), for: .touchUpInside)
        seeMoreUserssButton.addTarget(self, action: #selector(handleSeeMoreUsers), for: .touchUpInside)
        joinButton.addTarget(self, action: #selector(joinNowTapped), for: .touchUpInside)
        fetchUsers { result in
            switch result {
            case .success(let usersData):
                DispatchQueue.main.async {
                    self.users = usersData
                    self.tableView.reloadData()
                    self.hideLoader()
                }
            case .failure(let error):
                self.hideLoader()
                print("Failed to fetch users: \(error.localizedDescription)")
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    override func setupViews() {
        view.addSubview(communitiesLabel)
        view.addSubview(seeMoreCommunitiesButton)
        view.addSubview(similarPeopleLabel)
        view.addSubview(seeMoreUserssButton)

        // Community Card
        view.addSubview(communityCard)
        communityCard.addSubview(communityTitleLabel)
        communityCard.addSubview(communityDescriptionLabel)
        communityCard.addSubview(joinButton)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        super.setupViews()
        
        NSLayoutConstraint.activate([
            // Communities Section
            communitiesLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20.autoSized),
            communitiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            
            seeMoreCommunitiesButton.centerYAnchor.constraint(equalTo: communitiesLabel.centerYAnchor),
            seeMoreCommunitiesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),

            // Community Card
            communityCard.topAnchor.constraint(equalTo: communitiesLabel.bottomAnchor, constant: 10.autoSized),
            communityCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            communityCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            communityCard.heightAnchor.constraint(equalToConstant: 150.autoSized),

            communityTitleLabel.topAnchor.constraint(equalTo: communityCard.topAnchor, constant: 10.autoSized),
            communityTitleLabel.leadingAnchor.constraint(equalTo: communityCard.leadingAnchor, constant: 10.widthRatio),

            communityDescriptionLabel.topAnchor.constraint(equalTo: communityTitleLabel.bottomAnchor, constant: 10.autoSized),
            communityDescriptionLabel.leadingAnchor.constraint(equalTo: communityCard.leadingAnchor, constant: 10.widthRatio),
            communityDescriptionLabel.trailingAnchor.constraint(equalTo: communityCard.trailingAnchor, constant: -10.widthRatio),

            joinButton.bottomAnchor.constraint(equalTo: communityCard.bottomAnchor, constant: -10.autoSized),
            joinButton.trailingAnchor.constraint(equalTo: communityCard.trailingAnchor, constant: -25.widthRatio),
            joinButton.leadingAnchor.constraint(equalTo: communityCard.leadingAnchor, constant: 25.widthRatio),
            joinButton.heightAnchor.constraint(equalToConstant: 40.autoSized),

            // Similar People Section
            similarPeopleLabel.topAnchor.constraint(equalTo: communityCard.bottomAnchor, constant: 20.autoSized),
            similarPeopleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.widthRatio),
            
            seeMoreUserssButton.centerYAnchor.constraint(equalTo: similarPeopleLabel.centerYAnchor),
            seeMoreUserssButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.widthRatio),
            
            tableView.topAnchor.constraint(equalTo: similarPeopleLabel.bottomAnchor, constant: 10.autoSized),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor),
        ])
    }
    @objc func joinNowTapped() {
        joined.toggle()
        if joined {
            joinButton.backgroundColor = .systemGreen
            joinButton.setTitle("Joined", for: .normal)
        } else {
            joinButton.backgroundColor = .black
            joinButton.setTitle("Join", for: .normal)
        }

    }
    @objc func handleSeeMoreCommunities() {
        self.navigationController?.pushViewController(AllCommunitiesViewController(), animated: true)
    }
    @objc func handleSeeMoreUsers() {
        self.navigationController?.pushViewController(AllUsersViewController(users: users), animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        cell.configure(with: users[indexPath.row])
        cell.viewProfileTapped = {
            self.navigationController?.pushViewController(UserProfileController(userData: self.users[indexPath.row]), animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.autoSized
    }
}

// MARK: - Firebase
extension HomeViewController {
    func fetchUsers(completion: @escaping (Result<[UsersModel], Error>) -> Void) {
        let db = Firestore.firestore()
        self.showLoader()
        
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                let users = documents.compactMap { UsersModel(dictionary: $0.data()) }
                completion(.success(users))
            } else {
                completion(.failure(NSError(domain: "No users found", code: 404, userInfo: nil)))
            }
        }
    }

}
