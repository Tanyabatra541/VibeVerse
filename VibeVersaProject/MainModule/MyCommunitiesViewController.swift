import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyCommunitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "My Communities", textcolor: .black, font: .systemFont(ofSize: 28, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    private let tableView = UITableView()
    private let noCommunitiesLabel = Label(
        texttitle: "You haven't joined any communities yet.",
        textcolor: .gray,
        font: .systemFont(ofSize: 18),
        numOflines: 0,
        textalignment: .center
    )
    
    private var myCommunities: [Community] = [] // Fetched joined communities
    private var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupUI()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Fetch the user's joined communities
        fetchMyCommunitiesFromFirebase()
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        view.addSubview(noCommunitiesLabel)
        
        // Setup table view
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(CommunityCell.self, forCellReuseIdentifier: CommunityCell.identifier)
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
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // No Communities Label
            noCommunitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCommunitiesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noCommunitiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noCommunitiesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Initially hide the noCommunitiesLabel
        noCommunitiesLabel.isHidden = true
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch Joined Communities from Firebase
    private func fetchMyCommunitiesFromFirebase() {
        guard let userId = userId else {
            print("Error: User ID not found")
            return
        }
        let db = Firestore.firestore()

        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching joined communities: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data(), let joinedCommunities = data["joinedCommunities"] as? [String], !joinedCommunities.isEmpty else {
                DispatchQueue.main.async {
                    self.myCommunities = []
                    self.tableView.reloadData()
                    self.noCommunitiesLabel.isHidden = false
                }
                return
            }
            
            // Fetch community details for each joined community
            self.fetchCommunityDetails(for: joinedCommunities)
        }
    }
    
    private func fetchCommunityDetails(for communityTitles: [String]) {
        let db = Firestore.firestore()
        
        db.collection("communities").whereField("title", in: communityTitles).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching community details: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                DispatchQueue.main.async {
                    self.myCommunities = []
                    self.tableView.reloadData()
                    self.noCommunitiesLabel.isHidden = false
                }
                return
            }
            
            // Map documents to Community model
            self.myCommunities = documents.compactMap { document -> Community? in
                let data = document.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String else { return nil }
                return Community(title: title, description: description)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noCommunitiesLabel.isHidden = self.myCommunities.isEmpty ? false : true
            }
        }
    }
    
    private func unjoinCommunity(_ community: Community) {
        guard let userId = userId else { return }
        let db = Firestore.firestore()
        
        // Remove community from Firestore
        db.collection("users").document(userId).updateData([
            "joinedCommunities": FieldValue.arrayRemove([community.title])
        ]) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error unjoining community: \(error.localizedDescription)")
                return
            }
            
            print("Successfully unjoined community: \(community.title)")
            
            // Update the local data and UI
            self.myCommunities.removeAll { $0.title == community.title }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noCommunitiesLabel.isHidden = !self.myCommunities.isEmpty
            }
        }
    }
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCommunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityCell.identifier, for: indexPath) as? CommunityCell else {
            return UITableViewCell()
        }
        
        let community = myCommunities[indexPath.row]
        cell.configure(with: community, isJoined: true)
        cell.joinAction = { [weak self] isJoined in
            if !isJoined {
                self?.unjoinCommunity(community)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.autoSized
    }
}
