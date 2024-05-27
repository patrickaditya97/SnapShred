//
//  ImageInfoViewController.swift
//  SnapShred
//
//  Created by Aditya on 5/25/24.
//

import UIKit

class ImageInfoViewController: UIViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var dateCapturedLabel: UILabel!
    
    var selectedImageData: ImageDataEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUIElements()
    }
    
    func setUIElements() {
        guard let selectedImageData = selectedImageData else { return }
        
        if let previewImage = selectedImageData.imageData {
            previewImageView.image = UIImage(data: previewImage)
        }
        
        timerLabel.text = String(selectedImageData.lifetime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE • MMMM dd, yyyy • h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")

        if let dateCreated = selectedImageData.dateCreated {
            dateCapturedLabel.text = dateFormatter.string(from: dateCreated)
        }
    }
}
