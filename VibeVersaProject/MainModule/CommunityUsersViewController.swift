import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommunityUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI Components
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "Users", textcolor: .black, font: .systemFont(ofSize: 28, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    private let tableView = UITableView()
    
    private let communityTitle: String
    private var users: [UsersModel] = []
    
    // Init with the community title passed from the previous screen
    init(communityTitle: String) {
        self.communityTitle = communityTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupUI()
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        // Fetch users who joined the community
        fetchUsersInCommunity()
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        
        // Setup table view
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Layout
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100.autoSized),
            
            // Back Button
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20.autoSized),
            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.widthRatio),
            backButton.widthAnchor.constraint(equalToConstant: 40.autoSized),
            backButton.heightAnchor.constraint(equalToConstant: 40.autoSized),
            
            // Heading Label
            headingLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20.autoSized),
            headingLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 20.widthRatio),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch Users in the Community
    private func fetchUsersInCommunity() {
        let db = Firestore.firestore()
        
        db.collection("users")
            .whereField("joinedCommunities", arrayContains: communityTitle)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    return
                }
                
                self.users = snapshot?.documents.compactMap { document in
                    return UsersModel(dictionary: document.data())
                } ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.configure(with: user)
        cell.viewProfileTapped = {
            let userProfileVC = UserProfileController(userData: user)
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.autoSized
    }
}
