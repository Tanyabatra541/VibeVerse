import UIKit

class ChatHistoryUserCell: UITableViewCell {
    static let identifier = "ChatHistoryUserCell"

    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let lastMessageLabel = UILabel()
    private let timestampLabel = UILabel()

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

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .black
        cardView.addSubview(nameLabel)

        lastMessageLabel.font = UIFont.systemFont(ofSize: 14)
        lastMessageLabel.textColor = .darkGray
        cardView.addSubview(lastMessageLabel)

        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .gray
        timestampLabel.textAlignment = .right
        cardView.addSubview(timestampLabel)

        cardView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            profileImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),

            lastMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            lastMessageLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),

            timestampLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            timestampLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }

    func configure(with user: UsersModel, lastMessage: String, lastUpdated: Date) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        lastMessageLabel.text = lastMessage
        timestampLabel.text = formatESTDate(lastUpdated)
        loadProfileImage(from: user.profileImageUrl)
    }

    private func loadProfileImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            profileImageView.image = UIImage(named: "defaultProfile")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(named: "defaultProfile")
                }
            }
        }.resume()
    }

    private func formatESTDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: "America/New_York") // EST TimeZone
        return formatter.string(from: date)
    }
}
