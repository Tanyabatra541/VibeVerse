import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore

class MyCommunitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "My Communities", textcolor: .black, font: .systemFont(ofSize: 28, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    private let tableView = UITableView()
    
    private var myCommunities: [Community] = [] // Fetched joined communities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupUI()
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        // Fetch the user's joined communities
        fetchMyCommunitiesFromFirebase()
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        
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
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch Joined Communities from Firebase
    private func fetchMyCommunitiesFromFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching joined communities: \(error.localizedDescription)")
                return
            }
            
            guard let data = document?.data(), let joinedCommunities = data["joinedCommunities"] as? [String] else {
                print("No joined communities found")
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
                print("No community details found")
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
        cell.configure(with: community)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.autoSized
    }
}
