import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernamePostPic: UIImageView!
    @IBOutlet weak var uernameCommentPic: UIImageView!
    @IBOutlet weak var postDesc: UITextView!
    @IBOutlet weak var postPic: UIImageView!
    @IBOutlet weak var isLiked: UIImageView!
    @IBOutlet weak var textfieldComment: UITextField!
    
    var onComments: (() -> ())?
    var addComment: (() -> ())?
    var onLike: (() -> ())?
    var likeStatus: Bool?

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    func config() {
        usernamePostPic.halfCornerRadius()
        uernameCommentPic.halfCornerRadius()
    }
    
    @IBAction func openComments(_ sender: Any) {
        onComments?()
    }
    
    @IBAction func actionLike(_ sender: Any) {
        onLike?()
    }
}
