//
//  ViewController.swift
//  SnapShred
//
//  Created by Aditya on 5/5/24.
//

import UIKit
import CoreData

class GalleryViewController: UICollectionViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photoDataList: [ImageDataEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewLayout()
        
        title = "Gallery"
    }
    
    func setupCollectionViewLayout() {
        let fixedSize = (collectionView.frame.size.width/3) - 2
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: fixedSize, height: fixedSize)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
//        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchAll()
        
        collectionView.reloadData()
    }
    
    func fetchAll() {
        do {
            let allImageData = try context.fetch(ImageDataEntity.fetchRequest())
            photoDataList = allImageData
        } catch {
            print("Fetch execution failed.")
        }
    }


}

extension GalleryViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellIdentifier, for: indexPath) as! CollectionViewCell
        
        if let image = photoDataList[indexPath[1]].imageData,
            let uiImage = UIImage(data: image) {
            cell.configure(with: uiImage)
        }
        
        return cell
    }
}

extension GalleryViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let photoSwipeView = storyBoard.instantiateViewController(withIdentifier: "photoSwipeViewController") as? PhotoSwipeCollectionViewController else { return }
//        photoSwipeView.images = photoDataList
        photoSwipeView.selectedImageIndex = indexPath
        
        self.navigationController?.pushViewController(photoSwipeView, animated: true)
    }
}
