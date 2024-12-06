
import Foundation
import UIKit

class TextField: UITextField {
        
    init(textTitle:String, backgroundcolor:UIColor = .white.withAlphaComponent(0.3), textfont:UIFont = .systemFont(ofSize: 18.autoSized)) {
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = textTitle
        self.autocorrectionType = UITextAutocorrectionType.no
        self.attributedPlaceholder = NSAttributedString(
            string: textTitle,
            attributes: [
                .foregroundColor: UIColor.black
            ]
        )
        self.textColor = .black
        self.backgroundColor = backgroundcolor
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.borderStyle = .none
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
