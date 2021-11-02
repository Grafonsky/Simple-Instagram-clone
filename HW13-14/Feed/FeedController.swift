import UIKit

struct CellData {
    let username: String
    let userPic: UIImage
    let namePic: String
    let userPost: UIImage
    let postDesc: String
}

class FeedController: UITableViewController {
    @IBOutlet var tableview: UITableView!
    
    var username: String?
    var profilePic: UIImage?
    var selectedIndex: Int = 0
    var models = [ImageDataModel]()
    var arrayOfCellData = [CellData]()
    var myArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
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
            if checkIfUserLike(modelObject: models[indexPath.row]) == true {
                cell.isLiked.image = UIImage(named: "like.png")
            } else {
                cell.isLiked.image = UIImage(named: "notLike.png")
            }
            cell.onComments = {[weak self] in
                self?.selectedIndex = indexPath.row
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                if let controller = storyboard.instantiateViewController(withIdentifier: "CommentID") as? CommentController {
                    guard let unwrapModels = self?.models else { return }
                    controller.selectedIndex = indexPath.row
                    controller.commentUsername = self?.username
                    controller.commentUserpic = self?.profilePic
                    self?.present(controller, animated: true)
                }
            }
            cell.onLike = {[weak self] in
                self?.selectedIndex = indexPath.row
                if self?.isLiked() == false {
                    cell.isLiked.image = UIImage(named: "notLike.png")
                } else {
                    cell.isLiked.image = UIImage(named: "like.png")
                }
                self?.saveData()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func getData() {
        arrayOfCellData = [
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "1.jpeg", userPost: setPic("1.jpeg"), postDesc: "Default Default Def aultD efau ltDef aultDef aultDe fault desc ript ion by init #1"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "2.jpeg", userPost: setPic("2.jpeg"), postDesc: "Default description by init #2"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "3.png", userPost: setPic("3.png"), postDesc: "Default description by init #3"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "4.jpeg", userPost: setPic("4.jpeg"), postDesc: "Default description by init #4"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "5.jpeg", userPost: setPic("5.jpeg"), postDesc: "@NinjaTheory: Now hiring: IT Technician."),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "6.jpeg", userPost: setPic("6.jpeg"), postDesc: "Default description by init #6"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "7.jpg", userPost: setPic("7.jpg"), postDesc: "Default description by init #7"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "8.jpg", userPost: setPic("8.jpg"), postDesc: "Default description by init #8"),
            CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "9.jpg", userPost: setPic("9.jpg"), postDesc: "Default description by init #9")
        ]
    }
    
    func setPic(_ pic: String) -> UIImage {
        if let unwrapPic = UIImage(named: pic) {
            return unwrapPic
        } else {
            return UIImage()
        }
    }
    
    func fillArr() -> [String] {
        arrayOfCellData.map {object in
            myArr.append(object.namePic)
        }
        return myArr
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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 631
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
            models = myArray.map { ImageDataModel(name: $0, whoLiked: [], comments: [:]) }
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
        let model = models[selectedIndex]
        if checkIfUserLike(modelObject: models[selectedIndex]) == true {
            if let index = model.whoLiked.firstIndex(of: unwrapName) {
                models[selectedIndex].whoLiked.remove(at: index)
            }
            return false
        }
        models[selectedIndex].whoLiked.append(unwrapName)
        return true
        }
    
    func addComment(string: String) {
        if string != "" {
            guard let unwrapUsername = username else { return }
            models[selectedIndex].comments["@" + unwrapUsername + ": " + string] = Date.now
            saveData()
        } else {
            let alert = UIAlertController(title: "Alert", message: "Add a comment!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
}
