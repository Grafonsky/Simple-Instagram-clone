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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillAppear() {
        if view.frame.origin.y == 0 {
            view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: view.frame.origin.y - 50)
        }
    }

    @objc func keyboardWillDisappear() {
        if view.frame.origin.y == -50 {
            view.transform = CGAffineTransform(translationX: view.frame.origin.x, y: view.frame.origin.y + 50)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
            if let controller = storyboard.instantiateViewController(withIdentifier: "FeedID") as? FeedController {
                controller.username = username
                controller.profilePic = profilePic
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .crossDissolve
                present(controller, animated: true)
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
