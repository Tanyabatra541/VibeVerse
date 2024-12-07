import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatHistoryViewController: BaseViewController {
    private let tableView = UITableView()
    private var users: [UsersModel] = []
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatHistoryUserCell.self, forCellReuseIdentifier: ChatHistoryUserCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        headingLabel.text = "Chats"
        homeButton.backgroundColor = .clear
        chatButton.backgroundColor = .beige
        profileButton.backgroundColor = .clear
        
        fetchChatUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                self.showAlert(message: "Error fetching chat users: \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChatHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatHistoryUserCell.identifier, for: indexPath) as? ChatHistoryUserCell else {
            return UITableViewCell()
        }
        cell.configure(with: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = users[indexPath.row]
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let chatVC = ChatViewController(currentUserId: currentUserId, recipientUser: selectedUser)
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ChatHistoryViewController {
    func fetchChatUsers(completion: @escaping (Result<[UsersModel], Error>) -> Void) {
        let db = Firestore.firestore()
        self.showLoader()
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "No current user found", code: 401, userInfo: nil)))
            return
        }
        
        db.collection("chats")
            .whereField("users", arrayContains: currentUserId)
            .getDocuments { snapshot, error in
                self.hideLoader()
                
                if let error = error {
                    completion(.failure(error))
                } else if let documents = snapshot?.documents {
                    var userIds = Set<String>()
                    
                    for doc in documents {
                        if let users = doc.data()["users"] as? [String] {
                            users.forEach { userId in
                                if userId != currentUserId {
                                    userIds.insert(userId)
                                }
                            }
                        }
                    }
                    
                    guard !userIds.isEmpty else {
                        completion(.success([]))
                        return
                    }
                    
                    db.collection("users")
                        .whereField("userId", in: Array(userIds))
                        .getDocuments { userSnapshot, userError in
                            if let userError = userError {
                                completion(.failure(userError))
                            } else if let userDocs = userSnapshot?.documents {
                                let users = userDocs.compactMap { UsersModel(dictionary: $0.data()) }
                                completion(.success(users))
                            }
                        }
                }
            }
    }
}
