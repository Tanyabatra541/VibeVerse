
import Foundation
import UIKit


class ChatHistoryUserCell: UITableViewCell {
    static let identifier = "ChatHistoryUserCell"
    
    private let profileImageView = ImageView(imagetitle: "")
    private let nameLabel = Label(textcolor: .black, font: .systemFont(ofSize: 18, weight: .bold))
    
    var viewProfileTapped: (()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10.autoSized
//        self.isUserInteractionEnabled = false
        self.selectionStyle = .none
        let cardView = View(backgroundcolor: .yellow, cornerradius: 10.autoSized)
        contentView.addSubview(cardView)
        cardView.addSubview(profileImageView)
        cardView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.autoSized),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.widthRatio),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.widthRatio),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.autoSized),
            
            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15.widthRatio),
            profileImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40.autoSized),
            profileImageView.heightAnchor.constraint(equalToConstant: 40.autoSized),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10.autoSized),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: UsersModel) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        profileImageView.image = user.profileImage
//        if let imageUrl = user.profileImage {
//            DispatchQueue.global().async {
//                if let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
//                    DispatchQueue.main.async {
//                        self.profileImageView.image = image
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.profileImageView.image = UIImage(named: "placeholder")
//                    }
//                }
//            }
//        } else {
//            self.profileImageView.image = UIImage(named: "placeholder")
//        }
    }
    @objc func profileButtonTapped() {
        viewProfileTapped?()
    }
}
