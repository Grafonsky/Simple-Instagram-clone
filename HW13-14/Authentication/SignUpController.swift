import UIKit

class SignUpController: UIViewController {
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var choosenPic: UIImageView!
    @IBOutlet weak var buttonPickImage: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var pickImage: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        blur.effect = nil
        blur.isHidden = true
        buttonSignUp.buttonBorder(color: .systemBlue, width: 2)
    }
    
    @IBAction func actionChoosePic(_ sender: Any) {
        pickImage = getImage()
    }
    
    @IBAction func actionHideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func getImage() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        return picker
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        guard let checkFieldName = nameTextField.text?.isEmpty else { return }
        guard let checkFieldPass = passwordTextField.text?.isEmpty else { return }
        if checkFieldName == true || checkFieldPass == true {
            emptyFieldsAlert()
        }
        guard let name: String = nameTextField.text else { return }
        guard let password: String = passwordTextField.text else { return }
        guard let pic: UIImage = choosenPic.image else { return }
        
        let alert = UIAlertController(title: "Sign Up", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {isYes in
            self.saveProfile(name: name, pass: password, pic: pic)
            UIView.animate(withDuration: 0.3) {
                self.blur.isHidden = false
                self.blur.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            }
            self.addCustomAlert()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func emptyFieldsAlert() {
        let alert = UIAlertController(title: "Warning", message: "Fill the field w/ name or password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func addCustomAlert() {
        let succesfulSignUp = Bundle.loadView(fromNib: "SuccesfulSignUp", withType: SuccesfulSignUp.self)
        succesfulSignUp.frame = CGRect(x: view.frame.midX - succesfulSignUp.frame.width / 2, y: view.frame.midY - succesfulSignUp.frame.width / 2, width: succesfulSignUp.frame.width, height: succesfulSignUp.frame.height)
        succesfulSignUp.onClose = {[weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        succesfulSignUp.addShadows(radius: 25, opacity: 0.66)
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(succesfulSignUp)
            self.view.layoutIfNeeded()
        })
        
    }
    
    func saveProfile(name: String, pass: String, pic: UIImage) {
        let defaults = UserDefaults.standard
        defaults.set(pass, forKey: name)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = String(name) + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print(fileURL)
        if let data = pic.jpegData(compressionQuality:  1.0),
           !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
}

extension Bundle {
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        fatalError("Couldn't load view w/ this type " + String(describing: type))
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        choosenPic.image = image
        buttonPickImage.alpha = 0.3
        picker.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
