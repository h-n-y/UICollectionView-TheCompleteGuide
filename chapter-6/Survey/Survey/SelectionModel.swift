import UIKit

let SelectionModelNoSelectionIndex = 0

struct SelectionModel {
    
    // MARK: Class 
    
    static let SelectionModelNoSelectionIndex = -1
    
    static func selectionModelWithPhotoModels(photoModels: Array<PhotoModel>) -> SelectionModel {
        let model = SelectionModel(photoModels: photoModels, selectedPhotoModelIndex: SelectionModelNoSelectionIndex)
        return model
    }
    
    // MARK: Instance
    
    var photoModels: Array<PhotoModel>
    var selectedPhotoModelIndex: Int
    var hasBeenSelected: Bool {
        return self.selectedPhotoModelIndex != SelectionModel.SelectionModelNoSelectionIndex
    }

}