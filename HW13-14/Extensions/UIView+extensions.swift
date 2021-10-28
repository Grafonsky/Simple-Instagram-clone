import UIKit

extension UIView {
    
    func halfCornerRadius() {
        layer.cornerRadius = frame.height / 2
    }
    
    func addShadows(radius: CGFloat, opacity: Float) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func makeGradient(color1: UIColor, color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.cornerRadius = frame.height / 2
        gradient.frame = bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.opacity = 1
        layer.insertSublayer(gradient, at: 0)
    }
    
    func buttonBorder(color: UIColor, width: CGFloat) {
        backgroundColor = .clear
        layer.cornerRadius = layer.frame.height / 2
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
