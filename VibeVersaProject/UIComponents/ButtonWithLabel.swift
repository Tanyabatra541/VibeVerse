

import Foundation
import UIKit

class ButtonWithLabel: UIButton {
    
    required init(title: String!, font: UIFont = UIFont.systemFont(ofSize: 18.autoSized), backgroundColor: UIColor = .black, titlecolor: UIColor = .black, cornerRadius: CGFloat = 0.0, tag: Int = 0 ) {
        super.init(frame: .zero)
        super.translatesAutoresizingMaskIntoConstraints = false
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: (font.fontName), size: CGFloat(Int(font.pointSize).autoSized))
        layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.tag = tag
        setTitleColor(titlecolor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
