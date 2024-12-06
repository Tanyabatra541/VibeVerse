
import Foundation
import UIKit

class AllUsersViewController: UIViewController, UISearchBarDelegate {
    
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "Users", textcolor: .black, font: .systemFont(ofSize: 28, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    var users: [UsersModel]
    var filteredUsers: [UsersModel] = []
    
    init(users: [UsersModel]) {
        self.users = users
        self.filteredUsers = users
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        view.backgroundColor = .beige
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        setupUI()
    }
    private func setupUI() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        // Setup search bar
        searchBar.placeholder = "Search Users"
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter {
                $0.firstName.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension AllUsersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredUsers[indexPath.row])
        cell.viewProfileTapped = {
            self.navigationController?.pushViewController(UserProfileController(userData: self.users[indexPath.row]), animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.autoSized
    }
}
