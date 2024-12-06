
import Foundation
import UIKit

class BaseViewController: UIViewController {

    // MARK: - UI Components
    
    let tabBarView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    // Custom Tab Bar Components
    let homeButton = ButtonWithImage(systemName: "house")
    let chatButton = ButtonWithImage(systemName: "mail")
    let profileButton = ButtonWithImage(systemName: "person")
    
    // Custom Header Components
    let headerView = View(backgroundcolor: .darkBeige, cornerradius: 0)
    let headingLabel = Label(texttitle: "Heading", textcolor: .black, font: .systemFont(ofSize: 28, weight: .bold), numOflines: 1, textalignment: .left)
    private let backButton = ButtonWithImage(systemName: "arrow.backward")
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .beige // Set your preferred background color
        homeButton.layer.cornerRadius = 10.autoSized
        homeButton.imageView?.frame = CGRect(x: 0, y: 0, width: 60.autoSized, height: 60.autoSized)
        chatButton.layer.cornerRadius = 10.autoSized
        chatButton.imageView?.frame = CGRect(x: 0, y: 0, width: 60.autoSized, height: 60.autoSized)
        profileButton.layer.cornerRadius = 10.autoSized
        profileButton.imageView?.frame = CGRect(x: 0, y: 0, width: 60.autoSized, height: 60.autoSized)
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // Dismiss keyboard when tapping anywhere outside text fields
    }

    // MARK: - Setup Header
    func setupViews() {
        view.addSubview(headerView)
//        headerView.addSubview(backButton)
        headerView.addSubview(headingLabel)
        view.addSubview(tabBarView)
        tabBarView.addSubview(homeButton)
        tabBarView.addSubview(chatButton)
        tabBarView.addSubview(profileButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        chatButton.addTarget(self, action: #selector(chatButtonTapped), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100.autoSized),
            
            // Back Button
//            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20.autoSized),
//            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.widthRatio),
//            backButton.widthAnchor.constraint(equalToConstant: 40.autoSized),
//            backButton.heightAnchor.constraint(equalToConstant: 40.autoSized),

            // Heading Label
            headingLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 20.autoSized),
            headingLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.widthRatio),
            
            // Tab Bar View
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 90.autoSized),

            // Home Button
            homeButton.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor, constant: -150.widthRatio),
            homeButton.centerYAnchor.constraint(equalTo: tabBarView.centerYAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 40.autoSized),
            homeButton.heightAnchor.constraint(equalToConstant: 40.autoSized),

            // Chat Button
            chatButton.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor),
            chatButton.centerYAnchor.constraint(equalTo: tabBarView.centerYAnchor),
            chatButton.widthAnchor.constraint(equalToConstant: 40.autoSized),
            chatButton.heightAnchor.constraint(equalToConstant: 40.autoSized),

            // Profile Button
            profileButton.centerXAnchor.constraint(equalTo: tabBarView.centerXAnchor, constant: 150.widthRatio),
            profileButton.centerYAnchor.constraint(equalTo: tabBarView.centerYAnchor),
            profileButton.widthAnchor.constraint(equalToConstant: 40.autoSized),
            profileButton.heightAnchor.constraint(equalToConstant: 40.autoSized),
        ])
    }

    // MARK: - Button Actions
    @objc func backButtonTapped() {
        // Custom back button action (e.g., pop the view controller)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func homeButtonTapped() {
        self.navigationController?.pushViewController(HomeViewController(), animated: false)
    }
    
    @objc func chatButtonTapped() {
        self.navigationController?.pushViewController(ChatHistoryViewController(), animated: false)
    }
    
    @objc func profileButtonTapped() {
        self.navigationController?.pushViewController(MyProfileViewController(), animated: false)
    }
}
