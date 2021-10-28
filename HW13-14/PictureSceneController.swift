import UIKit

class PictureSceneController: UIViewController {
    @IBOutlet weak var buttomAddPic: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userPicView: UIImageView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var commentField: UITextField!
    
    var username: String?
    var profilePic: UIImage?
    
    weak var pickImage: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
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
    
    
    func config() {
        userPicView.image = profilePic
        usernameLabel.text = username
        buttomAddPic.buttonBorder(color: .systemBlue, width: 2)
        if imageView.image == nil {
            commentView.alpha = 0
            labelDescription.alpha = 0
            descriptionTextView.alpha = 0
        }
        descriptionTextView.isEditable = false
    }
    
    @IBAction func actionAddPic(_ sender: Any) {
        pickImage = getImage()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func sendDescription(_ sender: Any) {
        if commentField.text != "" {
            descriptionTextView.text = commentField.text
            view.endEditing(true)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Set a description", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
        commentField.text = ""
    }
    
    func getImage() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        return picker
    }

}

extension PictureSceneController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        imageView.image = image
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.commentView.alpha = 1
            self.labelDescription.alpha = 1
            self.descriptionTextView.alpha = 1
        })
        picker.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
