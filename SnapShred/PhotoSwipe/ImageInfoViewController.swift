//
//  ImageInfoViewController.swift
//  SnapShred
//
//  Created by Aditya on 5/25/24.
//

import UIKit
import Photos

class ImageInfoViewController: UIViewController {
    
    var onClose: (() -> Void)?

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var dateCapturedLabel: UILabel!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedImageIndex: Int!
    var selectedImageData: ImageDataEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchSelected()
    }
    
    func fetchSelected() {
        do {
            let fetchedImageData = try context.fetch(ImageDataEntity.fetchRequest())
            selectedImageData = fetchedImageData[selectedImageIndex]
            
            setUIElements()
        } catch {
            print("Fetch execution failed.")
        }
    }
    
    func setUIElements() {
        guard let selectedImageDataTemp = selectedImageData else { return }
        
        if let previewImage = selectedImageDataTemp.imageData {
            previewImageView.image = UIImage(data: previewImage)
        }
        
        timerLabel.text = String(selectedImageDataTemp.lifetime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE • MMMM dd, yyyy • h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")

        if let dateCreated = selectedImageDataTemp.dateCreated {
            dateCapturedLabel.text = dateFormatter.string(from: dateCreated)
            timeRemainingLabel.text = String(Int(selectedImageData.lifetime) - Int(Date().timeIntervalSince(dateCreated)))
        }
    }
    
    // Check this method once to see why the app is closing automatically.
    @IBAction func deleteAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.context.delete(self.selectedImageData)
            do {
                try self.context.save()
                self.dismiss(animated: true) {
                    self.onClose?()
                }
            } catch {
                print("Context save Action unsuccessful")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "This action will save the image to photos?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if let currentImage = self.selectedImageData.imageData {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: UIImage(data: currentImage)!)
                }) { success, error in
                    if success {
                        print("Image Saved Successfully")
                    } else {
                        print("Image Save Failed")
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        guard let imageData = selectedImageData.imageData else { return }
        
        let images: [Any] = [UIImage(data: imageData)!, self]
        let activityVC = UIActivityViewController(activityItems: images, applicationActivities: nil)
        present(activityVC, animated: true)
        
    }
}

extension ImageInfoViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
        guard let imageData = selectedImageData.imageData else { return nil }
        return UIImage(data: imageData)
    }
}
