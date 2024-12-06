
import Foundation
import UIKit
import FirebaseFirestore


class UserCell: UITableViewCell {
    static let identifier = "UserCell"
    
    private let profileImageView = ImageView(imagetitle: "")
    private let nameLabel = Label(textcolor: .black, font: .systemFont(ofSize: 18, weight: .bold))
    private let occupationLabel = Label(textcolor: .black, font: .systemFont(ofSize: 16))
    private let experienceLabel = Label(textcolor: .black, font: .systemFont(ofSize: 14))
    private let viewProfileButton = ButtonWithLabel(title: "View Profile", font: .systemFont(ofSize: 14), backgroundColor: .brown, titlecolor: .white)
    
    var viewProfileTapped: (()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 10.autoSized
        viewProfileButton.layer.cornerRadius = 20.autoSized
        self.selectionStyle = .none
        viewProfileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        let cardView = View(backgroundcolor: .yellow, cornerradius: 15)
        contentView.addSubview(cardView)
        cardView.addSubview(profileImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(occupationLabel)
        cardView.addSubview(experienceLabel)
        cardView.addSubview(viewProfileButton)
        
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.autoSized),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.widthRatio),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.widthRatio),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.autoSized),
            
            profileImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15.widthRatio),
            profileImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60.autoSized),
            profileImageView.heightAnchor.constraint(equalToConstant: 60.autoSized),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15.widthRatio),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30.autoSized),
            
            occupationLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15.widthRatio),
            occupationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.autoSized),
            
            experienceLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15.widthRatio),
            experienceLabel.topAnchor.constraint(equalTo: occupationLabel.bottomAnchor, constant: 5.autoSized),
            
            viewProfileButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15.widthRatio),
            viewProfileButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -15.autoSized),
            viewProfileButton.widthAnchor.constraint(equalToConstant: 120.autoSized),
            viewProfileButton.heightAnchor.constraint(equalToConstant: 40.autoSized)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: UsersModel) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        occupationLabel.text = user.email ?? "No Email Provided"
        experienceLabel.text = user.workLink ?? "No Work Link"
        profileImageView.image = UIImage(named: "placeholder") // A placeholder image
        
        // Fetch and update the profile image asynchronously
        user.fetchProfileImage { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImageView.image = image ?? UIImage(named: "placeholder")
            }
        }
    }

    @objc func profileButtonTapped() {
        viewProfileTapped?()
    }
}
