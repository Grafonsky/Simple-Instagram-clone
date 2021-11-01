import UIKit

enum Constans {
    static let imageModelsKey = "imageModelsKey"
}

class CommentController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var selectedIndex: Int?
    var models = [ImageDataModel]()
    var commentModels: [String] = []
    var commentUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "CommentTemplate", bundle: nil), forCellReuseIdentifier: "CommentTemplate")
    }
}

extension CommentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let commentsToPost = commentModels[indexPath.row]
        if let cell = tableview.dequeueReusableCell(withIdentifier: "CommentTemplate", for: indexPath) as? CommentTemplate {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.black
            cell.selectedBackgroundView = bgColorView
            cell.comment.text = commentsToPost
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
