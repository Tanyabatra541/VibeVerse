
import Foundation
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
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20.autoSized),
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
                if users.isEmpty {
                    print("No chat history found.") // Handle empty case in UI
                    self.showAlert(message: "No chat History found")
                }
                self.users = users
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching chat users: \(error.localizedDescription)")
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
        return 100
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
        
        // Fetch chats where the current user is either the sender or receiver
        db.collection("chats")
            .whereField("users", arrayContains: currentUserId) // Check if currentUserId is in the 'users' array
            .getDocuments { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let documents = snapshot?.documents {
                    var userIds = Set<String>()
                    
                    for doc in documents {
                        if let users = doc.data()["users"] as? [String] {
                            // Add the other user IDs to the set
                            users.forEach { userId in
                                if userId != currentUserId {
                                    userIds.insert(userId)
                                }
                            }
                        }
                    }
                    
                    // Handle empty userIds
                    guard !userIds.isEmpty else {
                        self.hideLoader()
                        completion(.success([])) // Return empty user list
                        return
                    }
                    
                    // Fetch user details based on these user IDs
                    db.collection("users")
                        .whereField("userId", in: Array(userIds))
                        .getDocuments { (userSnapshot, userError) in
                            self.hideLoader()
                            if let userError = userError {
                                completion(.failure(userError))
                            } else if let userDocs = userSnapshot?.documents {
                                // Map user data to UsersModel
                                let users = userDocs.compactMap { UsersModel(dictionary: $0.data()) }
                                completion(.success(users))
                            }
                        }
                } else {
                    self.hideLoader()
                    completion(.failure(NSError(domain: "No chats found", code: 404, userInfo: nil)))
                }
            }
    }
}

