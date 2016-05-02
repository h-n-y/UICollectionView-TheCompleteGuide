import UIKit

struct PhotoModel {
    var image: UIImage?
    var name: String
    
    static func photoModelWithName(name: String, image: UIImage?) -> PhotoModel {
        let photoModel = PhotoModel(image: image, name: name)
        return photoModel
    }
}