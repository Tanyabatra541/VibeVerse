import UIKit

class ChatHistoryUserCell: UITableViewCell {
    static let identifier = "ChatHistoryUserCell"
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let cardView = UIView()
        cardView.backgroundColor = .yellow
        cardView.layer.cornerRadius = 10
        contentView.addSubview(cardView)
        
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        cardView.addSubview(profileImageView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .black
        cardView.addSubview(nameLabel)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            profileImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    func configure(with user: UsersModel) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        loadProfileImage(from: user.profileImageUrl)
    }
    
    private func loadProfileImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            profileImageView.image = UIImage(named: "defaultProfile") // Use a default image if URL is invalid
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error loading profile image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(named: "defaultProfile")
                }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }.resume()
    }
}
