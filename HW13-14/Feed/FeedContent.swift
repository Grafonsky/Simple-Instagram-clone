import UIKit

struct CellData {
    let username: String
    let userPic: UIImage
    let namePic: String
    let userPost: UIImage
    let postDesc: String
}

var arrayOfCellData = [CellData]()

func getData() {
    arrayOfCellData = [
        CellData(username: "Admin", userPic: setPic("profilePic.png"), namePic: "1.jpeg", userPost: setPic("1.jpeg"), postDesc: "Default description by init #1"),
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
