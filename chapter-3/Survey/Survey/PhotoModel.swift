import UIKit

struct PhotoModel {
    
    static func photoModelWithName(name: String, image: UIImage?) -> PhotoModel {
        let model = PhotoModel(name: name, image: image)
        return model 
    }
    
    var name: String
    var image: UIImage?
}