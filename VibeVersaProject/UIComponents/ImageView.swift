
import Foundation
import UIKit

class ImageView: UIImageView {
    init(imagetitle:String = "", systemName: String = "", imagecolor:UIColor = .clear) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = systemName == "" ? UIImage(named: imagetitle) : UIImage(systemName: systemName)
        self.tintColor = imagecolor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

