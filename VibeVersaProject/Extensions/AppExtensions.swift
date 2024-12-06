
import Foundation
import UIKit

extension Int{
    var autoSized : CGFloat{
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let diagonalSize = sqrt((screenWidth * screenWidth) + (screenHeight * screenHeight))
        let percentage = CGFloat(self)/987*100 //987 is the diagonal size of iphone xs max
        return diagonalSize * percentage / 100
    }
    
    var widthRatio: CGFloat {
        let width = UIScreen.main.bounds.width/414.0 //iphone xs max
        return CGFloat(self)*width
    }
    
}

extension UIColor {
    
    @nonobjc class var beige: UIColor {
        return UIColor(red: 255/255, green: 247/255, blue: 208/255, alpha: 1.0)
    }
    
    @nonobjc class var brown: UIColor {
        return UIColor(red: 76/255, green: 61/255, blue: 61/255, alpha: 1.0)
    }
    
    @nonobjc class var yellow: UIColor {
        return UIColor(red: 255/255, green: 199/255, blue: 0/255, alpha: 1.0)
    }
    @nonobjc class var darkBeige: UIColor {
        return UIColor(red: 251/255, green: 234/255, blue: 160/255, alpha: 1.0)
    }
    @nonobjc class var lightGray: UIColor {
        return UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
    }
}

extension UIViewController {
    private var loaderTag: Int { return 99999 } // A unique tag to identify the loader
    
    func showLoader() {
        // Check if a loader already exists to avoid duplications
        if let existingLoader = self.view.viewWithTag(loaderTag) {
            existingLoader.removeFromSuperview()
        }
        
        // Create and configure the loader
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .gray
        loader.tag = loaderTag
        loader.center = self.view.center
        loader.startAnimating()
        
        // Add the loader to the view
        self.view.addSubview(loader)
    }
    
    func hideLoader() {
        // Find and remove the loader
        if let loader = self.view.viewWithTag(loaderTag) {
            loader.removeFromSuperview()
        }
    }
}
