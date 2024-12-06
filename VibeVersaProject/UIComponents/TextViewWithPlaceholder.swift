
import Foundation
import UIKit

class TextViewWithPlaceholder: UITextView {

    let placeholderLabel = Label(texttitle: "", textcolor: .gray, font: .systemFont(ofSize: 14), numOflines: 0, textalignment: .left)

    init(placeholder: String, backgroundColor: UIColor, cornerRadius: CGFloat) {
        super.init(frame: .zero, textContainer: nil)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.textColor = .black
        self.font = .systemFont(ofSize: 14)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = placeholder


        self.addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.widthRatio),
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.autoSized),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10.widthRatio),
        ])

        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextViewWithPlaceholder: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
