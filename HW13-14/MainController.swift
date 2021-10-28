import UIKit

class MainController: UIViewController {
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonLogIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButtons()
        print(NSHomeDirectory())
    }
    
    func configButtons() {
        buttonSignUp.buttonBorder(color: .systemBlue, width: 2)
        buttonLogIn.buttonBorder(color: .systemBlue, width: 2)
    }

    @IBAction func actionSignUp(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpID")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionLogIn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LogInID")
        navigationController?.pushViewController(controller, animated: true)
    }
}

