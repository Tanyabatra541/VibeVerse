import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatHistoryViewController: BaseViewController {
    private let tableView = UITableView()
    private var chats: [(UsersModel, String, Date)] = [] // Tuple of user, lastMessage, and lastUpdated

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
            case .success(let chatsData):
                if chatsData.isEmpty {
                    print("No chat history found.")
                    self.showAlert(message: "No chat history found.")
                }
                self.chats = chatsData
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
        return chats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatHistoryUserCell.identifier, for: indexPath) as? ChatHistoryUserCell else {
            return UITableViewCell()
        }
        let (user, lastMessage, lastUpdated) = chats[indexPath.row]
        cell.configure(with: user, lastMessage: lastMessage, lastUpdated: lastUpdated)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (selectedUser, _, _) = chats[indexPath.row]
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let chatVC = ChatViewController(currentUserId: currentUserId, recipientUser: selectedUser)
        navigationController?.pushViewController(chatVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ChatHistoryViewController {
    func fetchChatUsers(completion: @escaping (Result<[(UsersModel, String, Date)], Error>) -> Void) {
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
                    return
                }

                guard let documents = snapshot?.documents else {
                    completion(.failure(NSError(domain: "No chats found", code: 404, userInfo: nil)))
                    return
                }

                var chatData: [(UsersModel, String, Date)] = []

                let group = DispatchGroup()

                for doc in documents {
                    guard let users = doc.data()["users"] as? [String],
                          let lastMessage = doc.data()["lastMessage"] as? String,
                          let lastUpdated = (doc.data()["lastUpdated"] as? Timestamp)?.dateValue() else {
                        continue
                    }

                    for userId in users where userId != currentUserId {
                        group.enter()

                        db.collection("users").document(userId).getDocument { userSnapshot, userError in
                            if let userError = userError {
                                print("Error fetching user data: \(userError.localizedDescription)")
                            } else if let userData = userSnapshot?.data(),
                                      let user = UsersModel(dictionary: userData) {
                                chatData.append((user, lastMessage, lastUpdated))
                            }
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    completion(.success(chatData))
                }
            }
    }
}
