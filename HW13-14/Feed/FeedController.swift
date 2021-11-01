import UIKit

class FeedController: UITableViewController {
    @IBOutlet var tableview: UITableView!
    
    var username: String?
    var profilePic: UIImage?
    var selectedIndex: Int = 0
    var models = [ImageDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableview.dataSource = self
        tableView.register(UINib(nibName: "PostTemplate", bundle: Bundle(for: CustomCell.self)), forCellReuseIdentifier: "PostTemplate")
        updateDataFromStorage()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = arrayOfCellData[indexPath.row]
        if let cell = Bundle.main.loadNibNamed("PostTemplate", owner: self, options: nil)?.first as? CustomCell {
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = bgColorView
            cell.uernameCommentPic.image = profilePic
            cell.usernameLabel.text = post.username
            cell.usernamePostPic.image = post.userPic
            cell.uernameCommentPic.image = profilePic
            cell.postDesc.text = post.postDesc
            cell.postPic.image = post.userPost
            cell.backgroundColor = UIColor.clear
            var modelObject = models[indexPath.row]
            print(modelObject)
            if checkIfUserLike(modelObject: modelObject) == true {
                cell.isLiked.image = UIImage(named: "like.png")
            } else {
                cell.isLiked.image = UIImage(named: "notLike.png")
            }
            cell.addComment = {[weak self] in
                if cell.textfieldComment.text != "" {
                    guard let unwrapUsername = self?.username else { return }
                    guard let unwrapComment = cell.textfieldComment.text else { return }
                    modelObject.comments.append("@" + unwrapUsername + ": " + unwrapComment)
                    cell.textfieldComment.text = ""
                    self?.view.endEditing(true)
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Add a comment!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true)
                    }
                }
            cell.onComments = {[weak self] in
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                if let controller = storyboard.instantiateViewController(withIdentifier: "CommentID") as? CommentController {
                    controller.selectedIndex = indexPath.row
                    controller.commentModels = modelObject.comments
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            }
            cell.onLike = {[weak self] in
                self?.selectedIndex = indexPath.row
                if let unwrapUsername = self?.username {
                    if self?.isLiked() == false {
                        cell.isLiked.image = UIImage(named: "notLike.png")
                    } else {
                        cell.isLiked.image = UIImage(named: "like.png")
                    }
                }
                print(modelObject.whoLiked)
            }
            return cell
        }
        return UITableViewCell.init(frame: CGRect(x: self.view.frame.midX - self.view.frame.width / 2, y: self.view.frame.midY - self.view.frame.height / 2, width: 414, height: 200))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillAppear() {
        if view.frame.origin.y == 0 {
            view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: view.frame.origin.y - 324)
        }
    }

    @objc func keyboardWillDisappear() {
        if view.frame.origin.y == -324 {
            view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: view.frame.origin.y + 324)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func checkIfUserLike(modelObject: ImageDataModel) -> Bool {
        guard let unwrapName = username else { return false }
        var isThatUser: Bool = false
        if modelObject.whoLiked.contains(unwrapName) {
            isThatUser = true
        } else {
            isThatUser = false
        }
        return isThatUser
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        print(selectedIndex)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 679
    }
    
    func updateDataFromStorage() {
        print(NSHomeDirectory())
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let modelsData = defaults.value(forKey: Constans.imageModelsKey) as? Data,
           let decodedData = try? decoder.decode([ImageDataModel].self, from: modelsData) {
            models = decodedData
        } else {
            let myArray = fillArr()
            models = myArray.map { ImageDataModel(name: $0, whoLiked: [], comments: []) }
            saveData()
        }
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        let modelsData = try? encoder.encode(models)
        defaults.set(modelsData, forKey: Constans.imageModelsKey)
    }
    
    func isCorrectIndex(index: Int) -> Bool {
        return index >= 0 && index < models.count
    }
    
    func isLiked() -> Bool {
        guard let unwrapName = username else { return false }
        var model = models[selectedIndex]
        var likeStatus: Bool
        if checkIfUserLike(modelObject: models[selectedIndex]) == true {
            if let index = model.whoLiked.firstIndex(of: unwrapName) {
                models[selectedIndex].whoLiked.remove(at: index)
            }
            likeStatus = false
        } else {
            models[selectedIndex].whoLiked.append(unwrapName)
            likeStatus = true
        }
        saveData()
        return likeStatus
    }
    
    @IBAction func actionHideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}

