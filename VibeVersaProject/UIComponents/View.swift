
import Foundation
import UIKit

class View: UIView {
    init(backgroundcolor:UIColor, cornerradius:CGFloat = 0) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundcolor
        self.layer.cornerRadius = cornerradius
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
