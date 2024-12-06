
import Foundation
import UIKit

class ButtonWithImage: UIButton {
    init(imageName: String = "", systemName: String = "", backgroundColor: UIColor = .clear, cornerRadius: Int = 0, tintColor: UIColor = .black) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setImage(systemName == "" ? UIImage(named: imageName) : UIImage(systemName: systemName), for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.layer.cornerRadius = cornerRadius.autoSized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
