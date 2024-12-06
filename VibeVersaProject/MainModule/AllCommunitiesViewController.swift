import Foundation
import UIKit
import FirebaseFirestore

class AllCommunitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "Communities", textcolor: .black, font: .systemFont(ofSize: 28, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private var communities: [Community] = [] // Dynamically fetched from Firestore
    private var filteredCommunities: [Community] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige
        setupUI()
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        // Fetch communities from Firebase
        fetchCommunitiesFromFirebase()
    }
    
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        // Setup search bar
        searchBar.placeholder = "Search Communities"
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.overrideUserInterfaceStyle = .light
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
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
            
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Fetch Communities from Firebase
    private func fetchCommunitiesFromFirebase() {
        let db = Firestore.firestore()
        
        // Fetch communities collection from Firestore
        db.collection("communities").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to fetch communities: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No communities found")
                return
            }
            
            // Map documents to Community model
            self.communities = documents.compactMap { document -> Community? in
                let data = document.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String else { return nil }
                return Community(title: title, description: description)
            }
            
            // Update filtered list and reload table view
            self.filteredCommunities = self.communities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCommunities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityCell.identifier, for: indexPath) as? CommunityCell else {
            return UITableViewCell()
        }
        
        let community = filteredCommunities[indexPath.row]
        cell.configure(with: community)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.autoSized
    }
    
    // MARK: - SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCommunities = communities
        } else {
            filteredCommunities = communities.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}

// MARK: - CommunityCell
class CommunityCell: UITableViewCell {
    static let identifier = "CommunityCell"
    
    private let cardView = View(backgroundcolor: .yellow, cornerradius: 15.autoSized)
    let titleLabel = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 18, weight: .bold), numOflines: 0, textalignment: .left)
    private let descriptionLabel = Label(texttitle: "", textcolor: .black, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)
    private let joinButton = ButtonWithLabel(title: "Join", font: .systemFont(ofSize: 16, weight: .bold), backgroundColor: .brown, titlecolor: .white, cornerRadius: 10.autoSized)
    var joined = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        joinButton.addTarget(self, action: #selector(handleJoinNow), for: .touchUpInside)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(joinButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.autoSized),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.widthRatio),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.widthRatio),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.autoSized),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10.autoSized),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10.widthRatio),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10.widthRatio),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.autoSized),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10.widthRatio),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10.widthRatio),
            
            joinButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -25.widthRatio),
            joinButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 25.widthRatio),
            joinButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10.autoSized),
            joinButton.heightAnchor.constraint(equalToConstant: 40.autoSized),
        ])
    }
    
    @objc func handleJoinNow() {
        joined.toggle()
        if joined {
            joinButton.backgroundColor = .systemGreen
            joinButton.setTitle("Joined", for: .normal)
        } else {
            joinButton.backgroundColor = .black
            joinButton.setTitle("Join", for: .normal)
        }
    }
    
    func configure(with community: Community) {
        titleLabel.text = community.title
        descriptionLabel.text = community.description
    }
}
