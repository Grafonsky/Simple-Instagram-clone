import UIKit

class CommentTemplate: UITableViewCell {
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
