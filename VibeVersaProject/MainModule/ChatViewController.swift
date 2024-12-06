
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "Profile", textcolor: .black, font: .systemFont(ofSize: 30, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    
    private let tableView = UITableView()
    private let messageInputView = View(backgroundcolor: .darkBeige, cornerradius: 10.autoSized)
    private let messageTextField = UITextField()
    private let sendButton = UIButton()
    
    private var messages: [MessageModel] = []
    private let db = Firestore.firestore()
    
    private var currentUserId: String
    private var recipientUser: UsersModel
    private var chatDocumentId: String?
    
    private var bottomConstraint: NSLayoutConstraint?
    
    init(currentUserId: String, recipientUser: UsersModel) {
        self.currentUserId = currentUserId
        self.recipientUser = recipientUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        createChatDocumentIfNeeded()
        fetchMessages()
        setupKeyboardObservers()
        setupUI()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func setupUI() {
        view.backgroundColor = .beige
        headingLabel.text = "\(recipientUser.firstName ) \(recipientUser.lastName)"
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageInputView)
        
        // Message Text Field
        messageTextField.borderStyle = .roundedRect
        messageTextField.backgroundColor = .darkBeige
        messageTextField.textColor = .black
        messageInputView.addSubview(messageTextField)
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Send Button
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .yellow
        sendButton.layer.cornerRadius = 5
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        messageInputView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            
            // Message Input View
            messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.widthRatio),
//            messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 50),
            
            // Message Text Field
            messageTextField.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 10),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            
            // Send Button
            sendButton.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
        ])
        bottomConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        bottomConstraint?.isActive = true
    }
    
    private func fetchMessages() {
        guard let chatDocumentId = chatDocumentId else { return }

        db.collection("chats")
            .document(chatDocumentId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }

                self.messages = snapshot?.documents.compactMap {
                    // Ensure `timestamp` exists before mapping
                    let data = $0.data()
                    guard data["timestamp"] != nil else { return nil }
                    return MessageModel(dictionary: data)
                } ?? []
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
    }

    
    private func createChatDocumentIfNeeded() {
        let userIds = [currentUserId, recipientUser.id].sorted()
        let chatId = userIds.joined(separator: "_")
        self.chatDocumentId = chatId
        
        db.collection("chats").document(chatId).getDocument { document, error in
            if let error = error {
                print("Error checking chat document: \(error)")
                return
            }
            
            if document?.exists == false {
                self.db.collection("chats").document(chatId).setData([
                    "users": userIds,
                    "lastMessage": "",
                    "lastUpdated": FieldValue.serverTimestamp()
                ])
            }
        }
    }
    
    @objc private func sendMessage() {
        guard let chatDocumentId = chatDocumentId,
              let messageText = messageTextField.text,
              !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let messageData: [String: Any] = [
            "senderId": currentUserId,
            "receiverId": recipientUser.id,
            "text": messageText,
            "timestamp": FieldValue.serverTimestamp()
        ]

        db.collection("chats")
            .document(chatDocumentId)
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                } else {
                    self.messageTextField.text = ""

                    // Update last message
                    self.db.collection("chats").document(chatDocumentId).updateData([
                        "lastMessage": messageText,
                        "lastUpdated": FieldValue.serverTimestamp()
                    ])

                    // Force refresh messages immediately
                    self.fetchMessages()
                }
            }
    }

    private func setupKeyboardObservers() {
        // Observe keyboard show and hide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustForKeyboard(notification: notification, isShowing: true)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustForKeyboard(notification: notification, isShowing: false)
    }

    private func adjustForKeyboard(notification: Notification, isShowing: Bool) {
        // Get keyboard height from the notification's userInfo
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        // Adjust the bottom constraint
        bottomConstraint?.constant = isShowing ? -(keyboardHeight + 10) : -10
        
        // Animate the changes
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    private func scrollToBottom() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = message.senderId == currentUserId ? .right : .left
        return cell
    }
}
