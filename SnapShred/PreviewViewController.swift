//
//  PreviewViewController.swift
//  SnapShred
//
//  Created by Aditya on 5/18/24.
//

import UIKit
import CoreData

class PreviewViewController: UIViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var timePickerOutlet: UISegmentedControl!
    
    enum timer: Int, CaseIterable {
        case HALF_MINUTE = 30
        case ONE_MINUTE = 60
        case HOUR = 3_600
        case DAY = 86_400
    }
    
    var previewImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOutlet.image = previewImage
    }
    
    func closeSegueAction() {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let imageData = previewImage.jpegData(compressionQuality: 1.0) else { return }
        
        let newImageDataEntity = ImageDataEntity(context: context)
        newImageDataEntity.id = UUID()
        newImageDataEntity.dateCreated = Date()
        newImageDataEntity.imageData = imageData
        
        let timer_value = timer.allCases[timePickerOutlet.selectedSegmentIndex].rawValue
        newImageDataEntity.lifetime = Int64(timer_value)
        
        do {
            try context.save()
            closeSegueAction()
        } catch {
            print("CoreData save action failed.")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
