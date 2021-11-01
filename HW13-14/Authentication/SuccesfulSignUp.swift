import UIKit

class SuccesfulSignUp: UIView {

    var onClose: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func actionDismiss(_ sender: Any) {
//        self.removeFromSuperview()
        onClose?()
    }
    
}

