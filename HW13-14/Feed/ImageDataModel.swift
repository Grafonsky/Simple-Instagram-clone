struct ImageDataModel: Codable {
    let name: String
    var whoLiked: [String]
    var comments: [String]
}

var myArr: [String] = []

func fillArr() -> [String] {
    arrayOfCellData.map {object in
        myArr.append(object.namePic)
    }
    return myArr
}
