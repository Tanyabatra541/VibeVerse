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
        contentView.addSubview(bubbleView)
        contentView.addSubview(messageLabel)

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with message: MessageModel, isSender: Bool) {
        messageLabel.text = message.text
        bubbleView.backgroundColor = isSender ? .yellow : .lightGray
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        if isSender {
            NSLayoutConstraint.activate([
                bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 100)
            ])
        } else {
            NSLayoutConstraint.activate([
                bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -100)
            ])
        }
    }
}
