import UIKit

class LogInControllerController: UIViewController {
    @IBOutlet weak var buttonLogIn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var username: String?
    var profilePic: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButtons()
    }
    
    func configButtons() {
        buttonLogIn.buttonBorder(color: .systemBlue, width: 2)
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func actionLogIn(_ sender: Any) {
        guard let checkFieldName = usernameTextField.text?.isEmpty else { return }
        guard let checkFieldPass = passwordTextField.text?.isEmpty else { return }
        if checkFieldName == true || checkFieldPass == true {
            let alert = UIAlertController(title: "Alert", message: "Fill all the fields!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        guard let username: String = usernameTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        if getProfile(name: username, pass: password) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "PicSceneID") as? PictureSceneController {
                controller.username = username
                controller.profilePic = profilePic
                navigationController?.pushViewController(controller, animated: true)
            }
            
        }
    }
    
    func getProfile(name: String, pass: String) -> Bool {
        let defaults = UserDefaults.standard
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let unwrapPassword: String = defaults.value(forKey: name) as? String {
            if pass == unwrapPassword && defaults.object(forKey: name) != nil {
                username = name
                let picName = String(name) + ".jpg"
                let picURL = documentsDirectory.appendingPathComponent(picName)
                profilePic = UIImage(contentsOfFile: picURL.path)
                return true
            }
        }
        let alert = UIAlertController(title: "Warning", message: "Wrong username or password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        
        return false
    }
    
}
