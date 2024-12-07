import UIKit

class ChatMessageCell: UITableViewCell {
    static let identifier = "ChatMessageCell"

    private let bubbleView = UIView()
    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        bubbleView.layer.cornerRadius = 15
        bubbleView.clipsToBounds = true

        messageLabel.numberOfLines = 0 // Enable multi-line support
        messageLabel.font = .systemFont(ofSize: 16)

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15),

            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with message: MessageModel, isSender: Bool) {
        messageLabel.text = message.text
        bubbleView.backgroundColor = isSender ? .yellow : .lightGray

        if isSender {
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 100).isActive = true
        } else {
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -100).isActive = true
        }
    }
}
