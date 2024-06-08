//
//  PhotoSwipeCollectionViewController.swift
//  SnapShred
//
//  Created by Aditya on 5/24/24.
//

import UIKit

class PhotoSwipeCollectionViewController: UICollectionViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var images: [ImageDataEntity] = []
    var selectedImageIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAll()
        setSelfCollectionView()
        addPhotoInfoButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        fetchAll()
        collectionView.reloadData()
    }
    
    func fetchAll() {
        do {
            let allImageData = try context.fetch(ImageDataEntity.fetchRequest())
            images = allImageData
        } catch {
            print("Fetch execution failed.")
        }
    }
    
    func setSelfCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        // Register cell classes
        collectionView.register(PhotoSwipeCollectionViewCell.nib(), forCellWithReuseIdentifier: PhotoSwipeCollectionViewCell.cellIdentifier)
        
        DispatchQueue.main.async {
            self.collectionView.isPagingEnabled = false
            self.collectionView.scrollToItem(at: self.selectedImageIndex, at: .centeredHorizontally, animated: false)
            self.collectionView.isPagingEnabled = true
        }
    }
    
    fileprivate func addPhotoInfoButton() {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 25
        let info_icon = UIImage(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
        button.setImage(info_icon, for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        
        button.addTarget(self, action: #selector(toggleImageInfoSegue), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -36),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            button.widthAnchor.constraint(equalToConstant: 50),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func toggleImageInfoSegue() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let imageInfoVC = storyBoard.instantiateViewController(withIdentifier: "imageInfoViewController") as? ImageInfoViewController else { return }
        
        imageInfoVC.selectedImageIndex = getCurrentlyVisibleItem()
        
        imageInfoVC.onClose = {
            self.fetchAll()
            
            if self.images.count > 0 {
                self.collectionView.reloadData()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        self.present(imageInfoVC, animated: true)
    }
    
    func getCurrentlyVisibleItem() -> Int {
        guard let currentlyVisibleItemIndex = collectionView.indexPathsForVisibleItems.first else { return 0 }
        return currentlyVisibleItemIndex.item
    }

}

// MARK: UICollectionViewDataSource
extension PhotoSwipeCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSwipeCollectionViewCell.cellIdentifier, for: indexPath) as! PhotoSwipeCollectionViewCell
    
        // Configure the cell
        if let imageData = images[indexPath[1]].imageData {
            guard let uiImage = UIImage(data: imageData) else { return UICollectionViewCell() }
            cell.configure(image: uiImage)
        }
    
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension PhotoSwipeCollectionViewController {

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
