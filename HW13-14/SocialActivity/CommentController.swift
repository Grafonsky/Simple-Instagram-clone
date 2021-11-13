import UIKit

class CommentController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var userpic: UIImageView!
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var commentViewConstraint: NSLayoutConstraint!
    
    
    var selectedIndex: Int?
    var models = [ImageDataModel]()
    var commentUsername: String?
    var commentUserpic: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        updateDataFromStorage()
        userpic.image = commentUserpic
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "CommentTemplate", bundle: nil), forCellReuseIdentifier: "CommentTemplate")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillAppear() {
        if commentViewConstraint.constant == 0 {
            commentViewConstraint.constant += 344
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillDisappear() {
        if commentViewConstraint.constant == 344 {
            commentViewConstraint.constant -= 344
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionHideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func actionSendComment(_ sender: Any) {
        sendComment()
    }
    
    func sendComment() {
        if commentTextfield.text != "" {
            guard let unwrapUsername = commentUsername else { return }
            guard let unwrapSelectedIndex = selectedIndex else { return }
            guard let comment = commentTextfield.text else { return }
            models[unwrapSelectedIndex].comments["@" + unwrapUsername + ": " + comment] = Date.now
        }
        saveData()
        commentTextfield.text = ""
        view.endEditing(true)
        tableview.reloadData()
    }
    
    func updateDataFromStorage() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let modelsData = defaults.value(forKey: Constans.imageModelsKey) as? Data,
           let decodedData = try? decoder.decode([ImageDataModel].self, from: modelsData) {
            models = decodedData
        }
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        let modelsData = try? encoder.encode(models)
        defaults.set(modelsData, forKey: Constans.imageModelsKey)
    }
}

extension CommentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let unwrapSelectedIndex = selectedIndex else { return UITableViewCell() }
        let commentsToPost = Array(models[unwrapSelectedIndex].comments)
        let sortedCommentsToPost = commentsToPost.sorted { $0.value < $1.value }
        if let cell = tableview.dequeueReusableCell(withIdentifier: "CommentTemplate", for: indexPath) as? CommentTemplate {
            let comment = sortedCommentsToPost[indexPath.row].key
            let isoDate = sortedCommentsToPost[indexPath.row].value
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm / dd.MM.yy"
            let stringDate = dateFormatter.string(from: isoDate)
            cell.comment.text = comment
            cell.dateLabel.text = stringDate
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrapSelectedIndex = selectedIndex else { return 0 }
        return models[unwrapSelectedIndex].comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
